function varargout = assign_3(varargin)
% ASSIGN_3 MATLAB code for assign_3.fig
%      ASSIGN_3, by itself, creates a new ASSIGN_3 or raises the existing
%      singleton*.
%
%      H = ASSIGN_3 returns the handle to a new ASSIGN_3 or the handle to
%      the existing singleton*.
%
%      ASSIGN_3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ASSIGN_3.M with the given input arguments.
%
%      ASSIGN_3('Property','Value',...) creates a new ASSIGN_3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before assign_3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to assign_3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help assign_3

% Last Modified by GUIDE v2.5 13-Feb-2017 22:18:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @assign_3_OpeningFcn, ...
                   'gui_OutputFcn',  @assign_3_OutputFcn, ...
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


% --- Executes just before assign_3 is made visible.
function assign_3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to assign_3 (see VARARGIN)

% Choose default command line output for assign_3
handles.output = hObject;
% initializing variables to ensure the user sets them
handles.input_sample_freq = NaN;
handles.input_t = NaN;
handles.input_int_freq = NaN;
handles.input_sat_num = 03;
set(handles.process,'String','Set Parameters');
set(handles.process,'Enable','off');
set(handles.animate,'String','Set Average');
set(handles.animate,'Enable','off');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes assign_3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = assign_3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function average_Callback(hObject, eventdata, handles)
% hObject    handle to average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of average as text
%        str2double(get(hObject,'String')) returns contents of average as a double
avg = str2double(get(hObject,'String'));
% Checks if the input is usable
if isnan(avg) || ~isreal(avg) || avg==1 || avg<0
    % Disable the Plot button and change its string to say why
    set(handles.animate,'String','Enter Valid Average');
    set(handles.animate,'Enable','off');
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject);
else 
    % Enable the Plot button with its original name
    set(handles.animate,'String','Animate');
    set(handles.animate,'Enable','on');
    handles.input_avg = avg;
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function average_CreateFcn(hObject, eventdata, handles)
% hObject    handle to average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in animate.
function animate_Callback(hObject, eventdata, handles)
% hObject    handle to animate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if exist('OutDI.bin','file')~=2
    set(handles.process,'Enable','off');
    set(handles.process,'String','Procecss Data');
else
    set(handles.animate,'Enable','on');
    set(handles.animate,'Backgroundcolor','g')
    set(handles.animate,'String','Plotting');
    set(handles.animate,'Enable','off');
    close(figure(200))
    corrplot(handles.input_avg,handles);
    set(handles.animate,'String','Animate');
    set(handles.animate,'Backgroundcolor','white')
    set(handles.animate,'Enable','on');
end

function time_Callback(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time as text
%        str2double(get(hObject,'String')) returns contents of time as a double
t = str2double(get(hObject,'String'));
if isnan(t) || ~isreal(t)
    % Disable the Plot button and change its string to say why
    set(handles.process,'String','Cannot plot Time');
    set(handles.process,'Enable','off');
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject);
else 
    % Enable the Plot button with its original name
    set(handles.process,'String','Start Processing');
    set(handles.process,'Enable','on');
    handles.input_t = t;
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function sample_freq_Callback(hObject, eventdata, handles)
% hObject    handle to sample_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sample_freq as text
%        str2double(get(hObject,'String')) returns contents of sample_freq as a double
freq = str2double(get(hObject,'String'));
if isnan(freq) || ~isreal(freq)
    % Disable the Plot button and change its string to say why
    set(handles.process,'String','Cannot plot Freq');
    set(handles.process,'Enable','off');
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject);
else 
    % Enable the Plot button with its original name
    set(handles.process,'String','Start Processing');
    set(handles.process,'Enable','on');
    handles.input_sample_freq = freq;
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function sample_freq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sample_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function int_freq_Callback(hObject, eventdata, handles)
% hObject    handle to int_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of int_freq as text
%        str2double(get(hObject,'String')) returns contents of int_freq as a double
int_freq = str2double(get(hObject,'String'));
if isnan(int_freq) || ~isreal(int_freq)
    % Disable the Plot button and change its string to say why
    set(handles.process,'String','Cannot plot Int Freq');
    set(handles.process,'Enable','off');
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject);
else 
    % Enable the Plot button with its original name
    set(handles.process,'String','Start Processing');
    set(handles.process,'Enable','on');
    handles.input_int_freq = int_freq;
    guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function int_freq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to int_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in sat_num.
function sat_num_Callback(hObject, eventdata, handles)
% hObject    handle to sat_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns sat_num contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sat_num

% Grabs drop down value and sets it as the variable
str = get(hObject, 'String');
val = get(hObject,'Value');

handles.input_sat_num = str2double(str{val});

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sat_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sat_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in process.
function process_Callback(hObject, eventdata, handles)
% hObject    handle to process (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if exist('GPSantennaDown.sim','file')~=2 || exist('GPSantennaUp.sim','file')~=2
    set(handles.process,'Enable','off');
    set(handles.process,'String','Need Input Files');
elseif isnan(handles.input_t)
    set(handles.process,'String','Set Time Parameter');
    set(handles.process,'Enable','off');
elseif isnan(handles.input_sample_freq)
    set(handles.process,'String','Set Sample Parameter');
    set(handles.process,'Enable','off');
elseif isnan(handles.input_int_freq)
    set(handles.process,'String','Set Int Parameter');
    set(handles.process,'Enable','off');
else
    set(handles.process,'Backgroundcolor','g');
    set(handles.process,'String','Processing');
    set(handles.process,'Enable','off');
    pause(0.5);
    [e_i,e_q,p_i,p_q,l_i,l_q,carrierfq,codefq]=findandtrack(...
        handles.input_sat_num,handles.input_t,handles.input_sample_freq,...
        handles.input_int_freq);
    guidata(hObject, handles);
    plotresults(e_i,e_q,p_i,p_q,l_i,l_q,carrierfq,codefq,handles);
    set(handles.process,'Backgroundcolor','white');
    set(handles.process,'String','Start Processing');
    set(handles.process,'Enable','on');
end
