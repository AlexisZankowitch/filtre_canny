////////////////////////////////////////////////////////////////////////////////
//Alexis Zankowitch...........................................................//
//............................................................................//
// ..........................FILTRE DE CANNY..................................//
//............................................................................//
//............................................................................//
////////////////////////////////////////////////////////////////////////////////

//Start
function cannyFilter()
    matrix_image = chargerImage('/home/zank/git/filtre_canny/grayflower.png',0);
    maskx=[1,2,1];
    masky=[1,2,1]';
    mask3=[1,2,1;2,4,2;1,2,1];
    mask5=[1,2,4,2,1;2,4,8,4,2;4,8,16,8,4;2,4,8,4,2;1,2,4,2,1]
//    disp('MASK Y =')
//    algorithm(matrix_image,masky);
    
//    disp('MASK X =')
//    algorithm(matrix_image,maskx);
    
//    disp('MASK 3 =')
    algorithm(matrix_image,mask3);
    
//    disp('MASK 5 =')
//    algorithm(matrix_image,mask5);
endfunction

function algorithm(matrix_image,mask)
    
    //    JUST FOR TEST
//    matrix_image = ones(10,10);
//    disp(matrix_image);
    
    disp('MASK APPLICATION');
    [matrix_imageB,x,y] = mask_application(matrix_image,mask);
    disp('MASKING');
    matrix_masked = masking(matrix_imageB, mask);
    disp('GRADIENT');
    [mat_n_grad,mat_a_grad] = gradient(matrix_masked);
//    mat_n_grad(3,3)=10;
//    disp(mat_n_grad)
//    disp(mat_a_grad)
    disp('MAXIMUM SUPPRESSION');
    matrice_nMax = deleteNMax(mat_n_grad,mat_a_grad);
    
    disp('HISTERESIS');
    mat_hist = hysteresis(mat_n_grad,10);
//    disp(matrice_nMax)

    //resize matrix 
    mat_img_croped = matrice_nMax(x,y);
    matrix_images = [matrix_image mat_img_croped]
//    afficherImage(matrix_images); //EROR INCONSISTENT COLUMN/ROW DIMENSION
    //    matrix_image = matrix_new(x,y);
endfunction

//Extend image
function [matrix_image_bigger,x,y] = mask_application(matrix_image,mask)
    
//    mid size
//    disp('mask')
//    disp(floor(size(mask,2)/2))
    mid_size_mask_x=floor(size(mask,1)/2);
    mid_size_mask_y=floor(size(mask,2)/2);
//    disp('mid size mask')
//    disp(mid_size_mask_x);
//    disp(mid_size_mask_y);
    
//    image extension
    matrix_image_bigger = zeros(size(matrix_image,1)+2*mid_size_mask_x,size(matrix_image,2)+2*mid_size_mask_y)
    
//    disp('size matrixIm')
//    disp(size(matrix_image))
//    disp('size mBig')
//    disp(size(matrix_image_bigger))
    
//    image placement
    x= mid_size_mask_x+1:size(matrix_image_bigger,1)-(mid_size_mask_x);
    y= mid_size_mask_y+1:size(matrix_image_bigger,2)-(mid_size_mask_y);
//    disp('inner matrix line')
//    disp(x),    disp(y)
    matrix_image_bigger(x,y)=matrix_image;
//    disp('Big matrix')
//    disp(matrix_image_bigger);
endfunction

//    2 boucles pour la matric 2 boucle pour le masque faire la somme des produits des case de meme indice et les stocker dans la case
function matrix_masked = masking(matrix_image,mask_f)
//    loop begins where the picture is
//    disp('Masking')
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
//    display
//    disp(mat_n_grad)
//    disp(mat_a_grad)

//    appeler normalisation recursivement
endfunction

function val = normalisation(val)
    val_check = [0,45,90,135];    
//    disp('--------------strat--------------')
//    disp(val)
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
//    disp('--------------calc--------------')
//    disp(val)
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


function pixel = get_pixel(mat, i, j)
    if(i >= 1 & j >=1 & i <= size(mat,1) & j <= size(mat,2))
        pixel = mat(i,j);
    else
        pixel = -1;
    end
endfunction

//Hysteresis
function matrix_hysteresis = hysteresis(matrix_n,hist_p)
//    sum of all pixel
    size_m = size(matrix_n,1)*size(matrix_n,2);
    x = 1;
//    normalisation
    for (i = 1 : size(matrix_n,1))
        for (j = 1 : size(matrix_n,2))
            matrix_norm(i,j) = floor(matrix_n(i,j));
        end
    end
    max_m = max(matrix_norm);
    min_m = min(matrix_norm);
    val_m = max_m-min_m;
    hist = zeros(1,hist_p);
    hist_x = hist;
    for (i=1 : size(hist_x,2))
        hist_x(1,i)=val_m * i / hist_p;
    end
    disp(hist);
    disp(hist_x);
    for (i = 1 : size(matrix_norm,1))
        for (j = 1 : size(matrix_norm,2))
            
        end
    end
//    disp(hist);
//    subplot(121);
//    plot2d(,hist);
//    
//    matrix_repar = cumsum(hist);
//    subplot(122);
//    plot2d(matrix_repar);
    
    matrix_hysteresis = matrix_norm;
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


cannyFilter()
