1;

function linedata = getaline()
        
        folder = strcat("/cygdrive/c/dev/af_paper/images/remote/resized/");
        
        filename = strcat(folder,"16.bmp");
	    img = imread(filename);
	    width = imfinfo(filename).Width;
	    height = imfinfo(filename).Height;

	    xstart = floor((width/2));
	    ystart = floor((height/2));

        line = double(img(0:width,floor((height/2)),1)) + double(img(0:width,floor((height/2)),2)) + double(img(0:width,floor((height/2)),3));
        
        linedata = line
        
endfunction;

getaline();
        