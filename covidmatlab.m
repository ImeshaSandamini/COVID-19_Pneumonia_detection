function varargout = covidmatlab(varargin)
% COVIDMATLAB MATLAB code for covidmatlab.fig
%      COVIDMATLAB, by itself, creates a new COVIDMATLAB or raises the existing
%      singleton*.
%
%      H = COVIDMATLAB returns the handle to a new COVIDMATLAB or the handle to
%      the existing singleton*.
%
%      COVIDMATLAB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COVIDMATLAB.M with the given input arguments.
%
%      COVIDMATLAB('Property','Value',...) creates a new COVIDMATLAB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before covidmatlab_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to covidmatlab_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help covidmatlab

% Last Modified by GUIDE v2.5 12-Aug-2021 23:18:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @covidmatlab_OpeningFcn, ...
                   'gui_OutputFcn',  @covidmatlab_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before covidmatlab is made visible.
function covidmatlab_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to covidmatlab (see VARARGIN)

% Choose default command line output for covidmatlab
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes covidmatlab wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = covidmatlab_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Browse_image.
function Browse_image_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile('*.*','Pick a MATLAB code file');
filename=strcat(pathname,filename);
Selected_Image = imread(filename); %read picture 
axes(handles.axes1);
imshow(Selected_Image);
handles.Selected_Image = Selected_Image;
guidata(hObject, handles);

% --- Executes on button press in Remove_Noice.
function Remove_Noice_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_Noice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Selected_Image2=handles.Selected_Image;
greyscale_Method = rgb2gray(Selected_Image2); %convert into grayscale
median_filtering_Image = customfilter(greyscale_Method); %Uses Noise Removal
axes(handles.axes2);
imshow(median_filtering_Image); %show image
handles.median_filtering_Image = median_filtering_Image;
guidata(hObject, handles);

% --- Executes on button press in Binary_Image.
function Binary_Image_Callback(hObject, eventdata, handles)
% hObject    handle to Binary_Image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Selected_Image3=handles.median_filtering_Image;
binary_picture = imbinarize(Selected_Image3, 0.5); %Convert into Black and White
axes(handles.axes3);
imshow(binary_picture); %show image 
handles.binary_picture = binary_picture;
guidata(hObject, handles);


% --- Executes on button press in Opening_Image.
function Opening_Image_Callback(hObject, eventdata, handles)
% hObject    handle to Opening_Image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Selected_Image4=handles.binary_picture;
se1 = strel('disk', 2); %creates a flat, disk-shaped structure,
postOpenImage_1 = imopen(Selected_Image4, se1);
axes(handles.axes4);
imshow(postOpenImage_1); %show image
handles.postOpenImage_1 = postOpenImage_1;
guidata(hObject, handles);

% --- Executes on button press in Inverted_Image.
function Inverted_Image_Callback(hObject, eventdata, handles)
% hObject    handle to Inverted_Image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Selected_Image5=handles.binary_picture;
Selected_Image6=handles.postOpenImage_1;

inverted = ones(size(Selected_Image5));

%Creates Inverted Picture
invertedImage_1 = inverted - Selected_Image6;

axes(handles.axes5);
imshow(invertedImage_1); %show image
handles.invertedImage_1 = invertedImage_1;
handles.inverted = inverted;
guidata(hObject, handles);




% --- Executes on button press in Segmentation.
function Segmentation_Callback(hObject, eventdata, handles)
% hObject    handle to Segmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Specify initial contourSelected_Image6=handles.postOpenImage_1;
Selected_Image7=handles.invertedImage_1;

mask = zeros(size(Selected_Image7)); 
mask(50:end-50,50:end-50) = 1;

%Segments image into foreground and background
bw_1 = activecontour(Selected_Image7, mask, 800); %800 iterations 


%Create Combination Pictures with Inverted image and Contour
mix_Image_1 = Selected_Image7 + bw_1;
filter_mix_Image_1 = medfilt2(mat2gray(mix_Image_1),[5 5]); %Filtering

%Black White Combination to Create Final Images

final_1 = imbinarize(filter_mix_Image_1, 0.5);
pre_final = final_1; %transfer
BW5 = imfill(pre_final,'holes');
axes(handles.axes6);
imshow(BW5); %show image
handles.BW5 = BW5;
handles.final_1 = final_1;
guidata(hObject, handles);

% --- Executes on button press in Final_Image.
function Final_Image_Callback(hObject, eventdata, handles)
% hObject    handle to Final_Image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Dispaly Final Image
final_1=handles.final_1;
axes(handles.axes7);
imshow(final_1); %show image

warning('off', 'all')
circle_image = final_1;
[centers,radii] = imfindcircles(circle_image,[1 9],'ObjectPolarity','dark','Sensitivity',0.75);
viscircles(centers,radii,'EdgeColor','g'); % Circles Display Green
result1='Positive';
result2='Negative';
if(centers>=1)
    set(handles.Result,'string',result1);
else
    set(handles.Result,'string',result2);
end





function Result_Callback(hObject, eventdata, handles)
% hObject    handle to Result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Result as text
%        str2double(get(hObject,'String')) returns contents of Result as a double
%Find Circles within Image using Polarity and Sensitivity


% --- Executes during object creation, after setting all properties.
function Result_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Clear_All.
function Clear_All_Callback(hObject, eventdata, handles)
% hObject    handle to Clear_All (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Result,'string','');
cla(handles.axes1,'reset');
cla(handles.axes2,'reset');
cla(handles.axes3,'reset');
cla(handles.axes4,'reset');
cla(handles.axes5,'reset');
cla(handles.axes6,'reset');
cla(handles.axes7,'reset');