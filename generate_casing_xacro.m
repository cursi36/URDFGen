
%generaes casing for joint. It's fame same as joint's
function str = generate_casing_xacro(name,radius,joint_type)
link_name = name;

link_length = 2*radius;
link_radius = radius;

mass = 0;
Ixx = 1/12*mass*link_length^2+1/4*mass*link_radius^2;    Ixy = 0;    Ixz = 0;
Iyy = 1/12*mass*link_length^2+1/4*mass*link_radius^2;    Iyz = 0;    
Izz = 1/2*mass*link_radius^2; 

origin_xyz = [0 0 0];
origin_rpy = [0 0 0];

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

if joint_type == "revolute"
Geometry_str = strcat('<origin xyz="',num2str(origin_xyz),'"\n',...
    ' rpy="',num2str(origin_rpy),'"/>\n',...
    '<geometry>\n','<cylinder length="',num2str(link_length),'"',...
    ' radius="',num2str(link_radius),'"/>\n'...
    ,'</geometry>\n');
else
    Geometry_str = strcat('<origin xyz="',num2str(origin_xyz),'"\n',...
    ' rpy="',num2str(origin_rpy),'"/>\n',...
    '<geometry>\n','<box size="',num2str([radius radius 2*radius]),'"/>\n'...
    ,'</geometry>\n');
end
str = str+Geometry_str;


str = str+strcat('<material name="">\n','<color rgba="',+num2str([1 0 0 1]),'"/>\n',...
'</material>\n');

str = str+'</visual>\n';

%%collsion
str = str+'<collision>\n';
str = str+Geometry_str;

str = str+'</collision>\n';
str = str+'</link>\n';

end