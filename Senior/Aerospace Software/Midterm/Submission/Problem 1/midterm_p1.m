function varargout = midterm_p1(varargin)
% MIDTERM_P1 MATLAB code for midterm_p1.fig
%      MIDTERM_P1, by itself, creates a new MIDTERM_P1 or raises the existing
%      singleton*.
%
%      H = MIDTERM_P1 returns the handle to a new MIDTERM_P1 or the handle to
%      the existing singleton*.
%
%      MIDTERM_P1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MIDTERM_P1.M with the given input arguments.
%
%      MIDTERM_P1('Property','Value',...) creates a new MIDTERM_P1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before midterm_p1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to midterm_p1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help midterm_p1

% Last Modified by GUIDE v2.5 20-Mar-2017 23:10:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @midterm_p1_OpeningFcn, ...
    'gui_OutputFcn',  @midterm_p1_OutputFcn, ...
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


% --- Executes just before midterm_p1 is made visible.
function midterm_p1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to midterm_p1 (see VARARGIN)

% Choose default command line output for midterm_p1
handles.output = hObject;
handles.kind=3;
set(handles.go_graph,'String','Set Parameters');
set(handles.go_graph,'Enable','off');
handles.r=.07;
handles.CD=.5;
handles.x0=NaN;
handles.y0=NaN;
handles.vx0=NaN;
handles.vy0=NaN;
handles.m0=NaN;
handles.e0=NaN;
handles.n0=NaN;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes midterm_p1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = midterm_p1_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function x0_Callback(hObject, eventdata, handles)
% hObject    handle to x0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x0 as text
%        str2double(get(hObject,'String')) returns contents of x0 as a double
x0 = str2double(get(hObject,'String'));
if isnan(x0) || ~isreal(x0)
    % Disable the Plot button and change its string to say why
    set(handles.go_graph,'String','X0 not real');
    set(handles.go_graph,'Enable','off');
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject);
else
    % Enable the Plot button with its original name
    set(handles.go_graph,'String','Graph!');
    set(handles.go_graph,'Enable','on');
    handles.x0 = x0;
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function x0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vx0_Callback(hObject, eventdata, handles)
% hObject    handle to vx0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vx0 as text
%        str2double(get(hObject,'String')) returns contents of vx0 as a double
vx0 = str2double(get(hObject,'String'));
if isnan(vx0) || ~isreal(vx0)
    % Disable the Plot button and change its string to say why
    set(handles.go_graph,'String','VX0 not real');
    set(handles.go_graph,'Enable','off');
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject);
else
    % Enable the Plot button with its original name
    set(handles.go_graph,'String','Graph!');
    set(handles.go_graph,'Enable','on');
    handles.vx0 = vx0;
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function vx0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vx0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y0_Callback(hObject, eventdata, handles)
% hObject    handle to y0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y0 as text
%        str2double(get(hObject,'String')) returns contents of y0 as a double
y0 = str2double(get(hObject,'String'));
if isnan(y0) || ~isreal(y0)
    % Disable the Plot button and change its string to say why
    set(handles.go_graph,'String','Y0 not real');
    set(handles.go_graph,'Enable','off');
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject);
else
    % Enable the Plot button with its original name
    set(handles.go_graph,'String','Graph!');
    set(handles.go_graph,'Enable','on');
    handles.y0 = y0;
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function y0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vy0_Callback(hObject, eventdata, handles)
% hObject    handle to vy0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vy0 as text
%        str2double(get(hObject,'String')) returns contents of vy0 as a double
vy0 = str2double(get(hObject,'String'));
if isnan(vy0) || ~isreal(vy0)
    % Disable the Plot button and change its string to say why
    set(handles.go_graph,'String','Y0 not real');
    set(handles.go_graph,'Enable','off');
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject);
else
    % Enable the Plot button with its original name
    set(handles.go_graph,'String','Graph!');
    set(handles.go_graph,'Enable','on');
    handles.vy0 = vy0;
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function vy0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vy0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m_Callback(hObject, eventdata, handles)
% hObject    handle to m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m as text
%        str2double(get(hObject,'String')) returns contents of m as a double
m = str2double(get(hObject,'String'));
if isnan(m) || ~isreal(m)
    % Disable the Plot button and change its string to say why
    set(handles.go_graph,'String','Y0 not real');
    set(handles.go_graph,'Enable','off');
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject);
else
    % Enable the Plot button with its original name
    set(handles.go_graph,'String','Graph!');
    set(handles.go_graph,'Enable','on');
    handles.m = m;
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function m_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function e_Callback(hObject, eventdata, handles)
% hObject    handle to e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e as text
%        str2double(get(hObject,'String')) returns contents of e as a double
e = str2double(get(hObject,'String'));
if isnan(e) || ~isreal(e)
    % Disable the Plot button and change its string to say why
    set(handles.go_graph,'String','E not real');
    set(handles.go_graph,'Enable','off');
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject);
elseif e>=1 || e<=0
    % Disable the Plot button and change its string to say why
    set(handles.go_graph,'String','0<E<1');
    set(handles.go_graph,'Enable','off');
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject);
else
    % Enable the Plot button with its original name
    set(handles.go_graph,'String','Graph!');
    set(handles.go_graph,'Enable','on');
    handles.e = e;
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function e_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function n_Callback(hObject, eventdata, handles)
% hObject    handle to n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of n as text
%        str2double(get(hObject,'String')) returns contents of n as a double
n = str2double(get(hObject,'String'));
if isnan(n) || ~isreal(n)
    % Disable the Plot button and change its string to say why
    set(handles.go_graph,'String','Y0 not real');
    set(handles.go_graph,'Enable','off');
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject);
else
    % Enable the Plot button with its original name
    set(handles.go_graph,'String','Graph!');
    set(handles.go_graph,'Enable','on');
    handles.n = n;
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ball.
function ball_Callback(hObject, eventdata, handles)
% hObject    handle to ball (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ball contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ball
val = get(hObject, 'Value');
str = get(hObject, 'String');
switch str{val}
    case 'Tennis Ball (smooth)'
        handles.r=.07;
        handles.CD=.5;
    case 'Golf Ball (dimpled)'
        handles.r=.022;
        handles.CD=.3;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ball_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ball (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in go_graph.
function go_graph_Callback(hObject, eventdata, handles)
% hObject    handle to go_graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isnan(handles.x0)
    set(handles.process,'String','Set X0');
    set(handles.process,'Enable','off');
elseif isnan(handles.y0)
    set(handles.process,'String','Set Y0');
    set(handles.process,'Enable','off');
elseif isnan(handles.vx0)
    set(handles.process,'String','Set VX0');
    set(handles.process,'Enable','off');
elseif isnan(handles.vy0)
    set(handles.process,'String','Set YX0');
    set(handles.process,'Enable','off');
elseif isnan(handles.m)
    set(handles.process,'String','Set M');
    set(handles.process,'Enable','off');
elseif isnan(handles.e)
    set(handles.process,'String','Set E');
    set(handles.process,'Enable','off');
elseif isnan(handles.n)
    set(handles.process,'String','Set N');
    set(handles.process,'Enable','off');
else
    [t,x,y]=simulate_projectile(handles.x0,handles.y0,handles.vx0,handles.vy0,...
        handles.m,handles.r,handles.CD,handles.e,handles.n);
    if handles.kind==1
        plot(t,x)
        title('Time vs Xposition')
        xlabel('Time (s)')
        ylabel('Xposition (m)')
    elseif handles.kind==2
        plot(t,y)
        title('Time vs Yposition')
        xlabel('Time (s)')
        ylabel('Yposition (m)')
    elseif handles.kind==3
        plot(x,y)
        title('Trajectory')
        xlabel('Xposition (m)')
        ylabel('Yposition (m)')
    end
end


% --- Executes on selection change in graph_sel.
function graph_sel_Callback(hObject, eventdata, handles)
% hObject    handle to graph_sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns graph_sel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from graph_sel
val = get(hObject, 'Value');
str = get(hObject, 'String');
switch str{val}
    case 'Time vs Xposition'
        handles.kind=1;
    case 'Time vs Yposition'
        handles.kind=2;
    case 'Xposition vs Yposition'
        handles.kind=3;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function graph_sel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to graph_sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
