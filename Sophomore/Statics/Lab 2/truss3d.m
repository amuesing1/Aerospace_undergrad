function truss3d(inputfile,outputfile)
% function truss3d(inputfile,outputfile)
%
% Analysis of 3-D statically determinate truss
%
% Input:  inputfile  - name of input file
%         outputfile - name of output file
%
% Original Author: Kurt Maute for ASEN 2001, Sept 21 2011

% read input file
[joints,connectivity,reacjoints,reacvecs,loadjoints,loadvecs]=readinput(inputfile);
%disp(joints)
%find number of bars connected to each joint

%bvectotal is used to find input loads for the monte
bvectotal = zeros((size(joints,1)*3),1);

% compute forces in bars and reactions
n=10000;
vary=0.005;  %vary joint location by 0.005 meters
for i=1:n
[barforces,reacforces,bvec]=forceanalysis(joints,connectivity,reacjoints,reacvecs,loadjoints,loadvecs,vary);
bvectotal=bvectotal+bvec;
max_force(i)=max(barforces);
min_force(i)=min(barforces);
disp(i)
end
bvectotal=bvectotal/n;
%make histogram of max forces
figure(2)
hist(max_force, 50);
xlabel('Max Force');
ylabel('Number of instances');
strTitle = sprintf('Histogram of Max Tension force on bars');
title(strTitle);
strMean = sprintf('Mean: %2.1f, std dev: %2.1f', mean(max_force), std(max_force));
legend(strMean);

figure(3)
hist(min_force, 50);
xlabel('Min Force');
ylabel('Number of instances');
strTitle = sprintf('Histogram of Max Compression force on bars');
title(strTitle);
strMean = sprintf('Mean: %2.1f, std dev: %2.1f', mean(min_force), std(min_force));
legend(strMean);

% write outputfile
writeoutput(outputfile,inputfile,barforces,reacforces,joints,connectivity,reacjoints,reacvecs,loadjoints,loadvecs);

% plot truss (used in Lab 2)
joints3D=zeros(size(joints,1),3);
joints3D(:,1:3)=joints;
plottruss(joints3D,connectivity,barforces,reacjoints,3*[0.003,0.007,0.008],[1 1 0 0])

truss3Dmcs(inputfile)

end


function [joints,connectivity,reacjoints,reacvecs,loadjoints,loadvecs]=readinput(inputfile)
% function [joints,connectivity,reacjoints,reacvecs,loadjoints,loadvecs]=readinput(inputfile)
%
% read input file
%
% input: inputfile - name of input file
%
% output: joints       - coordinates of joints
%         connectivity - connectivity 
%         reacjoints   - joint id where reaction acts on
%         reacvecs     - unit vector associated with reaction force
%         loadjoints   - joint id where external load acts on
%         loadvecs     - load vector
%
% Orignial Author: Kurt Maute, Sept 21 2011

% open inputfile
fid=fopen(inputfile);

if fid<0;error('inputfile does not exist');end

% initialze counters and input block id
counter=0;
inpblk=1;

% read first line
line=fgetl(fid);

% read input file
while line > 0
    
    % check if comment
    if strcmp(line(1),'#')
        % read next line and continue
        line=fgetl(fid);
        continue;
    end
    
    switch inpblk
        
        case 1 % read number of joints, bars, reactions, and loads
            
            dims=sscanf(line,'%d%d%d%d%d');
            
            numjoints = dims(1);
            numbars   = dims(2);
            numreact  = dims(3);
            numloads  = dims(4);
            
            % check for correct number of reaction forces
            if numreact~=6; error('incorrect number of reaction forces');end
            
            % initialize arrays
            joints       = zeros(numjoints,3);
            connectivity = zeros(numbars,2);
            reacjoints   = zeros(numreact,1);
            reacvecs     = zeros(numreact,3);
            loadjoints   = zeros(numloads,1);
            loadvecs     = zeros(numloads,3);
            
            % check whether system satisfies static determiancy condition
            if 3*numjoints - 6 ~= numbars
                error('truss is not statically determinate');
            end

            % expect next input block to be joint coordinates
            inpblk = 2;
            
        case 2 % read coordinates of joints
            
            % increment joint id
            counter = counter + 1;
            
            % read joint id and coordinates;
            tmp=sscanf(line,'%d%e%e%e');
            
            % extract and check joint id
            jointid=tmp(1);
            if jointid>numjoints || jointid<1
                error('joint id number need to be smaller than number of joints and larger than 0');
            end
            
            % store coordinates of joints
            joints(jointid,:)=tmp(2:4);
            
            % expect next input block to be connectivity
            if counter==numjoints
                inpblk  = 3;
                counter = 0;
            end
            
        case 3 % read connectivity of bars
            
            % increment bar id
            counter = counter + 1;
            
            % read connectivity;
            tmp=sscanf(line,'%d%d%d');
            
            % extract bar id number and check
            barid=tmp(1);
            if barid>numbars || barid<0
                error('bar id number needs to be smaller than number of bars and larger than 0');
            end
            
            % check joint ids
            if max(tmp(2:3))>numjoints || min(tmp(2:3))<1
                error('joint id numbers need to be smaller than number of joints and larger than 0');
            end
            
            % store connectivity
            connectivity(barid,:)=tmp(2:3);
            
            % expect next input block to be reaction forces
            if counter==numbars
                inpblk  = 4;
                counter = 0;
            end
            
        case 4 % read reation force information
            
            % increment reaction id
            counter = counter + 1;
            
            % read joint id and unit vector of reaction force;
            tmp=sscanf(line,'%d%e%e%e');
            
            % extract and check joint id
            jointid=tmp(1);
            if jointid>numjoints || jointid<1
                error('joint id number need to be smaller than number of joints and larger than 0');
            end
            
            % extract untit vector and check length
            uvec=tmp(2:4);
            uvec=uvec/norm(uvec);
            
            % store joint id and unit vector
            reacjoints(counter)  = jointid;
            reacvecs(counter,:)  = uvec;
            
            % expect next input block to be external loads
            if counter==numreact
                inpblk  = 5;
                counter = 0;
            end
            
        case 5 % read external load information
            
            % increment reaction id
            counter = counter + 1;
            
            % read joint id and unit vector of reaction force;
            tmp=sscanf(line,'%d%e%e%e');
            
            % extract and check joint id
            jointid=tmp(1);
            if jointid>numjoints || jointid<1
                error('joint id number need to be smaller than number of joints and larger than 0');
            end
            
            % extract force vector
            frcvec=tmp(2:4);
            
            % store joint id and unit vector
            loadjoints(counter) = jointid;
            loadvecs(counter,:) = frcvec;
            
            % expect no additional input block
            if counter==numloads
                inpblk  = 99;
                counter = 0;
            end
            
        otherwise
            %fprintf('warning: unknown input: %s\n',line);
    end
    
    % read next line
    line=fgetl(fid);
end

% close input file
fclose(fid);

end


function [barforces,reacforces,bvec]=forceanalysis(joints,connectivity,reacjoints,reacvecs,loadjoints,loadvecs,vary)
% function [barforces,reacforces]=forceanalysis(joints,connectivity,reacjoints,reacvecs,loadjoints,loadvecs)
%
% compute forces in bars and reaction forces
%
% input:  joints       - coordinates of joints
%         connectivity - connectivity 
%         reacjoints   - joint id where reaction acts on
%         reacvecs     - unit vector associated with reaction force
%         loadjoints   - joint id where external load acts on
%         loadvecs     - load vector
%
% output: barforces    - force magnitude in bars
%         reacforces   - reaction forces
%
% Original Author: Kurt Maute, Sept 21 2011

% % create 5% error
% joints_with_err=joints+.05.*joints.*randn(1);
% %determine exact error
% joints_err=joints_with_err-joints;
% %add total errors
% sum_joints_err_x=sum(joints_err);
% sum_joints_err=sum(sum_joints_err_x,2);
% %find average error
% avg_err=sum_joints_err./size(joints,1);
i=1;
while i<=size(joints,1)
    %create error and store in joints
    joints(i,1)=joints(i,1)+vary*randn(1);
    joints(i,2)=joints(i,2)+vary*randn(1);
    joints(i,3)=joints(i,3)+vary*randn(1);
    %for cordinates of 0, varry based on average error
%     if joints(i,1)==0
%         joints(i,1)=avg_err;
%     end
%     if joints(i,2)==0
%         joints(i,2)=avg_err;
%     end
%     if joints(i,3)==0
%         joints(i,3)=avg_err;
%     end
    i=i+1;
end


% extract number of joints, bars, reactions, and loads
numjoints = size(joints,1);
numbars   = size(connectivity,1);
numreact  = size(reacjoints,1);
numloads  = size(loadjoints,1);

% number of equations
numeqns = 3 * numjoints;

Amat = zeros(numeqns);
bvec = zeros(numeqns,1);

bardensity=0.038; %kg/m
%find length of each bar in meters and find weight in kg
barlength=zeros(numbars,1);
barweight=zeros(numbars,1);
i=1;
while i<=numbars;
    %calculate bar length, 1.27 is from magnet length
    barlength(i,1)=sqrt(sum((joints(connectivity(i,2),:)-joints(connectivity(i,1),:)).^2))-0.0127*2;
    barweight(i,1)=(barlength(i,1)*bardensity +0.00169*2);
    
    
    
    i=i+1;
end

%disp('bar lengths with zero error in meters')
%disp(barlength*100)
%disp('bar length with zero error in inches')
%disp(barlength/0.0254)







% allocate arrays for linear system


% build Amat - loop over all joints
for i=1:numjoints
    
   % equation id numbers
   idx = 3*i-2;
   idy = 3*i-1;
   idz = 3*i;
   
   % get all bars connected to joint
   [ibar,ijt]=find(connectivity==i);
   % loop over all bars connected to joint
   for ib=1:length(ibar)
       
       % get bar id
       barid=ibar(ib);
       
       % get coordinates for joints "i" and "j" of bar "barid"
       joint_i = joints(i,:);
       if ijt(ib) == 1
           jid = connectivity(barid,2);
       else
           jid = connectivity(barid,1);
       end
       joint_j = joints(jid,:);
       
       % compute unit vector pointing away from joint i
       vec_ij = joint_j - joint_i;
       uvec   = vec_ij/norm(vec_ij);
       
       % add unit vector into Amat
       Amat([idx idy idz],barid)=uvec;
   end

   connections=length(ibar);
%    disp(connections)
  j=1;
  %add weight of ball to each joint, because its a ball
   bvec(3*i,1)=0.00839*9.8;
   %add weight of bars
   while j<=connections
       bvec(3*i,1)= bvec(3*i,1)+ 9.8*barweight(ibar(j,1),1)/2;
        j=j+1;
   end
   
end

% build contribution of support reactions 
for i=1:numreact
    
    % get joint id at which reaction force acts
    jid=reacjoints(i);

    % equation id numbers
    idx = 3*jid-2;
    idy = 3*jid-1;
    idz = 3*jid;

    % add unit vector into Amat
    Amat([idx idy idz],numbars+i)=reacvecs(i,:);
end

%build load vector
for i=1:numloads
    
    % get joint id at which external force acts
    jid=loadjoints(i);

    % equation id numbers
    idx = 3*jid-2;
    idy = 3*jid-1;
    idz = 3*jid;

    % add unit vector into bvec (sign change)
    bvec([idx idy idz])=-loadvecs(i,:);
end


for i=1:numloads;
    
    % get joint id at which external force acts
    jid=loadjoints(i);
    
    

    % equation id numbers
    idx = 3*jid-2;
    idy = 3*jid-1;
    idz = 3*jid;

    % add unit vector into bvec (sign change)
    bvec([idx idy idz])=-loadvecs(i,:);
end




% check for invertability of Amat
if rank(Amat) ~= numeqns
    error('Amat is rank defficient: %d < %d\n',rank(Amat),numeqns);
end

% solve system
xvec=Amat\bvec;

% extract forces in bars and reaction forces
barforces=xvec(1:numbars);
reacforces=xvec(numbars+1:end);

end


function truss3Dmcs(inputfile)
% function truss3D(inputfile,outputfile)
%
% Stochastic analysis of 3-D statically determinate truss by
% Monte Carlo Simulation. Only positions and strength of joints 
% treated as random variables
%
% Assumption: variation of joint strength and positions described 
%             via Gaussian distributions
% 
%             joint strength : mean = 15
%                              coefficient of varation = 0.1
%             joint position : 
%                              coefficient of varation = 0.01
%                              (defined wrt to maximum dimension of truss)
%
%             number of samples is set to 1e5
%
% Input:  inputfile  - name of input file
%
% Author: Kurt Maute for ASEN 2001, Oct 13 2012

% parameters
jstrmean   = 4.8;    % mean of joint strength
jstrcov    = 0.083;   % coefficient of variation of joint strength
jposcov    = 0.005;  % coefficient of variation of joint position
numsamples = 1e5;   % number of samples

% read input file
[joints,connectivity,reacjoints,reacvecs,loadjoints,loadvecs]=readinput(inputfile);

% determine extension of truss
ext_x=max(joints(:,1))-min(joints(:,1));   % extension in x-direction
ext_y=max(joints(:,2))-min(joints(:,2));   % extension in y-direction
ext_z=max(joints(:,3))-min(joints(:,3));   % extension in z-direction
ext  =max([ext_x,ext_y,ext_z]);

% loop overall samples
numjoints=size(joints,1);       % number of joints
maxforces=zeros(numsamples,1);  % maximum bar forces for all samples
maxreact=zeros(numsamples,1);   % maximum support reactions for all samples
failure=zeros(numsamples,1);    % failure of truss
vary=0.000000000000000001   %almost zero variation so that truss3dmcs can control error
for i=1:numsamples 
    
    % generate random joint strength limit
    varstrength = (jstrcov*jstrmean)*randn(1,1);
    
    jstrength = jstrmean + varstrength;
    
    % generate random samples
    varjoints = (jposcov*ext)*randn(numjoints,3);
    
    % perturb joint positions
    randjoints = joints + varjoints;
    
    % compute forces in bars and reactions
    [barforces,reacforces] = forceanalysis(randjoints,connectivity,reacjoints,reacvecs,loadjoints,loadvecs,vary);
    
    % determine maximum force magnitude in bars and supports
    maxforces(i) = max(abs(barforces));
    maxreact(i)  = max(abs(reacforces));
    
    % determine whether truss failed
    failure(i) = maxforces(i) > jstrength || maxreact(i) > jstrength;
end

figure(4);
subplot(1,2,1);
hist(maxforces,30);
%axis([0,100,0,100])
title('Histogram of maximum bar forces');
xlabel('Magnitude of bar forces');
ylabel('Frequency');

subplot(1,2,2);
hist(maxreact,30);
%axis([0,100,0,100]);
title('Histogram of maximum support reactions');
xlabel('Magnitude of reaction forces');
ylabel('Frequency');

fprintf('\nFailure probability : %e \n\n',sum(failure)/numsamples);

end


function writeoutput(outputfile,inputfile,barforces,reacforces,joints,connectivity,reacjoints,reacvecs,loadjoints,loadvecs)
% writeoutput(outputfile,inputfile,barforces,reacforces,joints,connectivity,reacjoints,reacvecs,loadjoints,loadvecs);
%
% output analysis results
%
% input:  outputfile   - name of output file
%         inputfile    - name of input file
%         barforces    - force magnitude in bars
%         reacforces   - reaction forces
%         joints       - coordinates of joints
%         connectivity - connectivity 
%         reacjoints   - joint id where reaction acts on
%         reacvecs     - unit vector associated with reaction force
%         loadjoints   - joint id where external load acts on
%         loadvecs     - load vector
%
% output: ASCII file with formatted data
%
% Orignial Author: Kurt Maute, Sept 21 2011

% open output file
fid=fopen(outputfile,'w');

% write header
fprintf(fid,'3-D Truss analysis\n');
% write name of input file
fprintf(fid,'Input file: %s\n',inputfile);
fprintf(fid,'Date: %s\n',datestr(now));
fprintf(fid,'--------------------------------------------------------------\n\n');

% write coordinates of joints
fprintf(fid,'Joints:         Joint-id  x-coordinate y-coordinate z-coordinate\n');
for i=1:size(joints,1)
    fprintf(fid,'%17d %12.2f %12.2f %12.2f\n',i,joints(i,1),joints(i,2),joints(i,3));
end
fprintf(fid,'\n\n');

% write external loads
fprintf(fid,'External loads: Joint-id  Force-x      Force-y      Force-z\n');
for i=1:size(loadjoints,1)
    fprintf(fid,'%17d %12.2f %12.2f %12.2f\n',loadjoints(i),loadvecs(i,1),loadvecs(i,2),loadvecs(i,3));
end
fprintf(fid,'\n');
    
% write connectivity and forces
fprintf(fid,'Bars:           Bar-id    Joint-i      Joint-j     Force    (T,C)\n');
for i=1:size(connectivity,1)
    if barforces(i)>0;tc='T';else tc='C';end
    fprintf(fid,'%17d   %7d %12d    %12.3f     (%s)\n',...
        i,connectivity(i,1),connectivity(i,2),abs(barforces(i)),tc);
end
fprintf(fid,'\n');

% write connectivity and forces
fprintf(fid,'Reactions:      Joint-id  Uvec-x       Uvec-y       Uvec-z      Force\n');
for i=1:size(reacjoints,1)
    fprintf(fid,'%17d %12.2f %12.2f %12.2f %12.3f\n',reacjoints(i),reacvecs(i,1),reacvecs(i,2), reacvecs(i,3),reacforces(i));
end

% close output file
fclose(fid);

disp(strjoin({'Ouput File Successfully Written:', outputfile}))
end


function plottruss(xyz,topo,eforce,fbc,rads,pltflags)
%function plottruss(xyz,topo,eforce,fbc,rads,pltflags)
%----------------------------------------------------
%
%  plot 3-truss, bars colored accoring to force
%  supported nodes are plotted in red
%  non-supported nodes are plotted in black
%
%  Input:   xyz -  x,y,and z coordinates of nodes 
%                  ( number of nodes x 3 )
% 
%                    Node 1 - [ x1 y1 z1;
%                    Node 2 -   x2 y2 z2;
%                      ...        ...
%                    Node n -   xn yn zn ];
%
%           topo -  topology of truss
%                   ( number of bars x 2 )
% 
%                    Member 1 - [ NodeA NodeB;
%                    Member 2 -   NodeD NodeC;
%                      ...           ...
%                    Member m -   NodeX NodeK ];
%
%           eforce - internal bar forces
%                    ( number of bars x 1 )
%
%                    Member 1 - [ InternalForce1;
%                    Member 2 -   InternalForce2;
%                      ...           ...
%                    Member m -   InternalForceM ];
%
%           fbc -    id numbers of nodes which are supported
%                    ( number of supported nodes x 1 )
%
%           rads -   plot radius of bars and joints
%                        1 x 1 : automatic ratio (Recommend: 0.01)
%                        3 x 1 : [ bar, node, suported node]
%
%           pltflags - flags for printing annotation
%                      (3 x 1)
%                      1. component: 0/1 - plot node id numbers
%                      2. component: 0/1 - plot bar id numbers
%                      3. component: 0/1 - plot force value
%                      4. component: 0/1 - 2D(0) or 3D(1) view 
%
%--------------------------------------------------------
% Kurt Maute for ASEN 2001 Oct. 2006
%   Revised Oct. 2007 by Sungeun Jeon
%   Revised Sep. 2010 by Kurt Maute
%--------------------------------------------------------

figure(1);
clf;

% check input

if nargin < 6; error('routine requires 6 input parameters'); end

% extract

[numnode, dim]=size(xyz);
numelem = size(topo,1);

if dim ~= 3
   display('Error in plottruss: 3 coordinates are needed for array xyz');
   return;
end

% extract min and max force values

minfrc=floor(min(eforce));
maxfrc=ceil(max(eforce));

% define radius of bars

if length(rads) == 1
    radb = rads(1);
    radj = 1.75*radb;
    radk = 1.5*radj;
else
    radb = rads(1);
    radj = rads(2);
    radk = rads(3);
end

% plot bars

figure(1)

for i=1:numelem
    na=topo(i,1);
    nb=topo(i,2);
    [xc,yc,zc]=plotbar(xyz(na,:),xyz(nb,:),radb);
    cc=eforce(i)*ones(size(xc));
    surf(xc,yc,zc,cc,'EdgeColor','none');
    if pltflags(2) > 0
        text((xyz(na,1)+xyz(nb,1))/2+1.8*radb,(xyz(na,2)+xyz(nb,2))/2+1.8*radb,(xyz(na,3)+xyz(nb,3))/2+1.8*radb,num2str(i));
    end
    if pltflags(3) > 0
        text((xyz(na,1)+xyz(nb,1))/2+1.8*radb,(xyz(na,2)+xyz(nb,2))/2+1.8*radb,(xyz(na,3)+xyz(nb,3))/2+1.8*radb,sprintf('%.2f',eforce(i)));
    end
    hold on;
end

% plot node id numbers

if pltflags(1) > 0
    for i=1:numnode
            text(xyz(i,1)+1.8*radj,xyz(i,2)+1.5*radj,xyz(i,3)+1.3*radj,num2str(i));
    end
end
    
colorbar;
caxis([minfrc maxfrc])

% plot ball joints

for i=1:numnode
    [sx,sy,sz]=plotnode(xyz(i,:),radj);
    surf(sx,sy,sz,'EdgeColor','none','FaceColor','black');
    hold on;
end

% plot supported nodes

for i=1:length(fbc)
    na=fbc(i);
    [sx,sy,sz]=plotnode(xyz(na,:),radk);
    surf(sx,sy,sz,'EdgeColor','none','FaceColor','red');
    hold on;
end

% plot parameters

axis('equal');
title('Member forces');

lightangle(-45,30)
set(gcf,'Renderer','openGl')
set(findobj(gca,'type','surface'),...
    'FaceLighting','phong',...
    'AmbientStrength',.3,'DiffuseStrength',.8,...
    'SpecularStrength',.9,'SpecularExponent',25,...
    'BackFaceLighting','unlit')

if pltflags(4) 
    % use default
else
    % set view point to 0,0,1
    view([0 0 1]);    
end

return

function [sx,sy,sz]=plotnode(xyz,rads)
%--------------------------------------------------------
% returns sphere of radius rads at position xyz (3x1)
%--------------------------------------------------------
% Kurt Maute for ASEN 2001 Oct. 2006
%--------------------------------------------------------
[sx,sy,sz]=sphere(30);
nl=length(sx);
omat=ones(size(sx));
sx=rads*sx+xyz(1)*omat;
sy=rads*sy+xyz(2)*omat;
sz=rads*sz+xyz(3)*omat;

return
end

function [xc,yc,zc]=plotbar(xa,xb,rads)
%--------------------------------------------------------
% returns cylinder of radius rads
% endpoints defined by xa (3x1) and xb (3x1)
%--------------------------------------------------------
% Kurt Maute for ASEN 2001 Oct. 2006
%--------------------------------------------------------

xba=xb-xa;
len=norm(xba);

% create basic cylinder

[xc,yc,zc]=cylinder([rads rads],20);

% stretch cylinder

cmat=[len*zc' xc' yc']; 

% create transformation matrix

ev1=1/len*xba';
eva=[ev1(2); -ev1(1); 0];

if (norm(eva) == 0)
    eva=[ev1(3); 0;  -ev1(1)];
    if (norm(eva) == 0)
      eva=[0; ev1(3); -ev1(2)];
    end
end

eva=1/norm(eva)*eva;
ev2=cross(ev1,eva);
ev3=cross(ev1,ev2);

T=[ev1 ev2 ev3];

% rotate cylinder

cpmat(:,[1 3 5])=(T*cmat(:,[1 3 5])')';
cpmat(:,[2 4 6])=(T*cmat(:,[2 4 6])')';

nl=length(xc);
omat=ones(nl,1);

xc(1,:)=cpmat(:,1)+xa(1)*omat;
xc(2,:)=cpmat(:,2)+xa(1)*omat;
yc(1,:)=cpmat(:,3)+xa(2)*omat;
yc(2,:)=cpmat(:,4)+xa(2)*omat;
zc(1,:)=cpmat(:,5)+xa(3)*omat;  
zc(2,:)=cpmat(:,6)+xa(3)*omat;  

return
end
end