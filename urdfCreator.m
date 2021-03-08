classdef urdfCreator
    
    properties
        
        m_DH_tab = [];
        m_types = [];
        m_name = [];
        m_limits = [];
        
    end
    
    
    methods
        
        %limits = min max, effort, vel
        function obj = urdfCreator(Robot_name,DH_tab,joint_types,joint_limits)
            
            obj.m_DH_tab = DH_tab;
            obj.m_types = joint_types;
            obj.m_name = Robot_name;
            obj.m_limits = joint_limits;
            
        end
        
        function str = generateURDF(obj,filename,link_radius)
            fileID = fopen(filename,'w');
            
            fprintf(fileID, '<?xml version="1.0"?>\n');
            
            str = strcat('<robot name="',obj.m_name,'" xmlns:xacro="http://www.ros.org/wiki/xacro">\n');
            fprintf(fileID,str);
            
            color = [0.7 0.7 0.7 1];
            link_mass = 1;
            case_rad = link_radius;
            
            %rotation to align z of link to x of new joint
            R_link = [0 0 1;
                0 -1 0;
                1 0 0];
            
            %base_link
            P = zeros(3,1);
            R = eye(3,3);
            link_size = 1e-02;
            str = generate_base_link_xacro("link_0",P,R,link_size,color);
            
            DH_tab = obj.m_DH_tab;
            types = obj.m_types;
            
            joint_name = "joint_";
            link_name = "link_";
            case_name = "casing_";
            fixed_name = "fixed_";
            limits = obj.m_limits;
            
            Pose = [R,P;zeros(1,3) 1];
            
            parent = "link_0";
            
            for i = 1:size(DH_tab,1)
                
                if types(i) == 'r'
                    
                    j_type = "revolute";
                    
                else
                    
                    j_type = "prismatic";
                end
                
                j_name = joint_name+num2str(i-1);
                %                 l_name = link_name+num2str(i-1);
                c_name = case_name+num2str(i-1);
                f_name = fixed_name+num2str(i-1);
                
                %                 parent = l_name;
                child = c_name;
                
                %%joint i-1
                str = str+generate_joint_xacro(j_name,j_type,Pose(1:3,4),Pose(1:3,1:3),parent,child,...
                    [0 0 1],limits(i,:) );
                
                % %casing for joint_i-1
                str = str+generate_casing_xacro(c_name,case_rad,j_type);
                
                %link i
                d = DH_tab(i,1); theta = DH_tab(i,2); a = DH_tab(i,3); alpha = DH_tab(i,4);
                R_z = [cos(theta) -sin(theta) 0;
                    sin(theta) cos(theta) 0;
                    0 0 1];
                
                child = link_name+num2str(i);
                
                str = str+generate_joint_xacro(f_name,"fixed",zeros(3,1),eye(3),c_name,child,[0 0 1],...
                    [0 0 1e06 1e06]);
                
                Pose_L_fixed = eye(4,4);
                if d > 0
                    
                    str_link = generate_link_d_xacro(child,link_radius,link_mass,[0;0;d],eye(3,3),color);
                end
                    
                if a > 0
                    
                    R = R_z*R_link;
                    str_link = generate_link_a_xacro(child,link_radius,link_mass,R_z*[a;0;0],R,color);
                    
                end
                    
                if d > 0 && a > 0
                    
                    [Pose_L_fixed,str_link,child] = addL_link(child,i,d,a,R_z,R_link,link_radius,link_mass,color);
                    
                end
                
                if d == 0 && a == 0
                    disp("ADDED FICTITIOUS LINK "+num2str(i))
                    
                    R = R_z*R_link;
                    str_link = generate_link_a_xacro(child,link_radius,link_mass,[1e-06;0;0],R,color);
                    
                end
                
                str = str+str_link;
                
                Pose = inv(Pose_L_fixed)*DH_mat(DH_tab(i,:)); %of i wrt i-1
                
                parent = child;
                
                
                
            end
            
            str = str+'</robot>';
            
            fprintf(fileID,str);
            
            fclose(fileID);
            
        end
        
        
        
    end
    
end

function [T_fixed,str,child] = addL_link(link_name,idx,d,a,R_z,R_link,link_radius,link_mass,color)

str = generate_link_d_xacro(link_name,link_radius,link_mass,[0;0;d],eye(3,3),color);

%fixed conn1
T_fixed = [eye(3),[0;0;d];0 0 0 1];

str = str+generate_joint_xacro("fixed_L"+num2str(idx),"fixed",T_fixed(1:3,4),T_fixed(1:3,1:3),link_name,link_name+"_L",[0 0 1],[0 0 1e06 1e06]);


%link11
R = R_z*R_link;
str = str+generate_link_a_xacro(link_name+"_L",link_radius,link_mass,[a;0;0],R,color);

child = link_name+"_L";

end


function T = DH_mat(DH_params)

% T = zeros(4,4);
d = DH_params(1);    theta = DH_params(2);
a = DH_params(3); alpha = DH_params(4);

T(1,1) = cos(theta); T(1,2) = -sin(theta)*cos(alpha);    T(1,3) = sin(theta)*sin(alpha); T(1,4) = a*cos(theta);
T(2,1) = sin(theta);    T(2,2) = cos(theta)*cos(alpha); T(2,3) = -cos(theta)*sin(alpha);    T(2,4) = a*sin(theta);
T(3,1) = 0; T(3,2) = sin(alpha);    T(3,3) = cos(alpha);    T(3,4) = d;
T(4,1:3) = 0;   T(4,4) = 1;
end