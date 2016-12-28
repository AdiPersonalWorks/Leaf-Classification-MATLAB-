function varargout = LeafImageRecognition(varargin)
% LEAFIMAGERECOGNITION M-file for LeafImageRecognition.fig
%      LEAFIMAGERECOGNITION, by itself, creates a new LEAFIMAGERECOGNITION or raises the existing
%      singleton*.
%
%      H = LEAFIMAGERECOGNITION returns the handle to a new LEAFIMAGERECOGNITION or the handle to
%      the existing singleton*.
%
%      LEAFIMAGERECOGNITION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LEAFIMAGERECOGNITION.M with the given input arguments.
%
%      LEAFIMAGERECOGNITION('Property','Value',...) creates a new LEAFIMAGERECOGNITION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LeafImageRecognition_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LeafImageRecognition_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LeafImageRecognition

% Last Modified by GUIDE v2.5 14-Mar-2015 22:25:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @LeafImageRecognition_OpeningFcn, ...
    'gui_OutputFcn',  @LeafImageRecognition_OutputFcn, ...
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


% --- Executes just before LeafImageRecognition is made visible.
function LeafImageRecognition_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LeafImageRecognition (see VARARGIN)

% Choose default command line output for LeafImageRecognition
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LeafImageRecognition wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LeafImageRecognition_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in BrowseTestImg.
function BrowseTestImg_Callback(hObject, eventdata, handles)
% hObject    handle to BrowseTestImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Used to browse and select the required image
cla(handles.RecogImage);
[Sel_Img,SelImage_Path] = uigetfile({'*.jpg;*.png;*.bmp'},pwd,'Pick the test image file');
SelImage_Path = [SelImage_Path Sel_Img];

if Sel_Img == 0
    return;
end

ImagetobeRecog = imread(SelImage_Path);

axes(handles.RecogImage);
imshow(ImagetobeRecog), title('Image for Recognition');

handles.ImagetobeRecog = ImagetobeRecog;

guidata(hObject,handles);

% --- Executes on button press in startiden.
function startiden_Callback(hObject, eventdata, handles)
% hObject    handle to startiden (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% PCA recognition starts here.
clc;
warning off;
try
    TestImg = handles.ImageAfterNoiseRemoval;
catch
    msgbox('Pre-processing steps not complete');
    return;
end
[delta_min,idx,Imagepath] = PCALeafImages(TestImg);

axes(handles.MatchedImage);
title_msg = ['Closest Image Matched(Delta Value:' num2str(delta_min) ')'];
imshow(Imagepath{idx}), title(title_msg);

[x,y] = strtok(Imagepath{idx},'/');
[Req_Species,y] = strtok(y,'/');
[~,AllSpecies_Names] = xlsread('Species_Scientific_List.xls','Sheet1');

[r,c] = find(strcmp(AllSpecies_Names,Req_Species)==1);

Req_Scientific_Name = AllSpecies_Names{r,2};
set(handles.text2,'String',Req_Scientific_Name);
set(handles.text2,'Visible','on');



% --- Executes on button press in rgb2grayconv.
function rgb2grayconv_Callback(hObject, eventdata, handles)
% hObject    handle to rgb2grayconv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This portion converts the image to grayscale for further processing.
warning off;
try
    ImagetobeConvertedtoGrey = handles.ImagetobeRecog;
catch
    msgbox('No Image selected');
    return;
end

if isgray(ImagetobeConvertedtoGrey)
    axes(handles.GreyImg);
    imshow(Grey_Image), title('Converted Gray Image');
    handles.Grey_Image = ImagetobeConvertedtoGrey;
else
    Grey_Image = rgb2gray(ImagetobeConvertedtoGrey);
    axes(handles.GreyImg);
    imshow(Grey_Image), title('Converted Gray Image');
    handles.Grey_Image = Grey_Image;
end

guidata(hObject,handles);

% --- Executes on button press in noiserem.
function noiserem_Callback(hObject, eventdata, handles)
% hObject    handle to noiserem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This portion is used to remove noise if any from the image
try
    ImageforNoiseRemoval = handles.Grey_Image;
catch
    msgbox('No Image selected');
    return;
end

[cleanimg] = NoiseRemoval(ImageforNoiseRemoval);

axes(handles.NoiseRemImg);
imshow(cleanimg), title('Image After Noise Removal');

handles.ImageAfterNoiseRemoval = cleanimg;
guidata(hObject,handles);

msgbox('Run the feature extraction before the recognition for more accuracy');

% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.RecogImage);
title('');
axes(handles.GreyImg);
title('');
axes(handles.NoiseRemImg);
title('');
axes(handles.MatchedImage);
title('');

cla(handles.RecogImage);
cla(handles.GreyImg);
cla(handles.NoiseRemImg);
cla(handles.MatchedImage);

set(handles.text2,'String','');
set(handles.text2,'Visible','off');


% --- Executes on button press in adpnoiserem.
function adpnoiserem_Callback(hObject, eventdata, handles)
% hObject    handle to adpnoiserem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    ImageforNoiseRemoval = handles.Grey_Image;
catch
    msgbox('No Image selected');
    return;
end

[cleanimg] = adpmedian(ImageforNoiseRemoval,3);

axes(handles.NoiseRemImg);
imshow(cleanimg), title('Image After Noise Removal');

handles.ImageAfterNoiseRemoval = cleanimg;
guidata(hObject,handles);

msgbox('Run the feature extraction before the recognition for more accuracy');


% --- Executes on button press in fetext.
function fetext_Callback(hObject, eventdata, handles)
% hObject    handle to fetext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Area, Perimeter, Contrast, Energy, Homogeneity] = Canny_Area_Perimeter(handles.ImageAfterNoiseRemoval);
message = sprintf('Area and Perimeter Calculated.!\nThe area is = %10.2f\nThe perimeter is = %10.2f\nPlease close the message box and the figures',Area, Perimeter);
msgbox(message);

% Storing the area and the perimeter
handles.Area = Area;
handles.Perimeter = Perimeter;
handles.Contrast = Contrast;
handles.Energy = Energy;
handles.Homogeneity = Homogeneity;
guidata(hObject,handles);

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
meanGL = Mean_GrayLvlHistogram(handles.ImageAfterNoiseRemoval);

%Storing the mean grey level
handles.MeanGreyLevel = meanGL;
guidata(hObject,handles);


% --- Executes on button press in featrecog.
function featrecog_Callback(hObject, eventdata, handles)
% hObject    handle to featrecog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    load FeaturesExtracted.mat % Loading the extracted database features
    
    % Parameters recalled.
    Area = handles.Area;
    Perimeter = handles.Perimeter;
    meanGL = handles.MeanGreyLevel;
    Contrast = handles.Contrast;
    Energy = handles.Energy;
    Homogenity = handles.Homogeneity;
    
    feat_sz = size(feature_ext);
    
    for ii = 1:length(feature_ext)
        % Diff b/w test and database
        area_tmp = abs(feature_ext{ii,2} - Area);
        per_tmp = abs(feature_ext{ii,3} - Perimeter);
        con_tmp = abs(feature_ext{ii,4} - Contrast);
        ener_tmp = abs(feature_ext{ii,5} - Energy);
        hom_tmp = abs(feature_ext{ii,6} - Homogenity);
        gl_tmp = abs(feature_ext{ii,7} - meanGL);
        
        %Storing required values in a new variable
        allfeatavg{ii,1} = feature_ext{ii,1};
        allfeatavg{ii,2} = (area_tmp+per_tmp+con_tmp+ener_tmp+hom_tmp+gl_tmp)/6;
    end
    
    % Sorting to get the matches in ascending order
    allfeatavg = sortrows(allfeatavg,2);
    
    % Plotting the three closest matches
    figure('name','Top Matches');
    title('THE TOP 3 MATCHES ARE:')
    
    subplot(3,1,1);
    [Req_Scientific_Name] = speciesname(allfeatavg{1,1});
    imshow(imread(allfeatavg{1,1})); title(['Match 1 : Species = ' Req_Scientific_Name]);
    
    subplot(3,1,2);
    [Req_Scientific_Name] = speciesname(allfeatavg{2,1});
    imshow(imread(allfeatavg{2,1})); title(['Match 2 : Species = ' Req_Scientific_Name]);
    
    subplot(3,1,3);
    [Req_Scientific_Name] = speciesname(allfeatavg{3,1});
    imshow(imread(allfeatavg{3,1})); title(['Match 3 : Species = ' Req_Scientific_Name]);
    
catch err
    msgbox('Features not extracted for Database. Please do so first before using this recognition method');
end

function [Req_Scientific_Name] = speciesname(Imagepath)
% Function to extract the scientific names from the excel sheet.
[x,y] = strtok(Imagepath,'/');
[Req_Species,y] = strtok(y,'/');
[~,AllSpecies_Names] = xlsread('Species_Scientific_List.xls','Sheet1');

[r,c] = find(strcmp(AllSpecies_Names,Req_Species)==1);

Req_Scientific_Name = AllSpecies_Names{r,2};
