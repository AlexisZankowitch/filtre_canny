////////////////////////////////////////////////////////////////////////////////
//Alexis Zankowitch...........................................................//
//............................................................................//
// ..........................FILTRE DE CANNY..................................//
//............................................................................//
//............................................................................//
////////////////////////////////////////////////////////////////////////////////

//Start
function cannyFilter(base_path, step_hist, threshold,factorTh,img)
    
    //imgs
//    base_path = "/home/zank/git/filtre_canny/";

    if isnum(img) then
        select img
        case "1" then
            img = strcat([base_path,'/grayflower.png']);
        case "2" then
            img = strcat([base_path,'/sonia.png']);
        case "3" then 
            img = strcat([base_path,'/canny.jpg']);
        case "4" then
            img = strcat([base_path,'/Twitter-logo2.png']);
        end
    end
    
    //variables
//    step_hist = 120;
//    threshold = 0.85;
//    factorTh = 0.5;
    
    //mask wich can be used
    maskx=[1,2,1];
    masky=[1,2,1]';
    mask3=[1,2,1;2,4,2;1,2,1];
    mask5=[1,2,4,2,1;2,4,8,4,2;4,8,16,8,4;2,4,8,4,2;1,2,4,2,1]
    
    algorithm(img,0,mask5,step_hist,threshold);
    
endfunction

//start canny filter
function algorithm(img,gray,mask,step_hist,threshold)
    matrix_image = chargerImage(img,gray);
    matrix_image = matrix_image(:,:,1);
    
    disp('MASK APPLICATION');
    [matrix_imageB,x,y] = mask_application(matrix_image,mask);
    disp('MASKING');
    matrix_masked = masking(matrix_imageB, mask);
    disp('GRADIENT');
    [mat_n_grad,mat_a_grad] = gradient(matrix_masked);
    disp('MAXIMUM SUPPRESSION');
    matrice_nMax = deleteNMax(mat_n_grad,mat_a_grad);
    disp('HISTERESIS');
    disp('  seuil:');
    [th,t1] = threshold_determination(mat_n_grad,step_hist,threshold);
    disp(threshold);
    matrix_hysteresis = hysteresis(matrice_nMax,mat_a_grad,th,t1);

    //resize matrix 
    mat_nMax_croped = matrice_nMax(x,y);
    mat_hyst_cropped = matrix_hysteresis(x,y);
    matrix_masked_cropped = matrix_masked(x,y);
    matrix_images = [matrix_image matrix_masked_cropped mat_nMax_croped mat_hyst_cropped];
    afficherImage(matrix_images);
endfunction

//Extend image
function [matrix_image_bigger,x,y] = mask_application(matrix_image,mask)
    
    mid_size_mask_x=floor(size(mask,1)/2);
    mid_size_mask_y=floor(size(mask,2)/2);
    
//    image extension
    matrix_image_bigger = zeros(size(matrix_image,1)+2*mid_size_mask_x,size(matrix_image,2)+2*mid_size_mask_y)
    
//    image placement
    x= mid_size_mask_x+1:size(matrix_image_bigger,1)-(mid_size_mask_x);
    y= mid_size_mask_y+1:size(matrix_image_bigger,2)-(mid_size_mask_y);
    matrix_image_bigger(x,y)=matrix_image;
    
endfunction

//    2 boucles pour la matric 2 boucle pour le masque faire la somme des produits des case de meme indice et les stocker dans la case
function matrix_masked = masking(matrix_image,mask_f)
//    loop begins where the picture is
    mid_size_mask_x=floor(size(mask_f,1)/2);
    mid_size_mask_y=floor(size(mask_f,2)/2);
    max_x = size(matrix_image,1)-mid_size_mask_x;
    max_y = size(matrix_image,2)-mid_size_mask_y;
    start_x = mid_size_mask_x +1;
    start_y = mid_size_mask_y +1;
    sum_mask = sum(mask_f);
    if sum_mask == 0 then
        sum_mask = 1;
    end
    xx = 0;
    yy = 0;
    matrix_masked = matrix_image;
    for x = start_x:max_x
        for y = start_y:max_y
            acc_mask = 0;
            for i = 1:size(mask_f,1)
                for j = 1:size(mask_f,2)
                    mult = mask_f(i,j) * matrix_image(xx+i,yy+j);
                    acc_mask = (acc_mask + mult)
                end
            end
            matrix_masked(x,y)=acc_mask/sum_mask;
            yy=yy+1;
        end
        yy=0;
        xx=xx+1;
    end
    //xx & yy voyage dans l'image pour la multiplication avec le masque
endfunction

function [mat_n_grad,mat_a_grad] = gradient(matrix_image)
    //variables
    gradx = [-1,0,1];
    grady = [-1,0,1]';
    mat_n_grad = matrix_image;
    mat_a_grad = matrix_image;
    mat_grad = matrix_image;
    
    //gradient calculation
    mat_grad_x = masking(matrix_image,gradx);
    mat_grad_y = masking(matrix_image,grady);
    
    for i = 1 : size(mat_grad,1)
        for j = 1 : size(mat_grad,2)
            
            mat_n_grad(i,j) = sqrt(mat_grad_x(i,j) ^ 2 + mat_grad_y(i,j) ^ 2);
            mat_a_grad(i,j) = atan(-mat_grad_x(i,j),mat_grad_y(i,j))
                        
            //normalisation
            //degree 
            mat_a_grad(i,j) = 180 * mat_a_grad(i,j) / %pi
            mat_a_grad(i,j) = normalisation(mat_a_grad(i,j));
        end
    end
endfunction

function val = normalisation(val)
    val_check = [0,45,90,135];    
    if val < -22.5 then
        val = val + 180;
    elseif val >= -22.5 & val < 22.5 then
        val = 0;
    elseif val >= 22.5 & val < 67.5 then
        val = 45;
    elseif val >= 67.5 & val < 112.5 then
        val = 90;
    elseif val > 112.5 & val < 157.5 then
        val = 135;
    else
        val = val - 180;
    end
    if size(find(val_check==val),1) == 0 then
        val = normalisation(val);
    end
endfunction

//non max suppression
function matrice_nMax = deleteNMax(mat_n_grad, mat_a_grad)
    matrice_nMax = mat_n_grad;
    for i = 1 : size(mat_n_grad,1)
        for j = 1 : size(mat_n_grad,2)
            select mat_a_grad(i,j)
            case 0 then
                if(mat_n_grad(i,j) > get_pixel(mat_n_grad,i-1,j) & mat_n_grad(i,j) > get_pixel(mat_n_grad,i+1,j)) then
                    matrice_nMax(i,j) = mat_n_grad(i,j);
                else
                    matrice_nMax(i,j) = 0;
                end
            case 45 then
                if(mat_n_grad(i,j) > get_pixel(mat_n_grad,i+1,j-1) & mat_n_grad(i,j) > get_pixel(mat_n_grad,i-1,j+1)) then
                    matrice_nMax(i,j) = mat_n_grad(i,j);
                else
                    matrice_nMax(i,j) = 0;
                end
            case 90 then
                if(mat_n_grad(i,j) > get_pixel(mat_n_grad,i,j-1) & mat_n_grad(i,j) > get_pixel(mat_n_grad,i,j+1)) then
                    matrice_nMax(i,j) = mat_n_grad(i,j);
                else
                    matrice_nMax(i,j) = 0;
                end
            case 135 then
                if(mat_n_grad(i,j) > get_pixel(mat_n_grad,i-1,j-1) & mat_n_grad(i,j) > get_pixel(mat_n_grad,i+1,j+1)) then
                    
                    matrice_nMax(i,j) = mat_n_grad(i,j);
                else
                    matrice_nMax(i,j) = 0;
                end
            end
        end
    end    
endfunction


//solves indexes issues
function pixel = get_pixel(mat, i, j)
    if(i >= 1 & j >=1 & i <= size(mat,1) & j <= size(mat,2))
        pixel = mat(i,j);
    else
        pixel = -1;
    end
endfunction

//Hysteresis
function [th,t1] = threshold_determination(matrix_n,hist_p,threshold)
//    round matrix n
    for (i = 1 : size(matrix_n,1))
        for (j = 1 : size(matrix_n,2))
            matrix_norm(i,j) = floor(matrix_n(i,j));
        end
    end
    
//    histogram
    max_m = max(matrix_norm);
    min_m = min(matrix_norm);
    val_m = max_m-min_m;
    step = (max_m - min_m)/hist_p;
    hist = zeros(1,hist_p+1);
    hist_x = hist;
    hist_x(1,1)=0;
    for (i=2 : size(hist_x,2))
        hist_x(1,i) = step + hist_x(1,i-1);
    end
    for (i = 1 : size(matrix_norm,1))
        for (j = 1 : size(matrix_norm,2))
            pos = (floor(((matrix_norm(i,j) - min_m )) / step)+1);
            hist(1,pos) = hist(1,pos) +1;
        end
    end
    
    subplot(121);
    histplot(round(hist_x),hist(1,:),style=5);
    
//    fonction de repartition
    matrix_repar = hist/sum(hist);
    matrix_repar = cumsum(matrix_repar);
    subplot(122);
    plot([min_m:step:max_m],matrix_repar(1,:),'b-o');
    
//    threshold 
    c = 1;
    while threshold > matrix_repar(1,c)
        c = c + 1;
    end
    if c > 1 then
        s_max = matrix_repar(1,c) - threshold;
        s_min = threshold - matrix_repar(1,c-1);  
        if s_max > s_min then
            c = c-1
        end
    end
    
//    th & t1 
    th = round(hist_x(1,c));
    t1 = factorTh * th;
endfunction

function matrix_hysteresis=hysteresis(matrice_nMax,mat_a_grad,th,t1)
    matrix_hysteresis = zeros(size(matrice_nMax));
    for i=1 : size(matrice_nMax,1)
        for j=1 : size(matrice_nMax,2)
            if matrice_nMax(i,j) > th then
                matrix_hysteresis(i,j) = 255;
            elseif matrice_nMax(i,j) > t1 then
                select mat_a_grad(i,j)
                case 0 then
                    if(get_pixel(matrice_nMax,i-1,j) > th & get_pixel(matrice_nMax,i+1,j) > th) then
                        matrix_hysteresis(i,j) = 255;
                    else
                        matrix_hysteresis(i,j) = 0;
                    end
                case 45 then
                    if(get_pixel(matrice_nMax,i-1,j-1) > th & get_pixel(matrice_nMax,i+1,j+1) > th) then
                        matrix_hysteresis(i,j) = 255;
                    else
                        matrix_hysteresis(i,j) = 0;
                    end
                case 90 then
                    if(get_pixel(matrice_nMax,i,j-1) > th & get_pixel(matrice_nMax,i,j+1) > th) then
                        matrix_hysteresis(i,j) = 255;
                    else
                        matrix_hysteresis(i,j) = 0;
                    end
                case 135 then
                    if(get_pixel(matrice_nMax,i+1,j-1) > th & get_pixel(matrice_nMax,i-1,j+1) > th) then
                        matrix_hysteresis(i,j) = 255;
                    else
                        matrix_hysteresis(i,j) = 0;
                    end
                end
            end
        end
    end
endfunction


//load image and stock it into a matrix
function matrix_image=chargerImage(path,isRGB)
    if isRGB == 0 then
        matrix_image=double(imread(path));
    else
        matrix_image=double(rgb2gray(imread(path)));
    end
endfunction

//Show image
function afficherImage(matrix_image)
    imshow(uint8(matrix_image));
endfunction

//Save image
function image = ecrireImage(matrix_image,nomFichier)
    image=imwrite(matrix_image,nomFichier);
endfunction


//cannyFilter()
