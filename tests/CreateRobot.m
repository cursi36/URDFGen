function CreateRobot
addpath("../")

[DH_tab,types,joint_limits] = getRobot();
joint_limits(:,3:4) = 1e06; %velocity and torque bounds

%Initialize urdfCreator object
URDFgen = urdfCreator("TEST",DH_tab,types,joint_limits);

%Generate urdf and save it as "urdfGen_1.urdf".
% the second value is the link radius (links are supposed to be
% cylindrical).
str = URDFgen.generateURDF("urdfGen_10.urdf",0.01,0.01,0);



end
% generate a random robot with num_joints
% the robot has random joint types (prismatic or revolute)
% link_lengths = lengths of each link
% If the lengths are no known, lengths_lims and rand_length = true are used
% to generate ranodm lengths within the bounds
% joint_lims are the limits for prismatic or revolute joints
function [DH_tab,types,joint_limits] = getRobot()

num_joints = 10;

types = 'prrrrrrrrr';
joint_limits = zeros(num_joints,2);
for i = 1:num_joints
    
    if types(i) == 'r'
        joint_limits(i,:) = [-pi pi];
    else
        joint_limits(i,:) = [0 1e01];
    end
end
% ds = [0.05 0 0 0.15 0 0 0.15 0 0 0.15];
% thetas = [0 pi/2 pi/2 pi/2 pi/2 pi/2 pi/2 pi/2 pi/2 0];
% as = [0.0 0 0 0 0 0 0 0 0 0];
% alphas = [pi/2 pi/2 pi/2 pi/2 pi/2 pi/2 pi/2 pi/2 pi/2 0];

l = 0.05;
ds = [0.15 0 0 0 0 0 0. 0 0 l];
thetas = [0 pi/2 0 0 0 0 0 0 pi/2 0];
as = [0.0 l l l l l l l 0 0];
alphas = [pi/2 pi/2 -pi/2 pi/2 -pi/2 pi/2 -pi/2 pi/2 pi/2 0];

%d,theta,a,alpha
DH_tab = zeros(num_joints,4);

DH_tab(:,1) = ds;
DH_tab(:,2) = thetas;
DH_tab(:,3) = as;
DH_tab(:,4) = alphas;

types = char(types);

end