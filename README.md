# URDFGen
Robot URDF generator for Matlab.

## Descrption
URDFGen allows you to easily obtain a URDF file for your robot model, by simply using the difnied DH table and joint types.

## urdfCreator Class
The main file is `urdfCreator.m`: this is a class that takes as input the Robot name, DH table, joint types and limits.

- The DH table is a nj x 4 matrix where the columns are d, theta, a, alpha according to the standard DH convention.

- joint types are defined by a string whose characters are either 'p' for prismatic joint or 'r' for revolute joint.

- joint limits is specified as a nj x 4 matrix. The first two columns are the minimum and maximum joint position limits, the third column are the maximum joint effort and velocity respectively.

## Tests
The folder *tests* contains an example on how to generate your URDF.

- Define your DH table, joint types and limits.
- Initialize urdfCreator object.
- Call urdfCreator.generateURDF(filename,link_radius) to save your URDF in *filename*. The *link*_*radius* assumes that all links are cylindrical with the specified radius. The length is computed from the DH table.

## Contact
We thank you for your interest in the project and for andy comment or information please contact *cursifrancesco@gmail.com*




