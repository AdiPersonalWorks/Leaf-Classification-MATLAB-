function varargout = ExtractFeatforDatabse(varargin)
% EXTRACTFEATFORDATABSE M-file for ExtractFeatforDatabse.fig
%      EXTRACTFEATFORDATABSE, by itself, creates a new EXTRACTFEATFORDATABSE or raises the existing
%      singleton*.
%
%      H = EXTRACTFEATFORDATABSE returns the handle to a new EXTRACTFEATFORDATABSE or the handle to
%      the existing singleton*.
%
%      EXTRACTFEATFORDATABSE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXTRACTFEATFORDATABSE.M with the given input arguments.
%
%      EXTRACTFEATFORDATABSE('Property','Value',...) creates a new EXTRACTFEATFORDATABSE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ExtractFeatforDatabse_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ExtractFeatforDatabse_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ExtractFeatforDatabse

% Last Modified by GUIDE v2.5 14-Mar-2015 22:17:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ExtractFeatforDatabse_OpeningFcn, ...
    'gui_OutputFcn',  @ExtractFeatforDatabse_OutputFcn, ...
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


% --- Executes just before ExtractFeatforDatabse is made visible.
function ExtractFeatforDatabse_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ExtractFeatforDatabse (see VARARGIN)

% Choose default command line output for ExtractFeatforDatabse
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ExtractFeatforDatabse wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ExtractFeatforDatabse_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in exfeat.
function exfeat_Callback(hObject, eventdata, handles)
% hObject    handle to exfeat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FeatureExtractDatabase();
msgbox('Process Complete','Feature Extraction for Database');