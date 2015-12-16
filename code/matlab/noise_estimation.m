mat_path = '/Users/ericpairet/Others/VIBOT/1st_semester/Image processing/Project/Image-Processing-Project/database/retinopathy/matlab_data/P741009OS.img';
load( mat_path );
original = double( oct_volume( : , : , 1 ) );

% Taking an homogenous patch of 200 x 200
patch_oct = original(313:512,1:200,1);

% Estimate noise
[ mu , sigma ] = normfit( reshape( patch_oct , [] , 1 ) );



function t = testFunction()
    sigma = 20;
    a = ones( 200 , 200 ) * 100;
    a = a + randn( size( a ) ) * sigma;
    
    
    patch_a = a( 1:10 , 1:10 );
    [ mu , sigma ] = normfit( reshape( patch_a , [] , 1 ) ); % returns mu = 98.73 and sigma = 21.17
end
