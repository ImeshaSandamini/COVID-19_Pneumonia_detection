function lungAnalysis(filename)

Directory = 'E:\Matlab\_Getintopc.com_MathWorks_MATLAB_R2021a_v9.10.0.1602886\covid detection\Images\trainDataSet\Positive'; 
% Read images from Images folder
Imgs = dir(Directory);
for j=1:length(Imgs)
    thisname = Imgs(j).name;
    thisfile = fullfile(Directory, thisname);
    display(thisname);
    try

Selected_Image = imread(thisfile); %read picture 
subplot(3,3,1); %divides figure into rectangular panes 
imshow(Selected_Image); %show image
title('Selected Image'); %image name

%Noise Removal Section
greyscale_Method = rgb2gray(Selected_Image); %convert into grayscale
median_filtering_Image = customfilter(greyscale_Method); %Uses Noise Removal
subplot(3,3,2); %divides figure into rectangular panes
imshow(median_filtering_Image); %show image 
title('Noise Removed'); %image name

%Binary Image Conversion
binary_picture = imbinarize(median_filtering_Image, 0.5); %Convert into Black and White
subplot(3,3,3); %divides figure into rectangular panes
imshow(binary_picture); %show image 
title('Binary Image'); %image name

%Create morphological structuring element
se1 = strel('disk', 2); %creates a flat, disk-shaped structure,
postOpenImage_1 = imopen(binary_picture, se1);
subplot(3, 3, 4); %divides figure into rectangular panes
imshow(postOpenImage_1); %show image
title('Opening Image'); %image name

inverted = ones(size(binary_picture));

%Creates Inverted Picture
invertedImage_1 = inverted - postOpenImage_1;
subplot(3,3,5); %divides figure into rectangular panes
imshow(invertedImage_1); %show image
title('Inverted Picture'); %image name

%Specify initial contour
mask = zeros(size(invertedImage_1)); 
mask(50:end-50,50:end-50) = 1;

%Segments image into foreground and background
bw_1 = activecontour(invertedImage_1, mask, 800); %800 iterations 

%Create Combination Pictures with Inverted image and Contour
mix_Image_1 = invertedImage_1 + bw_1;
filter_mix_Image_1 = medfilt2(mat2gray(mix_Image_1),[5 5]); %Filtering

%Black White Combination to Create Final Images
final_1 = imbinarize(filter_mix_Image_1, 0.5);
pre_final = final_1; %transfer
subplot(3,3,6); %divides figure into rectangular panes
BW5 = imfill(pre_final,'holes');
imshow(BW5); %show image
title('Segmented'); %image name

%Dispaly Final Image
subplot(3,3,7); %divides figure into rectangular panes
imshow(final_1); %show image
title('Final Picture'); %image name

%Find Circles within Image using Polarity and Sensitivity
warning('off', 'all')
circle_image = final_1;
[centers,radii] = imfindcircles(circle_image,[1 9],'ObjectPolarity','dark','Sensitivity',0.75);
viscircles(centers,radii,'EdgeColor','g'); % Circles Display Green
%display(size(centers, 1), ' Numbers of Circles');
subplot(3,3,8); %divides figure into rectangular panes
imshow(circle_image); %show image
title('Circle Found Picture'); %image name
if(centers>=1)
    disp('Positive');
else
    disp('Negative');
end


catch
   end
end