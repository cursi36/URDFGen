function CreateRandomRobot
addpath("../")

num_joints = 12;
ds = [];
thetas = [];
as = [];
alphas = [];
%limits on joint types
joint_lims.p = [0,1e03];
joint_lims.r = [-180 180]*pi/180;
%linimits on link_lengths. can be set to num_jointsx2
length_lims = [5 20]*1e-02;
rand_lengths = true;

[DH_tab,types,joint_limits] = getRandomRobot(num_joints,ds,thetas,as,alphas,...
    joint_lims,length_lims,rand_lengths);
joint_limits(:,3:4) = 1e06; %velocity and torque bounds

%Initialize urdfCreator object
URDFgen = urdfCreator("TEST",DH_tab,types,joint_limits);

%Generate urdf and save it as "urdfGen_1.urdf".
% the second value is the link radius (links are supposed to be
% cylindrical).
str = URDFgen.generateURDF("urdfGen_random.urdf",0.05);



end
% generate a random robot with num_joints
% the robot has random joint types (prismatic or revolute)
% link_lengths = lengths of each link
% If the lengths are no known, lengths_lims and rand_length = true are used
% to generate ranodm lengths within the bounds
% joint_lims are the limits for prismatic or revolute joints
function [DH_tab,types,joint_limits] = getRandomRobot(num_joints,ds,thetas,as,alphas,joint_lims,lengths_lims,rand_links)

%possibilities for joint types
%0 = revolute, 1 = prismatic
M = repmat([0,1],num_joints,1);
combs =  Mycombvec(M);
n_comb = randperm(size(combs,2),1);
joints = combs(:,n_comb);

types = "";
joint_limits = zeros(num_joints,2);
for i = 1:num_joints
    
    if joints(i) == 0
        types = types+"r";
        joint_limits(i,:) = joint_lims.r;
    else
        types = types+"p";
        joint_limits(i,:) = joint_lims.p;
    end
end

if rand_links == true
    %possibilities for alphas
    M = repmat([-pi/2,pi/2],num_joints,1);
    combs =  Mycombvec(M);
    n_comb = randperm(size(combs,2),1);
    alphas = combs(:,n_comb);
    
    n_comb = randperm(size(combs,2),1);
    thetas = combs(:,n_comb);
    
    as = (lengths_lims(:,2)-lengths_lims(:,1)).*rand(num_joints,1)+lengths_lims(:,1);
    
    ds = zeros(num_joints,1);
end

%d,theta,a,alpha
DH_tab = zeros(num_joints,4);

DH_tab(:,1) = ds;
DH_tab(:,2) = thetas;
DH_tab(:,3) = as;
DH_tab(:,4) = alphas;

types = char(types);

end