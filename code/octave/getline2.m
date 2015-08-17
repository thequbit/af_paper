1;

function linedata = getaline(number)
        
        folder = strcat("/cygdrive/c/dev/af_paper/images/remote/resized/");
        
        filename = strcat(folder,number,".bmp");
	    img = imread(filename);
	    width = imfinfo(filename).Width;
	    height = imfinfo(filename).Height;

	    xstart = floor((width/2));
	    ystart = floor((height/2));

        line = double(img(floor((height/2)),1:width,1)) + double(img(floor((height/2)),1:width,2)) + double(img(floor((height/2)),1:width,3));
        
        linedata = line;
        
endfunction;

linedata00 = getaline("00");
linedata00fft= abs(fft(linedata00)(2:length(linedata00)/2));

csvwrite('linedata00.csv',linedata00);
csvwrite('linedata00fft.csv',linedata00fft);

linedata16 = getaline("16");
linedata16fft = abs(fft(linedata16)(2:length(linedata16)/2));

csvwrite('linedata16.csv',linedata16);
csvwrite('linedata16fft.csv',linedata16fft);