////////////////////////////////////////////////////////////////////////////////
//Alexis Zankowitch...........................................................//
//............................................................................//
// ..........................FILTRE DE CANNY..................................//
//............................................................................//
//............................................................................//
////////////////////////////////////////////////////////////////////////////////


//Start
function cannyFilter()
    matrixImage = chargerImage('/home/zank/git/filtre_canny/grayflower.png',0);
    mask=[1,2,1;2,4,2;1,2,1];
    maskx=[1,2,1];
    masky=[1,2,1]';
    disp('MASK Y =')
    masquage(matrixImage,masky);
    disp('MASK X =')
    masquage(matrixImage,maskx);
    disp('MASK =')
    masquage(matrixImage,mask);
endfunction

//load image and stock it into a matrix
function matrixImage=chargerImage(path,isRGB)
    if isRGB == 0 then
        matrixImage=double(imread(path));
    else
        matrixImage=double(rgb2gray(imread(path)));
    end
endfunction

//Show image
function afficherImage(matrixImage)
    imshow(uint8(matrixImage));
endfunction

//Save image
function image = ecrireImage(matrixImage,nomFichier)
    image=imwrite(matrixImage,nomFichier);
endfunction

//Extend image
function masquage(matrixImage,mask)
   
//    JUST FOR TEST
    matrixImage = ones(10,10);
    
//    mid size
    size_mask = size(mask)
    mid_size_mask_x=ceil(size_mask(1,1)/2);
    mid_size_mask_y=ceil(size_mask(1,2)/2);
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
    matrix_image_bigger = zeros(size(matrixImage,1)+x,size(matrixImage,2)+y)
    
    disp('size matrixIm')
    disp(size(matrixImage))
    disp('size mBig')
    disp(size(matrix_image_bigger))
    
//    image placement
    x= mid_size_mask_x:size(matrix_image_bigger,1)-(mid_size_mask_x-1);
    y= mid_size_mask_y:size(matrix_image_bigger,2)-(mid_size_mask_y-1);
    disp('inner matrix line')
    disp(x),    disp(y)
    matrix_image_bigger(x,y)=matrixImage;
    disp('Big matrix')
    disp(matrix_image_bigger)
    
//    not usefull right now
    if isequal(size_mask(1,1),size_mask(1,2))  then
//        disp('filtre AxA');
    elseif size_mask(1,1) < size_mask(1,2)
//        disp('mask horizontale');
    elseif size_mask(1,1) > size_mask(1,2)
//        disp('mask verticale');
    end
endfunction

function filter(matrixImage,mask)
//    2 boucles pour la matric 2 boucle pour le masque faire la somme des produits des case de meme indice et les stocker dans la case
endfunction
