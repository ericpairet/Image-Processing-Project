% Script for converting b/w images to colormaped
% Useful for improving visualization

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
    noisy = double( imread( strcat( path_base, image_name ) ) );
    noisy_image = noisy(:,:,1);
    
    % Generate image
    h=imagesc(noisy_image,[0 255]);
    colormap jet
    set(gca,'visible','off')
    axis image;
    iptsetpref('ImshowBorder','tight');
    set(gca,'position',[0 0 1 1],'units','pix');
    pause(2);

    % Get image
    X = getimage(h);
    imshow(X,[])
    
    % Save image
    imwrite( uint8( X ) , jet , strcat(path_base,'color_',image_name ) , 'jpg' );
    
end

display('DONE!');