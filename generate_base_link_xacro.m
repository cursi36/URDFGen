%generaes link to offset along x,y
function str = generate_base_link_xacro(name,P,R,link_size,color)
link_name = name;


mass = 1e06;
Ixx = 1e06;    Ixy = 0;    Ixz = 0;
Iyy = 1e06;    Iyz = 0;    
Izz = 1e06; 

origin_xyz = [P'];
origin_rpy = fliplr(rotm2eul(R));

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
    '<geometry>\n','<box size="',num2str([link_size, link_size, link_size]),'"/>\n'...
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