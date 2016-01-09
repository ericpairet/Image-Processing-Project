% Script for building up a stack of .tiff images
% Compatible format with the OCT segmentation software

clear;
clc;

path_base = '/Users/ericpairet/Desktop/denoised_jpg/';
outputFileName = 'P741009OS-denoised.tiff';

% Go through all volumes *.mat in the folder
files = dir( strcat( path_base , '*.jpg' ) );
o = size( files );
for f = 1:1:o(1)

    % Save the name of the file f
    image_name = files( f , 1 ).name;
    fprintf( 2 , cat( 2 , 'Processing image ', cat( 2 , image_name , '...\n' ) ) );

    % Get image
    noisy = ( imread( strcat( path_base, image_name ) ) );
    
    % Some transformations if needed
    X = noisy;
    %X = imresize( noisy , [512 200] );
    %X = imrotate( noisy , 90 );
    
    % Save image in stack of .tiff
    imwrite( uint8( X ) , strcat( path_base , outputFileName ) , 'WriteMode' , 'append' ,  'Compression' , 'none' );
    
end

display('DONE!');