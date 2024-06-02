function varargout = live_gui(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @live_gui_OpeningFcn, ...
    'gui_OutputFcn',  @live_gui_OutputFcn, ...
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


% --- Executes just before live_gui is made visible.
function live_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to live_gui (see VARARGIN)

% Choose default command line output for live_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This creates the 'background' axes
ha = axes('units','normalized', ...
            'position',[0 0 1 1]);
% Move the background axes to the bottom
uistack(ha,'bottom');
% Load in a background image and display it using the correct colors
% The image used below, is in the Image Processing Toolbox.  If you do not have %access to this toolbox, you can use another image file instead.
I=imread('background.jpg');
hi = imagesc(I);
colormap gray
% Turn the handlevisibility off so that we don't inadvertently plot into the axes again
% Also, make the axes invisible
set(ha,'handlevisibility','off', ...
    'visible','off')


% UIWAIT makes live_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = live_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 %between 50 and 150;

% plot(sin(0:10))
Fs = 44100;
nBits = 16;
nChannels = 1;
recObj = audiorecorder(Fs, nBits, nChannels, 1);

filename = 'LiveAudio.wav';

set(handles.static1,'String','Start Speaking')
% pause(1);set(handles.static1,'String','3');
% pause(1);set(handles.static1,'String','2');
% pause(1);set(handles.static1,'String','1');
pause(1);set(handles.static1,'String','Now!!');

pause(1);set(handles.static1,'String','Keep Speaking');


recordblocking(recObj,7);
set(handles.static1,'String','Recording Ended')

myRecording = getaudiodata(recObj);
audiowrite(filename, myRecording, Fs);

load('Data');
% emotions = [string("Angry") string("Happy") string("Neutral") string("Sad")];

[speech, fs] = audioread(filename);
LiveFeatures = features(speech, fs);
predicted_label = KnnLive(1, TrainData, TrainClass, LiveFeatures);
%
if predicted_label==1
    set(handles.static1,'String','The algorithm thinks you are angry');
elseif predicted_label==2
    set(handles.static1,'String','According to the algorithm you seem to be happy');
elseif predicted_label==3
    set(handles.static1,'String','The algorithm thinks you are in a neutral state of mind');
elseif predicted_label==4
    set(handles.static1,'String','The algorithm thinks you are sad');
end
