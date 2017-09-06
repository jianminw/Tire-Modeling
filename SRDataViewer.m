function varargout = SRDataViewer(varargin)
% SRDATAVIEWER MATLAB code for SRDataViewer.fig
%      SRDATAVIEWER, by itself, creates a new SRDATAVIEWER or raises the existing
%      singleton*.
%
%      H = SRDATAVIEWER returns the handle to a new SRDATAVIEWER or the handle to
%      the existing singleton*.
%
%      SRDATAVIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SRDATAVIEWER.M with the given input arguments.
%
%      SRDATAVIEWER('Property','Value',...) creates a new SRDATAVIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SRDataViewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SRDataViewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SRDataViewer

% Last Modified by GUIDE v2.5 06-Aug-2017 23:12:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SRDataViewer_OpeningFcn, ...
                   'gui_OutputFcn',  @SRDataViewer_OutputFcn, ...
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


% --- Executes just before SRDataViewer is made visible.
function SRDataViewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SRDataViewer (see VARARGIN)

% load data
r39 = load('Round-5-SI/B1464run39.mat'); % loading round 39 data
r40 = load('Round-5-SI/B1464run40.mat'); % loading round 40 data

DR25 = combine(r39, r40);
DR25 = timeSplice(DR25, r39, r40);
DR25.pos = segment(DR25.IA, -1, length(DR25.P)+1, 1);
handles.DR25 = DR25;

% default values
handles.pressure = -1;
handles.camber = -1;
handles.normalForce = -1;
handles.slipAngle = -1;
handles.dataX = handles.DR25.SL;
handles.dataY = handles.DR25.FX;

% Choose default command line output for SRDataViewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SRDataViewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SRDataViewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

str = get(hObject, 'String');
val = get(hObject, 'Value');
switch str{val}
    case 'All'
        handles.pressure = -1;
    case '8'
        handles.pressure = 0;
    case '10'
        handles.pressure = 1;
    case '12'
        handles.pressure = 2;
    case '14'
        handles.pressure = 3;
end

% Update handles structure
guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

str = get(hObject, 'String');
val = get(hObject, 'Value');
switch str{val}
    case 'All'
        handles.camber = -1;
    case '0'
        handles.camber = 0;
    case '2'
        handles.camber = 2;
    case '4'
        handles.camber = 4;
end

% Update handles structure
guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


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


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

str = get(hObject, 'String');
val = get(hObject, 'Value');
switch str{val}
    case 'All'
        handles.normalForce = -1;
    case '50'
        handles.normalForce = 0;
    case '150'
        handles.normalForce = 2;
    case '200'
        handles.normalForce = 3;
    case '250'
        handles.normalForce = 4;
end

% Update handles structure
guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

str = get(hObject, 'String');
val = get(hObject, 'Value');
switch str{val}
    case 'All'
        handles.slipAngle = -1;
    case '0'
        handles.slipAngle = 0;
    case '3'
        handles.slipAngle = 1;
    case '6'
        handles.slipAngle = 2;
end

% Update handles structure
guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

str = get(hObject, 'String');
val = get(hObject, 'Value');
switch str{val}
    case 'SR'
        handles.dataX = handles.DR25.SL;
    case 'FY'
        handles.dataX = -handles.DR25.FY;
    case 'FX'
        handles.dataX = handles.DR25.FX;
    case 'FZ'
        handles.dataX = -handles.DR25.FZ;
    case 'FY / FZ'
        handles.dataX = handles.DR25.FY ./ handles.DR25.FZ;
    case 'FX / FZ'
        handles.dataX = -handles.DR25.FX ./ handles.DR25.FZ;
    case 'Overturning Moment'
        handles.dataX = handles.DR25.MX;
    case 'Aligning Torque'
        handles.dataX = handles.DR25.MZ;
    case 'Loaded Radius'
        handles.dataX = handles.DR25.RL;
end

% Update handles structure
guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

str = get(hObject, 'String');
val = get(hObject, 'Value');
switch str{val}
    case 'SR'
        handles.dataY = handles.DR25.SL;
    case 'FY'
        handles.dataY = -handles.DR25.FY;
    case 'FX'
        handles.dataY = handles.DR25.FX;
    case 'FZ'
        handles.dataY = -handles.DR25.FZ;
    case 'FY / FZ'
        handles.dataY = handles.DR25.FY ./ handles.DR25.FZ;
    case 'FX / FZ'
        handles.dataY = -handles.DR25.FX ./ handles.DR25.FZ;
    case 'Overturning Moment'
        handles.dataY = handles.DR25.MX;
    case 'Aligning Torque'
        handles.dataY = handles.DR25.MZ;
    case 'Loaded Radius'
        handles.dataY = handles.DR25.RL;
end

% Update handles structure
guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6


% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pos = handles.DR25.pos;
pos = cat(1, 1, pos, length(handles.DR25.SL));

cla
hold all

for i = 1:length(pos)-1
    dataX = handles.dataX(pos(i):5:pos(i+1));
    dataY = handles.dataY(pos(i):5:pos(i+1));
        
    pressure = handles.DR25.P(pos(i):pos(i+1)) / 6.89476; %convert to psi
    camber = handles.DR25.IA(pos(i):pos(i+1));
    force = -handles.DR25.FZ(pos(i):pos(i+1)) / 4.44822; %convert to lbs
    slipAngle = -handles.DR25.SA(pos(i):pos(i+1));
        
    p = round((mean(pressure) - 8) / 2); %results: 0, 1, 2, 3
    c = round(mean(camber)); %results: 0, 2, 4
    f = round(mean(force) / 50 - 1); %results: 0, 2, 3, 4
    s = round(mean(slipAngle) / 3); % results: 0, 1, 2
    
    if (handles.pressure < 0 || handles.pressure == p)
        if (handles.camber < 0 || handles.camber == c)
            if (handles.normalForce < 0 || handles.normalForce == f)
                if (handles.slipAngle < 0 || handles.slipAngle == s)
                    scatter(dataX, dataY);
                end
            end
        end
    end
end
