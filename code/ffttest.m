1;

function values = dotest(name,boxsize,noise)

    if( noise == 1 )
	    folder = strcat("/cygdrive/c/dev/af_paper/images/",name,"/noise/");
	else
	    folder = strcat("/cygdrive/c/dev/af_paper/images/",name,"/resized/");
	endif;
	files = dir(folder);
    
    %values = zeros(length(files)-2);
    for j = 3:3 %length(files)
    
        filename = strcat(folder,files(j).name);
	    img = imread(filename);
	    width = imfinfo(filename).Width;
	    height = imfinfo(filename).Height;

	    xstart = floor((width/2)-(boxsize/2));
	    ystart = floor((height/2)-(boxsize/2));
        
        tic();

        line1 = double(img(xstart:xstart+boxsize-1,ystart+boxsize*0,:));
        line2 = double(img(xstart:xstart+boxsize-1,ystart+boxsize*1,:));
		line3 = double(img(xstart:xstart+boxsize-1,ystart+boxsize*2,:));
		line4 = double(img(xstart:xstart+boxsize-1,ystart+boxsize*3,:));
	
	    lines = cat(1,line1,line2);
        lines = cat(1,lines,line3);
        lines = cat(1,lines,line4);
	
        data = double(zeros(length(lines),1));
	    
        printf("doing summation on this many points ...\n");
        
        for i = 1:length(lines)
		    val = lines(i,1) + lines(i,2) + lines(i,3);
		    data(i) = val;
		end
        
        values = abs( fft( data ) )(2:length(data)/2);
        
        %values = answer;
        
    end
    
endfunction

fftvalues = dotest('book',128,0);

csvwrite('test.csv',fftvalues);



%plot(fftvalues);

%fid = fopen ('test.csv', "w");

%for i = 1:32

%    for j = 1:255
    
%        line = strcat(sprintf("%f",fftvalues(j)),",");
%        fputs(fid,line);
    
%    end;

%end;

%fclose(fid);