function varargout = untitled(varargin)
% UNTITLED MATLAB code for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled

% Last Modified by GUIDE v2.5 10-Apr-2017 23:19:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
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


function setGlobalx(val)
global x
x = val;

function r = getGlobalx
global x
r = x;

function setGlobaly(val)
global y
y = val;

function r = getGlobaly
global y
r = y;

% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled (see VARARGIN)

% Choose default command line output for untitled
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





% --- Executes on button press in loadbutton.
function loadbutton_Callback(hObject, eventdata, handles)
% hObject    handle to loadbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = uigetdir;
if isequal(folder, 0); return; end
setGlobalx(folder);
files=dir(sprintf('%s/*.png',folder));
tmp=dir(sprintf('%s/*.png',folder));
files(length(files)+1:length(files)+length(tmp))=tmp;
handles.images=[];
h=waitbar(0,'Loading images...');
for id=1:length(files)
    handles.images{id}=double(imread(sprintf('%s/%s',folder,files(id).name)))/255;
    if length(size(handles.images{id}))==2 % expand grey scale image to color image format
        t=handles.images{id};
        t=zeros([size(handles.images{id}) 3]);
        t(:,:,1)=handles.images{id};
        t(:,:,2)=handles.images{id};
        t(:,:,3)=handles.images{id};
        handles.images{id}=t;
    end
    waitbar(id/length(files),h);
end
delete(h);
 
axes(handles.axes1);
hold off;
imshow(handles.images{1});
hold on;
set(handles.slider,'min',1);

set(handles.slider,'max',length(handles.images));
set(handles.slider,'value',1);
guidata(hObject,handles);



% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Figure out which image to show
axes(handles.axes1);
hold off;
imshow(handles.images{round(get(hObject,'value'))});
hold on;
%set(handles.frame_title,'string',sprintf('Frame %d',round(get(hObject,'value'))));
title(sprintf('Image %d',round(get(hObject,'value'))));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% executes on pressing register images

% --- Executes on button press in register.
function register_Callback(hObject, eventdata, handles)
% hObject    handle to register (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sampleFiles = getGlobalx;
h=waitbar(0,'Registering images...');
ss='/';
sampleFiles=strcat(sampleFiles,ss);
files = dir([sampleFiles '*.png']);
%disp(length(handles.images));
imageFilenames = {files(1:length(handles.images)/2).name};
imageFilenames = cellfun(@(x) [sampleFiles x], imageFilenames, 'UniformOutput', false);
% super resolution process begins 
%disp(handles.current_data);
do(imageFilenames);
[a,inp]=startSR(imageFilenames, handles);
waitbar(1,h);
delete(h);
setGlobaly(inp);
%handles.asdf=1;
setGlobalx(a);


% executes code for performing reconstruction
% --- Executes on button press in reconstruct.
function reconstruct_Callback(hObject, eventdata, handles)
% hObject    handle to reconstruct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rec=getGlobalx;
%disp(handles.asdf);
inp=getGlobaly;

figure;
subplot(1,2,1);
imshow(rec);
title('output image');
subplot(1,2,2);
b = imsharpen(rec);
imshow(b)
title('Sharpened Image');


figure;
subplot(1,2,1);
imshow(inp);
title('Input image');
subplot(1,2,2);
imshow(rec);
title('Output image ');

%disp(size(inp));
%disp(size(rec));
% verification by blurness of input and output 

% menu for choosing scaling value
% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
% Determine the selected data set.
str = get(hObject, 'String');
val = get(hObject,'Value');
% Set current data to the selected data set.

switch val
case 1 
   handles.current_data = 1;
case 2
   handles.current_data = 2;
case 3 
   handles.current_data = 3;
case 4 
   handles.current_data = 4;
case 6 
   handles.current_data = 6;
case 8 
   handles.current_data = 8;
case 12 
   handles.current_data = 12;
end
% Save the handles structure.
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
