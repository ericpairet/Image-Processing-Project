function m = ksvd_manager()
    m.denoiseImage = @denoiseImage;
    m.denoiseMatlabImage = @denoiseMatlabImage;
    m.trySigmas = @trySigmas;
    m.denoiseImagesInFolder = @denoiseImagesInFolder;

    % Include KSVD and OMP code
    addpath('_basis/ksvdbox13')
    addpath('_basis/ompbox10')
end
    
 

% Denoise an .jpg image
function u = denoiseImage( path , sigma )      
    
    % Read image
    original = double( rgb2gray( imread( path ) ) );

    % If 0, input image is noisy. Otherwise, add noise
    if ( sigma == 0 )
        noisy_image = original;
        sigma = estimateNoise( original( 313:512 , 1:200 , 1 ) );
        mode = 0;
    else
        noisy_image = original + randn( size( original ) ) * sigma;
        mode = 1;
    end
    
    % Configure KSVD parameters
    params = setParameters( noisy_image , 8 , 256 , sigma , 40000 );
    
    % Perform KSVD
    [ X , D ] = ksvddenoise( params );
    
    % Show results
    showResults( original , noisy_image , D , X , params , mode );
    
end



% Denoise an image stored as .mat file
function d = denoiseMatlabImage( mat_path , sigma )
    
    % Load package of images as Mat file
    load( mat_path );
    original = double( oct_volume( : , : , 1 ) );
    
    % If 0, input image is noisy. Otherwise, add noise
    if ( sigma == 0 )
        noisy_image = original;
        sigma = estimateNoise( original( 313:512 , 1:200 , 1 ) );
        mode = 0;
    else
        noisy_image = original + randn( size( original ) ) * sigma;
        mode = 1;
    end
    
    % Configure KSVD parameters
    params = setParameters( noisy_image , 32 , 256 , sigma , 40000 );
    
    % Perform KSVD
    [ X , D ] = ksvddenoise( params );
    
    % Evaluate results
    evaluateResults( original , X );
    
    % Show results
    showResults( original , noisy_image , D , X , params , mode );
    
end



% Function to check the level of noise in the .mat images
function x = trySigmas()
    
    % Just for test
    folder = '../../database/retinopathy/matlab_data/'; 
    
    % Clean workspace
    clc;
    clearvars -except folder;
    
    % Go through all volumes *.mat in the folder
    files = dir( cat( 2 , folder , '*.mat' ) );
    o = size( files );
    for f = 1:1:o(1)
        
        % Save the name of the file f
        volume_name = files( f , 1 ).name;
        %fprintf( 2 , cat( 2 , 'Processing volume ', cat( 2 , volume_name , '...\n' ) ) );
        
        % Create folder for the results of this volume
        mkdir( cat( 2 , '../../results/matlab/' , volume_name ) );
        cd( cat( 2 , '../../results/matlab/' , volume_name ) );
        
        % Load package of images as Mat file
        load( cat( 2 , folder , volume_name ) );
        volume_data = double( oct_volume );
        
        % Estimate noise in first image of the volume
        sigma = estimateNoise( volume_data( 313:512 , 1:200 , 1 ) );
        %fprintf('Estimated sigma: %f\n' , sigma );
        
        % Go through all images inside the volume
        for i = 1:1:1
            %fprintf('Image %3i out of %i... \n' , i , size( volume_data , 3 ) );
            
            % Extract image i of the volume
            original = volume_data( : , : , i );

            % Sigma's range
            sigma = 22:2:40;
            
            for s = 1:1:size( sigma , 2 )
                
                fprintf('Denoising with sigma = %2i... \n' , sigma( s ) );
                
                % Configure KSVD parameters
                params = setParameters( original , 8 , 256 , sigma( s ) , 40000 );

                % Perform KSVD
                [ X , D ] = ksvddenoise( params , 0 );

                % Evaluate result
                [mse(i) , psnr(i)] = evaluateResults( original , X );

                % Save images
                dictionary = imresize( showdict( D , [1 1] * params.blocksize , round( sqrt( params.dictsize ) ) , round( sqrt( params.dictsize ) ) , 'lines' , 'highcontrast' ) , 2 , 'nearest' );
                saveImages( original , X , dictionary , sigma( s ) );
            end
            
            clearvars original params X D dictionary
            
        end
        fprintf('\n\n');
        
        % Save volume results
        %saveResults( sigma , mse , psnr )
        
        % Delete some variables
        clearvars -except folder files
        
    end
    
end



% Main function for denoising and storing the results
function x = denoiseImagesInFolder()
    
    % Just for test
    folder = '../../database/retinopathy/matlab_data/'; 
    
    % Clean workspace
    clc;
    clearvars -except folder;
    
    % Go through all volumes *.mat in the folder
    files = dir( cat( 2 , folder , '*.mat' ) );
    o = size( files );
    for f = 1:1:o(1)
        
        % Save the name of the file f
        volume_name = files( f , 1 ).name;
        fprintf( 2 , cat( 2 , 'Processing volume ', cat( 2 , volume_name , '...\n' ) ) );
        
        % Create folder for the results of this volume
        mkdir( cat( 2 , '../../results/matlab/' , volume_name ) );
        cd( cat( 2 , '../../results/matlab/' , volume_name ) );
        
        % Load package of images as Mat file
        load( cat( 2 , folder , volume_name ) );
        volume_data = double( oct_volume );
        
        % Estimate noise in first image of the volume
        sigma = estimateNoise( volume_data( 313:512 , 1:200 , 1 ) );
        %fprintf('Estimated sigma: %f\n' , sigma );
        
        % Go through all images inside the volume
        for i = 1:1:size( volume_data , 3 )
            fprintf('Image %3i out of %i... \n' , i , size( volume_data , 3 ) );
            
            % Extract image i of the volume
            original = volume_data( : , : , i );

            % Configure KSVD parameters
            params = setParameters( original , 8 , 256 , sigma , 40000 );

            % Perform KSVD
            [ X , D ] = ksvddenoise( params , 0 );
            
            % Evaluate result
            [mse(i) , psnr(i)] = evaluateResults( original , X );
            
            % Save images
            dictionary = imresize( showdict( D , [1 1] * params.blocksize , round( sqrt( params.dictsize ) ) , round( sqrt( params.dictsize ) ) , 'lines' , 'highcontrast' ) , 2 , 'nearest' );
            saveImages( original , X , dictionary , i );
            
            clearvars original params X D dictionary
            
        end
        fprintf('\n\n');
        
        % Save volume results
        saveResults( sigma , mse , psnr )
        
        % Delete some variables
        clearvars -except folder files
        
    end
    
end



% ********************************************************************************************* %
% ********************************************************************************************* %
% ********************************************************************************************* %



function params = setParameters( noisy_image , blocksize , dictsize , sigma , trainnum )
    
    % Required parameters
    params.x = noisy_image;
    params.blocksize = blocksize;       % 8                         % higher, better results, but more blurry
    params.dictsize = dictsize;         % 256                       % sqrt(dictsize) is the number of patches of the dictionary
    params.sigma = sigma;
    params.trainnum = trainnum;         % 40000                     % increasing the trainnum improves the result unitl a trainnum limit (trainnum >= dictsize)
    
    % Optional parameters
    params.initdict = 'odct';           % 'odct'                    % there is no big difference between 'odct' and 'data' dictionary                 
    params.stepsize = 1;                % 1                         % incresing the stepsize, the result is worse
    params.internum = 20;               % 10                        % not much difference ?
    params.maxval = 255;                % 1 
    params.memusage = 'high';           % 'normal'
    params.noisemode = 'sigma';         % 'sigma'
    params.gain = 1.15;                 % 1.15                      % decreasing the gain the images is less denoised but better perserves the edges
    params.lambda = 0.1 * 255 / sigma;  % 0.1 * maxval / sigma
    params.maxatoms = 4;                % prod( blocsize ) / 2      % higher, better results
    params.exact = 0;                   % 0                         % not much difference ?
    
end



function sigma = estimateNoise( patch )
    
    [ mu , sigma ] = normfit( reshape( patch , [] , 1 ) );

end



function [mse , psnr] = evaluateResults( original , denoised )

    % Compute MSE
    mse = sum( sum( ( double( original ) - double( denoised ) ) .^ 2) ) / ( size( original , 1 ) * size( original , 2 ) );
    fprintf( 'MSE is: %f \n' , mse );
    
    % Compute PSNR
    psnr = 10 * log10( 255^2 / mse);
    fprintf( 'PSNR is: %f \n' , psnr );

end



function x = saveImages( original , denoised , dictionary , i )

    imwrite( uint8( original ) , cat( 2 , int2str( i ) , '-1_original.jpg' ) ,'jpg' );
    imwrite( uint8( denoised ) , cat( 2 , int2str( i ) , '-2_denoised.jpg' ) ,'jpg');
    imwrite( dictionary , cat( 2 , int2str( i ) , '-3_dictionary.jpg' ) ,'jpg');

end



function s = saveResults( sigma , mse , psnr )

    % Create matrix with the data to save
    data = [1:1:size( mse , 2 ) ; mse ; psnr];
    
    % Create file
    fileID = fopen( 'results.txt' , 'wt' );
    
    % Print estimated sigma
    fprintf( fileID , 'Estimated sigma: %4.2f \n\n' , sigma );
    
    % Print header
    fprintf( fileID , '%3s %6s %6s\n' , 'i' , 'MSE' , 'PSNR' );
    
    % Print data
    fprintf( fileID , '%3i %6.3f %6.3f \n' , data );
    
    % Close file
    fclose( fileID );

end



function s = showResults( original , noisy_image , D , denoised_image , params , mode )
    
    figure;
    
    % Show original image
    if( mode == 1 )
        subplot( 2 , 2 , 1 ); 
        imshow( original / params.maxval );
        title( 'Original image' );
    end
    
    % Show dictionary
    subplot( 2 , 2 , 2 ); 
    dictimg = showdict( D , [1 1] * params.blocksize , round( sqrt( params.dictsize ) ) , round( sqrt( params.dictsize ) ) , 'lines' , 'highcontrast' );
    imshow( imresize( dictimg , 2 , 'nearest' ) );
    title( 'Trained dictionary' );
    
    % Show noisy image
    subplot( 2 , 2 , 3 ); 
    imshow( noisy_image / params.maxval );
    if( mode == 1 )
        title( sprintf( 'Noisy image, PSNR = %.2fdB' , 20 * log10( params.maxval * sqrt( numel( original ) ) / norm( original(:) - noisy_image(:) ) ) ) );
    else
        title( sprintf( 'Noisy image' ) );
    end
        
    % Show denoised image
    subplot( 2 , 2 , 4 ); 
    imshow( denoised_image / params.maxval );
    if( mode == 1 )
        title( sprintf( 'Denoised image, PSNR: %.2fdB' , 20 * log10( params.maxval * sqrt( numel( original ) ) / norm( original(:) - denoised_image(:) ) ) ) );
    else
        title( sprintf( 'Denoised image' ) );
    end
    
end