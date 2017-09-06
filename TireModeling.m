function varargout = TireModeling(varargin)
% TIREMODELING MATLAB code for TireModeling.fig
%      TIREMODELING, by itself, creates a new TIREMODELING or raises the existing
%      singleton*.
%
%      H = TIREMODELING returns the handle to a new TIREMODELING or the handle to
%      the existing singleton*.
%
%      TIREMODELING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TIREMODELING.M with the given input arguments.
%
%      TIREMODELING('Property','Value',...) creates a new TIREMODELING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TireModeling_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TireModeling_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TireModeling

% Last Modified by GUIDE v2.5 03-Aug-2017 15:23:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TireModeling_OpeningFcn, ...
                   'gui_OutputFcn',  @TireModeling_OutputFcn, ...
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
end

% --- Executes just before TireModeling is made visible.
function TireModeling_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TireModeling (see VARARGIN)

% Load data here:

handles.SAInterp = load("Pacejka_Interpolation_SA.mat");
handles.SRInterp = load("Pacejka_Interpolation_SR.mat");

% Initialize default values:
handles.pressure = 8; %psi
handles.camber = 0; %degrees
handles.normalForce = 50; %pounds
handles.slipAngle = 0; %degress

% Choose default command line output for TireModeling
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TireModeling wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = TireModeling_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in pushbutton1.
% --- Slip Angle vs Lateral Force graphing
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%disp(handles.pressure);
%disp(handles.camber);
%disp(handles.normalForce);

p = zeros(1, 100);
for i = 0:3
    for j = 0:4
        for k = 0:4
            index = i * 25 + j * 5 + k + 1;
            p(index) = handles.pressure^i * handles.camber^j * (handles.normalForce / 50)^k;
        end
    end
end
SABound = 0.3; %radians
x = p * handles.SAInterp.coEff;
y = @(xdata) x(3)*sin(x(2)*atan(x(1)*xdata - x(4)*(x(1)*xdata - atan(x(1)*xdata))));
fplot(y, [-SABound, SABound], 'r')

disp('SA graphed');
end



% --- Executes on button press in pushbutton2.
% --- Slip Ratio vs Longitudinal Force graphing
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

p = zeros(1, 144);
for i = 0:3
    for j = 0:2
        for k = 0:3
            for l = 0:2
                index = i*3*4*3 + j*4*3 + k*3 + l + 1;
                p(index) = handles.pressure^i * handles.camber^j * (handles.normalForce / 50)^k * handles.slipAngle^l;
            end
        end
    end
end

SRBound = 0.3 * pi / 180;
x = p * handles.SRInterp.coEff;
y = @(xdata) x(3)*sin(x(2)*atan(x(1)*xdata - x(4)*(x(1)*xdata - atan(x(1)*xdata))));
fplot(y, [-SRBound, SRBound], 'r')

disp('SR graphed');
end


function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.pressure = str2double(get(hObject, 'String'));
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
end

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.camber = str2double(get(hObject, 'String'));
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
end

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.normalForce = str2double(get(hObject, 'String'));
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
end

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.slipAngle = str2double(get(hObject, 'String'));
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
end

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end