1;

function b = addnoise(img)

    % set our variables
    p3 = 0.05;          %    5 percent threshold
    b = img;
    sizeA = size(img);
    x = rand(sizeA);
    
    % make all values that are 0.025 zero
    d = find(x < p3/2);
    b(d) = 0;           %    Minimum value
    
    % make all values that are 0.025 - 0.05 one
    d = find(x >= p3/2 & x < p3);
    b(d) = 1;           %    Maximum (saturated) value

endfunction;

function createNoisyImages(name)

    infolder = strcat("/cygdrive/c/dev/af_paper/images/",name,"/resized/");
    outfolder = strcat("/cygdrive/c/dev/af_paper/images/",name,"/noise/");
    files = dir(infolder);

	for j = 3:length(files)

        % read in the file
	    infilename = strcat(infolder,files(j).name);
	    img = imread(infilename);

        % add noise to the image
        img2 = addnoise(img);

        % write out file
        outfilename = strcat(outfolder,files(j).name);
        imwrite(img2,outfilename);
        
    end;

endfunction;

createNoisyImages('book');
createNoisyImages('playing_card');
createNoisyImages('remote');
createNoisyImages('business_card');

