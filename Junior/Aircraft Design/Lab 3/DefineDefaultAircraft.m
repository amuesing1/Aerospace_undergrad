% DefineDefaultAircraft.m
% Defines vertices V and faces F needed for animation function DrawAircraft

% Geometry
fuse_h = 1;
fuse_w = 1;
fuse_l1 = 3;
fuse_l2 = 1;
fuse_l3 = 10;

wing_l = 1.5;
wing_w = 9;

tailwing_l = 1;
tailwing_w = 4;

tail_h = 3;



% Define the vertices (physical location of vertices
  V = [...
	 fuse_l1    0    0;... % point 1
     fuse_l2   fuse_w/2    -fuse_h/2;... % point 2
     fuse_l2   -fuse_w/2    -fuse_h/2;... % point 3
     fuse_l2   -fuse_w/2    fuse_h/2;... % point 4
	 fuse_l2   fuse_w/2    fuse_h/2;... % point 5
     -fuse_l3   0   0;... % point 6
     
     0   wing_w/2   0;... % point 7
     -wing_l   wing_w/2   0;... % point 8
	 -wing_l   -wing_w/2   0;... % point 9
     0   -wing_w/2   0;... % point 10
     
    -fuse_l3+tailwing_l  tailwing_w/2  0;... % point 11
    -fuse_l3  tailwing_w/2  0;... % point 12
    -fuse_l3  -tailwing_w/2  0;... % point 13
    -fuse_l3+tailwing_l  -tailwing_w/2  0;... % point 14
    
    -fuse_l3+tailwing_l 0  0;... % point 15
    -fuse_l3  0  -tail_h;... % point 16
  ];

pts.fuse = [...
    V(1,:);...
    V(2,:);...
    V(6,:);...
    V(3,:);...
    V(1,:);...
    V(5,:);...
    V(6,:);...
    V(5,:);...
    V(1,:)]';

pts.wing = [...
    V(7,:);...
    V(8,:);...
    V(9,:);...
    V(10,:);...
    V(7,:)]';

pts.tailwing = [...
    V(11,:);...
    V(12,:);...
    V(13,:);...
    V(14,:);...
    V(11,:)]';

pts.tail = [...
    V(6,:);...
    V(15,:);...
    V(16,:);...
    V(6,:)]';

%%% Below Not Used For Now

% define faces as a list of vertices numbered above
  F = [...
        1, 2,  6,  5;...  % front
        4, 3,  7,  8;...  % back
        1, 5,  8,  4;...  % right 
        2, 6,  7,  3;...  % left
        
        5, 6,  7,  8;...  % top
        9, 10, 11, 12;... % bottom
        ];

% define colors for each face    
  myred = [1, 0, 0];
  mygreen = [0, 1, 0];
  myblue = [0, 0, 1];
  myyellow = [1, 1, 0];
  mycyan = [0, 1, 1];

  patchcolors = [...
    myred;...    % front
    mygreen;...  % back
    myblue;...   % right
    myyellow;... % left
    mycyan;...   % top
    mycyan;...   % bottom
    ];