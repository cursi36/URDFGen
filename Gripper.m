function str = Gripper(parent,Pose,R,theta_grip,gripper_length,link_radius,link_mass)
R_link = [0 0 1;
    0 -1 0;
    1 0 0];
str = "";
ee_link = parent;

j_type = "prismatic";

j_name = "gripper";
%                 l_name = link_name+num2str(i-1);
c_name = "gripper_case";
f_name = "gripper_fixed";

%                 parent = l_name;
child = c_name;

% R_gripper = [0 0 1;
%     0 -1 0;
%     1 0 0];

R_gripper_link = [cos(theta_grip) -sin(theta_grip) 0;
    sin(theta_grip) cos(theta_grip) 0;
    0 0 1];

R_gripper_link = R_gripper_link*[0 1 0;
    0 0 1;
    1 0 0];

R_gripper = R*R_gripper_link;

str = str+generate_joint_xacro(f_name,"fixed",Pose(1:3,4),R_gripper,ee_link,child,[0 0 1],...
    [0 0 1e06 1e06]);

str = str+generate_casing_xacro(c_name,gripper_length/2,j_type);

child = "jaw_1";
%%joint i-1
str = str+generate_joint_xacro(j_name,j_type,zeros(3,1),eye(3,3),c_name,child,...
    [0 0 1],[-2*link_radius,0,1e06,1e06] );

%%%gripper model%%%%%%
d = link_radius; theta = 0; a = gripper_length; alpha = 0;
R_z = [cos(theta) -sin(theta) 0;
    sin(theta) cos(theta) 0;
    0 0 1];

%                 str = str+generate_joint_xacro(f_name,"fixed",zeros(3,1),eye(3),c_name,child,[0 0 1],...
%                     [0 0 1e06 1e06]);

R = R_z*R_link;
str_link = generate_link_jaw_xacro(child,gripper_length/4,link_mass,R_z*[a;0;d],R,[0 0 0]);
str = str+str_link;

child = "jaw_2";

f_name = "fixed_ee_2";
str = str+generate_joint_xacro(f_name,"fixed",Pose(1:3,4),R_gripper,ee_link,child,[0 0 1],...
    [0 0 1e06 1e06]);

str_link = generate_link_jaw_xacro(child,gripper_length/4,link_mass,R_z*[a;0;-d],R,[0 0 0]);
str = str+str_link;

end


%generaes link to offset along x,y
function str = generate_link_jaw_xacro(name,radius,mass,Pi_i_1,Ri_i_1,color)
link_name = name;

link_length = norm(Pi_i_1(1:2));
link_radius = radius;

Ixx = 1/12*mass*link_length^2+1/4*mass*link_radius^2;    Ixy = 0;    Ixz = 0;
Iyy = 1/12*mass*link_length^2+1/4*mass*link_radius^2;    Iyz = 0;    
Izz = 1/2*mass*link_radius^2; 

origin_xyz = [Pi_i_1(1:2)'/2 Pi_i_1(3)];
origin_rpy = fliplr(rotm2eul(Ri_i_1));

%name
str = '<link name="'+link_name+'">\n';
%inertial
str = str+strcat('<inertial>\n','<origin xyz="',num2str(origin_xyz),'"\n',...
' rpy="',num2str(origin_rpy),'"/>\n');
%mass
str = str+strcat('<mass value="',num2str(mass),'"/>\n');
%inertia
str = str+strcat('<inertia\n','ixx="',num2str(Ixx),'"\n',' ixy="',num2str(Ixy),'"\n',...
    ' ixz="',num2str(Ixz),'"\n',' iyy="',num2str(Iyy),'"\n',' iyz="',num2str(Iyz),'"\n',...
    ' izz="',num2str(Izz),'"/>\n</inertial>\n');
%Visual
str = str+'<visual>\n';

Geometry_str = strcat('<origin xyz="',num2str(origin_xyz),'"\n',...
    ' rpy="',num2str(origin_rpy),'"/>\n',...
    '<geometry>\n','<box size="',num2str([link_radius link_radius link_length]),'"/>\n'...
    ,'</geometry>\n');
str = str+Geometry_str;


str = str+strcat('<material name="">\n','<color rgba="',num2str(color),'"/>\n',...
'</material>\n');

str = str+'</visual>\n';

%%collsion
str = str+'<collision>\n';
str = str+Geometry_str;

str = str+'</collision>\n';
str = str+'</link>\n';


end