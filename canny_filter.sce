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
    mask=[1,2,1;2,4,2;1,2,1];
    maskx=[1,2,1];
    masky=[1,2,1]';
    disp('MASK Y =')
    mask_application(matrix_image,masky);
    
    disp('MASK X =')
    mask_application(matrix_image,maskx);
    
//    disp('MASK =')
//    mask_application(matrix_image,mask);
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
function mask_application(matrix_image,mask)
   
//    JUST FOR TEST
    matrix_image = ones(10,10);
    
//    mid size
    mid_size_mask_x=ceil(size(mask,1)/2);
    mid_size_mask_y=ceil(size(mask,2)/2);
    disp('mid size mask')
    disp(mid_size_mask_x);
    disp(mid_size_mask_x);
    
//    image extension
//    issue when mid_size_mask = 1
    if mid_size_mask_x == 1 then
        x=0
    else 
        x = mid_size_mask_x
    end
    if mid_size_mask_y == 1 then
        y=0
    else 
        y = mid_size_mask_y
    end
    matrix_image_bigger = zeros(size(matrix_image,1)+x,size(matrix_image,2)+y)
    
    disp('size matrixIm')
    disp(size(matrix_image))
    disp('size mBig')
    disp(size(matrix_image_bigger))
    
//    image placement
    x= mid_size_mask_x:size(matrix_image_bigger,1)-(mid_size_mask_x-1);
    y= mid_size_mask_y:size(matrix_image_bigger,2)-(mid_size_mask_y-1);
    disp('inner matrix line')
    disp(x),    disp(y)
    matrix_image_bigger(x,y)=matrix_image;
    disp('Big matrix')
    disp(matrix_image_bigger);
    masking(matrix_image_bigger,mask)
endfunction

//    2 boucles pour la matric 2 boucle pour le masque faire la somme des produits des case de meme indice et les stocker dans la case
function masking(matrix_image,mask_f)
//    loop begins where the picture is
    disp('Masking')
    mid_size_mask_x=floor(size(mask_f,1)/2);
    mid_size_mask_y=floor(size(mask_f,2)/2);
    max_x = size(matrix_image,1)-mid_size_mask_x;
    max_y = size(matrix_image,2)-mid_size_mask_y;
    start_x = mid_size_mask_x +1;
    start_y = mid_size_mask_y +1;
    sum_mask = sum(mask);
    xx = 0;
    yy = 0;
    matrix_new = matrix_image;
    for x = start_x:max_x
        for y = start_y:max_y
            acc_mask = 0;
            for i = 1:size(mask,1)
                for j = 1:size(mask,2)
                    mult = mask(i,j) * matrix_image(xx+i,yy+j);
                    acc_mask = (acc_mask + mult)
                end
            end
            matrix_new(x,y)=acc_mask/sum_mask;
            yy=yy+1;
        end
        yy=0;
        xx=xx+1;
    end
    disp(matrix_new);
endfunction
