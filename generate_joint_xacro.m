
%generaes joint
function str = generate_joint_xacro(name,type,Pi_i_1,Ri_i_1,parent,child,axis,limits)

origin_xyz = [Pi_i_1'];
origin_rpy = fliplr(rotm2eul(Ri_i_1));

%name
str = strcat('<joint name="',name, '" type="',type,'">\n');
%orifing
str = str+strcat('<origin xyz="',num2str(origin_xyz),'"\n',...
' rpy="',num2str(origin_rpy),'"/>\n');
%parent/child
str = str+strcat('<parent link="',parent,'"/>\n','<child link="',child,'"/>\n');
%axis
str = str+strcat('<axis xyz="',num2str(axis),'"/>\n');
%limits
str = str+strcat('<limit lower="',num2str(limits(1)),'"\n','upper ="',num2str(limits(2)),'"\n',...
    'effort ="',num2str(limits(3)),'"\n','velocity ="',num2str(limits(4)),'"/>\n');
str = str+'</joint>\n';

end