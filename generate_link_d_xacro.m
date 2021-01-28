
%generaes link to offset along z
function str = generate_link_d_xacro(name,radius,mass,Pi_i_1,Ri_i_1,color)
link_name = name;

link_length = norm(Pi_i_1(3));
link_radius = radius;

Ixx = 1/12*mass*link_length^2+1/4*mass*link_radius^2;    Ixy = 0;    Ixz = 0;
Iyy = 1/12*mass*link_length^2+1/4*mass*link_radius^2;    Iyz = 0;    
Izz = 1/2*mass*link_radius^2; 

origin_xyz = [0 0 Pi_i_1(3)'/2];
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
    '<geometry>\n','<cylinder length="',num2str(link_length),'"',...
    ' radius="',num2str(link_radius),'"/>\n'...
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