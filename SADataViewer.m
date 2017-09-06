function varargout = SADataViewer(varargin)
% SADATAVIEWER MATLAB code for SADataViewer.fig
%      SADATAVIEWER, by itself, creates a new SADATAVIEWER or raises the existing
%      singleton*.
%
%      H = SADATAVIEWER returns the handle to a new SADATAVIEWER or the handle to
%      the existing singleton*.
%
%      SADATAVIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SADATAVIEWER.M with the given input arguments.
%
%      SADATAVIEWER('Property','Value',...) creates a new SADATAVIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SADataViewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SADataViewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SADataViewer

% Last Modified by GUIDE v2.5 23-Aug-2017 18:37:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SADataViewer_OpeningFcn, ...
                   'gui_OutputFcn',  @SADataViewer_OutputFcn, ...
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


% --- Executes just before SADataViewer is made visible.
function SADataViewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SADataViewer (see VARARGIN)

% load data
r20 = load('Round-5-SI/B1464run20.mat'); % loading round 20 data
r21 = load('Round-5-SI/B1464run21.mat'); % loading round 21 data

% process data

CR25 = combine(r20, r21); 
CR25 = timeSplice(CR25, r20, r21);
CR25.pos = segment(CR25.SA, 8450, 117280, 2); % Lots of Magic Numbers
handles.CR25 = CR25;

% default values:
handles.pressure = -1;
handles.camber = -1;
handles.normalForce = -1;
handles.dataX = handles.CR25.SA;
handles.dataY = -handles.CR25.FY;

% Choose default command line output for SADataViewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SADataViewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SADataViewer_OutputFcn(hObject, eventdata, handles) 
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
    case '1'
        handles.camber = 1;
    case '2'
        handles.camber = 2;
    case '3'
        handles.camber = 3;
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
    case '100'
        handles.normalForce = 1;
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
    case 'SA'
        handles.dataX = handles.CR25.SA;
    case 'FY'
        handles.dataX = -handles.CR25.FY;
    case 'FX'
        handles.dataX = handles.CR25.FX;
    case 'FZ'
        handles.dataX = -handles.CR25.FZ;
    case 'FY / FZ'
        handles.dataX = handles.CR25.FY ./ handles.CR25.FZ;
    case 'FX / FZ'
        handles.dataX = -handles.CR25.FX ./ handles.CR25.FZ;
    case 'Overturning Moment'
        handles.dataX = handles.CR25.MX;
    case 'Aligning Torque'
        handles.dataX = handles.CR25.MZ;
    case 'Loaded Radius'
        handles.dataX = handles.CR25.RL;
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
    case 'SA'
        handles.dataY = handles.CR25.SA;
    case 'FY'
        handles.dataY = -handles.CR25.FY;
    case 'FX'
        handles.dataY = handles.CR25.FX;
    case 'FZ'
        handles.dataY = -handles.CR25.FZ;
    case 'FY / FZ'
        handles.dataY = handles.CR25.FY ./ handles.CR25.FZ;
    case 'FX / FZ'
        handles.dataY = -handles.CR25.FX ./ handles.CR25.FZ;
    case 'Overturning Moment'
        handles.dataY = handles.CR25.MX;
    case 'Aligning Torque'
        handles.dataY = handles.CR25.MZ;
    case 'Loaded Radius'
        handles.dataY = handles.CR25.RL;
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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pos = handles.CR25.pos;

cla
hold all

for i = 1:2:length(pos)-rem(length(pos),2)-1
    dataX = handles.dataX(pos(i):5:pos(i+1));
    dataY = handles.dataY(pos(i):5:pos(i+1));

    % extracting pressure, camber and normal force data
    pressure = handles.CR25.P(pos(i):pos(i+1)) / 6.89476; %convert to psi
    camber = handles.CR25.IA(pos(i):pos(i+1));
    force = -handles.CR25.FZ(pos(i):pos(i+1)) / 4.44822; %convert to lbs

    % hash functions to map pressure, camber and normal force to index
    % values
    p = round(mean(pressure) / 2) - 4;
    f = round(mean(force) / 50 - 1);
    c = round(mean(camber));
    if (handles.pressure < 0 || handles.pressure == p)
        if (handles.camber < 0 || handles.camber == c)
            if (handles.normalForce < 0 || handles.normalForce == f)
                scatter(dataX, dataY);
            end
        end
    end
end
