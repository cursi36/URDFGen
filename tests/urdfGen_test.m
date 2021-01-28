addpath("../")

%The columns are
%|d | theta | a | alpha
DH_tab = [1 0 0.5 pi/2;
    0 0 0.5 0;
    0 0 0.5 0];
%joint types: p = prismatic; r = revolute
types = 'prr';

%joint limits.
%the columns are: |minimum joint position range| maximum joint position
%range| maximum effort |maximum velocity|.
limits = [0 0.3 1e06 1e06;
    -pi pi 1e06 1e06;
    -pi pi 1e06 1e06];
   
%Initialize urdfCreator object
URDFgen = urdfCreator("TEST",DH_tab,types,limits);

%Generate urdf and save it as "urdfGen_1.urdf".
% the second value is the link radius (links are supposed to be
% cylindrical).
str = URDFgen.generateURDF("urdfGen_1.urdf",0.05);

%%%%%%%%%%%%%%
% Same as above but different robotic structure

DH_tab = [1 pi/2 0 pi/2;
    0 pi/2 0 -pi/2;
    0 0 0.5 pi/2;
    0 0 0 -pi/2;
    0 0 0.5 0];

types = 'prrrr';

limits = [0 0.3 1e06 1e06;
    -pi pi 1e06 1e06;
    -pi pi 1e06 1e06;
    -pi pi 1e06 1e06;
    -pi pi 1e06 1e06];
    
URDFgen = urdfCreator("TEST",DH_tab,types,limits);

str = URDFgen.generateURDF("urdfGen.urdf",0.05);