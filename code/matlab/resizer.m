% Script for resize all images in one folder
% Used for reducing the size of the joint paper

clear;
clc;

path_base = '/Users/ericpairet/Desktop/x/';

% Go through all volumes *.mat in the folder
files = dir( strcat( path_base , '*.jpg' ) );
o = size( files );
for f = 1:1:o(1)

    % Save the name of the file f
    image_name = files( f , 1 ).name;
    fprintf( 2 , cat( 2 , 'Processing image ', cat( 2 , image_name , '...\n' ) ) );

    % Get image
    noisy = ( imread( strcat( path_base, image_name ) ) );

    % Resize image
    X = imresize( noisy , [200 200]);  

    % Save image
    imwrite( uint8( X ) , strcat(path_base,'_small/',image_name ) , 'jpg' );
    
end

display('DONE!');