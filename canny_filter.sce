// chargerImage('/home/zank/Documents/grayflower.png');
//
//            BEFORE LAUNCH            
//
// troisxtrois=zeros(3,3);
// maskx=zeros(1,3);
// masky =zeros(3,1);

function start()
    chargerImage('/home/zank/Documents/grayflower.png',0);
    disp('masquage vertical')
    masquage(matrixImage,masky);
    disp('masquage horizontal')
    masquage(matrixImage,maskx);
    disp('masquage')
    masquage(matrixImage,troisxtrois);
endfunction

function matrixImage=chargerImage(path,isRGB)
    if isRGB == 0 then
        matrixImage=double(imread(path));
    else
        matrixImage=double(rgb2gray(imread(path)));
    end
endfunction

function afficherImage(matrixImage)
    imshow(uint8(matrixImage));
endfunction

function image = ecrireImage(matrixImage,nomFichier)
    image=imwrite(matrixImage,nomFichier);
endfunction

//mask
function masquage(matrixImage,mask)
   
    matrixImage = ones(10,10);
    
    //size matrixImg
    size_m = size(matrixImage)
    
    //mid size
    size_mask = size(mask)
    mid_size_mask_x=ceil(size_mask(1,1)/2);
    mid_size_mask_y=ceil(size_mask(1,2)/2);
    disp(mid_size_mask_x);
    disp(mid_size_mask_x);
    
    //image extension
    //issue when mid_size_mask = 1
    if mid_size_mask_x = 1 then
        x=0
    else 
        x = mid_size_mask_x
    end
    if mid_size_mask_y=1 then
        y=0
    else 
        y = mid_size_mask_y
    end
    matrix_image_bigger = zeros(size_m(1,1)+x,size_m(1,2)+y)
    size_mb = size(matrix_image_bigger)
    disp(size(matrixImage))
    disp(size(matrix_image_bigger))
    
    //image placement
    x= mid_size_mask_x:size_mb(1,1)-(mid_size_mask_x-1);
    y= mid_size_mask_y:size_mb(1,2)-(mid_size_mask_y-1);
    disp(x)
    disp(y)
    matrix_image_bigger(x,y)=matrixImage;
    disp(matrix_image_bigger)
    
    // not usefull right now
    if isequal(size_mask(1,1),size_mask(1,2))  then
//        disp('filtre AxA');
    elseif size_mask(1,1) < size_mask(1,2)
//        disp('mask horizontale');
    elseif size_mask(1,1) > size_mask(1,2)
//        disp('mask verticale');
    end
endfunction
