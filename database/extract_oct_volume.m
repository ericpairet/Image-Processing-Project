% Script to convert all .img retinopathy volumes into .mat files

% Some paths
folder = '/Users/ericpairet/Others/VIBOT/1st_semester/Image processing/Image-Processing-Project/database/retinopathy/';
source = 'original_data/';
matlab_destination = 'matlab_data/';
images_destination = 'images_data/';

% Go through all files *.img in the source directory
files = dir( cat( 2, cat( 2, folder, source ), '*.img' ) );
o = size( files );
for f = 1:1:o(1)
    % Save the name of the file f
    img = files( f, 1 ).name;
    disp( cat( 2, 'Extracting 2D images from ', img ) )
    
    % Size of the 3D image (128 images of 512 x 1024)
    X = 512;
    Y = 128;
    Z = 1024;

    % Initialize variable to store bunch of 2D images
    oct_volume = uint8( zeros( X, Z, Y ) );

    % Open file
    iname = cat( 2, cat( 2, folder, source ), img );
    fin = fopen( iname, 'r' );

    % Extract 2D images from the 3D raw data
    try
        for i=1:Y
            I = fread( fin, [X,Z], 'ubit8=>uint8' );
            oct_volume( :, :, i ) = I;
        end
    catch
        fprintf( 2, cat( 2, cat( 2, 'Error extracting ', img ), '\n' ) );
        fclose( fin );
        continue
    end
    
    % Save the images as a matlab variable
    save( cat( 2, cat( 2, folder, matlab_destination ), strtok( img, '.' ) ), 'oct_volume' )

    % Close file
    fclose( fin );
end
disp(' ')