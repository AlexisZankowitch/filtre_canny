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
    matrix_imageB = mask_application(matrix_image,mask);
    matrix_masked = masking(matrix_imageB, mask);
    [mat_n_grad,mat_a_grad] = gradient(matrix_masked);
    disp(mat_n_grad)
    disp(mat_a_grad)
    //    matrix_image = matrix_new(x,y);
endfunction

//Extend image
function matrix_image_bigger = mask_application(matrix_image,mask)
   
//    JUST FOR TEST
    matrix_image = ones(10,10);
    
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
