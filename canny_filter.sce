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
//    mask_application(matrix_image,masky);
    
//    disp('MASK X =')
//    mask_application(matrix_image,maskx);
    
//    disp('MASK 3 =')
    matrix_image = mask_application(matrix_image,mask3);
    disp(matrix_image);
    //    gradient
    [mat_n_grad,mat_a_grad] = gradient(matrix_image);
    disp(mat_n_grad)
    disp(mat_a_grad)
    
    
//    disp('MASK 5 =')
//    mask_application(matrix_image,mask5);
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

//Extend image
function matrix_new = mask_application(matrix_image,mask)
   
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
    
//    mask application
    matrix_new = masking(matrix_image_bigger,mask)
//    matrix_image = matrix_new(x,y);
endfunction

//    2 boucles pour la matric 2 boucle pour le masque faire la somme des produits des case de meme indice et les stocker dans la case
function matrix_new = masking(matrix_image,mask_f)
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
    matrix_new = matrix_image;
    for x = start_x:max_x
        for y = start_y:max_y
            acc_mask = 0;
            for i = 1:size(mask_f,1)
                for j = 1:size(mask_f,2)
                    mult = mask_f(i,j) * matrix_image(xx+i,yy+j);
                    acc_mask = (acc_mask + mult)
                end
            end
            matrix_new(x,y)=acc_mask/sum_mask;
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
            mat_a_grad(i,j) = 180 * mat_a_grad(i,j) / %pi
        end
    end
//    display
//    disp(mat_n_grad)
//    disp(mat_a_grad)

//    appeler normalisation recursivement
endfunction

function mat_a_grad = normalisation()
    // 0 : -22,5 && 22,5
    if mat_a_grad(i,j) < 0 then
        mat_a_grad(i,j) = mat_a_grad(i,j) + 180;
    elseif mat_a_grad(i,j) < 45 then
        mat_a_grad(i,j) = 0;
    elseif mat_a_grad(i,j) < 90 then
        mat_a_grad(i,j) = 45;
    elseif mat_a_grad(i,j) < 135 then
        mat_a_grad(i,j) = 90;
    else
        mat_a_grad(i,j) = mat_a_grad(i,j) - 180;
    end
endfunction
