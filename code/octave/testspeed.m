1;

function sums = getsums1d(name,boxsize,noise)

	if( noise == 1 )
	    folder = strcat("/cygdrive/c/dev/af_paper/images/",name,"/noise/");
	else
	    folder = strcat("/cygdrive/c/dev/af_paper/images/",name,"/resized/");
	endif;
	files = dir(folder);

    printf("Allocating space ...\n");
    sums = zeros(length(files),1);
	printf("Performing calculation ...\n");

	for j = 3:length(files)

	    filename = strcat(folder,files(j).name);
	    img = imread(filename);
	    width = imfinfo(filename).Width;
	    height = imfinfo(filename).Height;

	    xstart = floor((width/2)-(boxsize/2));
	    ystart = floor((height/2)-(boxsize/2));

        tic();
        
        %workingimg = zeros(boxsize,boxsize);
        workingimg = double(img(xstart:xstart+boxsize-1,xstart:xstart+boxsize-1,1) + img(xstart:xstart+boxsize-1,xstart:xstart+boxsize-1,2) + img(xstart:xstart+boxsize-1,xstart:xstart+boxsize-1,3));

	    total = 0;
	    for y = 1:boxsize
		    for x = 3:boxsize
            
                total = total + abs( workingimg(x,y) - workingimg(x-2,y) );
                
		    end
	    end

        %y = boxsize;
        %x = boxsize-3;
        %total = 0;
        %do
        %    do
        %        total = total + abs( workingimg(x,y) - workingimg(x+2,y) );
        %        x = x - 1;
        %    until ( x == 0 )
        %    y = y - 1;
        %    x = boxsize-3;
        %until ( y == 0 )

        totaltime = toc();
        
        %totaltime = endtime-starttime;
        
        printf("1D Difference took %f seconds.\n",totaltime);

        sums(j-2) = total;

        %printf('%i/%i = %f\n',j-2,length(files)-2,total);
		printf(".");
		fflush(stdout);

	end
	
	printf("\n");
	
endfunction

function sums = getsums2d(name,boxsize,noise)

	if( noise == 1 )
	    folder = strcat("/cygdrive/c/dev/af_paper/images/",name,"/noise/");
	else
	    folder = strcat("/cygdrive/c/dev/af_paper/images/",name,"/resized/");
	endif;
	files = dir(folder);

    printf("Allocating space ...\n");
    sums = zeros(length(files),1);
	printf("Performing calculation ...\n");

	for j = 3:length(files)

	    filename = strcat(folder,files(j).name);
	    img = imread(filename);
	    width = imfinfo(filename).Width;
	    height = imfinfo(filename).Height;

	    xstart = floor((width/2)-(boxsize/2));
	    ystart = floor((height/2)-(boxsize/2));

        tic();

        workingimg = double(img(xstart:xstart+boxsize-1,xstart:xstart+boxsize-1,1) + img(xstart:xstart+boxsize-1,xstart:xstart+boxsize-1,2) + img(xstart:xstart+boxsize-1,xstart:xstart+boxsize-1,3));

	    total = 0;
	    for y = 3:boxsize
		    for x = 3:boxsize
		        %xval1 = (double(img(x+1,y,1)) * .33) + (double(img(x+1,y,1)) * .33) + (double(img(x+1,y,1)) * .33);
		        %xval2 = (double(img(x-1,y,1)) * .33) + (double(img(x-1,y,1)) * .33) + (double(img(x-1,y,1)) * .33);
		  
		        %yval1 = (double(img(x,y+1,1)) * .33) + (double(img(x,y+1,1)) * .33) + (double(img(x,y+1,1)) * .33);
		        %yval2 = (double(img(x,y-1,1)) * .33) + (double(img(x,y-1,1)) * .33) + (double(img(x,y-1,1)) * .33);
		  
		        %xdiff = abs(xval1-xval2);
				%ydiff = abs(yval1-yval2);
				
		        %total = total + sqrt(xdiff^2 + ydiff^2);
				
                total = total + ( workingimg(x,y) - workingimg(x-2,y) )^2 + ( workingimg(x,y) - workingimg(x,y-2) )^2;
                
		    end
	    end

        totaltime = toc();
        
        %totaltime = endtime-starttime;
        
        printf("1D Difference took %f seconds.\n",totaltime);

        sums(j-2) = total;

        %printf('%i/%i = %f\n',j-2,length(files)-2,total);
		printf(".");
		fflush(stdout);

	end
	
	printf("\n");
	
endfunction

function sums = getsums1dfft(name,boxsize,noise)

	if( noise == 1 )
	    folder = strcat("/cygdrive/c/dev/af_paper/images/",name,"/noise/");
	else
	    folder = strcat("/cygdrive/c/dev/af_paper/images/",name,"/resized/");
	endif;
	files = dir(folder);

    printf("Allocating space ...\n");
    sums = zeros(length(files),1);
	printf("Performing calculation ...\n");

	for j = 3:length(files)

	    filename = strcat(folder,files(j).name);
	    img = imread(filename);
	    width = imfinfo(filename).Width;
	    height = imfinfo(filename).Height;

	    xstart = floor((width/2)-(boxsize/2));
	    ystart = floor((height/2)-(boxsize/2));

        tic();

        line1 = img(xstart:xstart+boxsize,ystart+boxsize*0,:);
        line2 = img(xstart:xstart+boxsize,ystart+boxsize*1,:);
		line3 = img(xstart:xstart+boxsize,ystart+boxsize*2,:);
		line4 = img(xstart:xstart+boxsize,ystart+boxsize*3,:);
	
	    lines = [line1,line2,line3,line4];
	
        data = zeros(boxsize*4,1);
	    
        printf("The size of data is ...\n");
        size(data)
        
        for i = 1:length(lines)
		    val = lines(i,1) + lines(i,2) + lines(i,3);
		    data(i) = val;
		end
	
        printf("... now the size of data is ...\n");
        size(data)
    
        printf("The length of data is: %i, the length of the fft of data is: %i\n",length(data),length(abs(fft(data))))
        printf("The DC value is: %f, the half value is %f\n", abs(fft(data))(1),abs(fft(data))(length(data)/2));
    
        energy = sum( abs( fft( data(2:length(data)/2) ) ) );

        totaltime = toc();
        
        %totaltime = endtime-starttime;
        
        printf("1D Difference took %f seconds.\n",totaltime);

        sums(j-2) = energy;

        %printf('%i/%i = %f\n',j-2,length(files)-2,energy);
        printf(".");
		fflush(stdout);

	end
	
	printf("\n");
	
endfunction

function sums = getsums2dfft(name,boxsize,noise)

    if( noise == 1 )
	    folder = strcat("/cygdrive/c/dev/af_paper/images/",name,"/noise/");
	else
	    folder = strcat("/cygdrive/c/dev/af_paper/images/",name,"/resized/");
	endif;
	files = dir(folder);

    printf("Allocating space ...\n");
    sums = zeros(length(files),1);
	printf("Performing calculation ...\n");

	for j = 3:length(files)

	    filename = strcat(folder,files(j).name);
	    img = imread(filename);
	    width = imfinfo(filename).Width;
	    height = imfinfo(filename).Height;

	    xstart = floor((width/2)-(boxsize/2));
	    ystart = floor((height/2)-(boxsize/2));

        tic();

        smallimg = img(xstart:xstart+boxsize,ystart:ystart+boxsize,1:3);
	
	    for y = 1:boxsize
		    for x = 1:boxsize
		        %val = (double(smallimg(x,y,1)) * .33) + (double(smallimg(x,y,2)) * .33) + (double(smallimg(x,y,3)) * .33);
		        %data(x,y) = val;
                
                data(x,y) = smallimg(x,y,1) + smallimg(x,y,2) + smallimg(x,y,3);
                
		    end
		end
	
        energy = sum(sum(abs(fft(data( 2:boxsize/2, 2:boxsize/2 )))));

        sums(j-2) = energy;

        totaltime = toc();
        
        %totaltime = endtime-starttime;
        
        printf("1D Difference took %f seconds.\n",totaltime);

        %printf('%i/%i = %f\n',j-2,length(files)-2,energy);
        printf(".");
		fflush(stdout);

	end
	
	printf("\n");
	
endfunction

function calculate(name,noise)

    if( noise == 1)
	    printf(strcat("Procing Noisy Image Set '",name,"'\n"));
	else
        printf(strcat("Procing Image Set '",name,"'\n"));
    endif;
    
    %printf("Calculating focus values using 1D Difference method for a 128x128 box ...\n");
    %sums1d32 = getsums1d(name,128,noise);

    %printf("Calculating focus values using 2D Difference method for a 128x128 box ...\n");
	%sums2d32 = getsums2d(name,128,noise);

    printf("Calculating focus values using 1D FFT method for a 128x128 box ...\n");
	sums1dfft32 = getsums1dfft(name,128,noise);

    %printf("Calculating focus values using 2D FFT method for a 128x128 box ...\n");
	%sums2dfft32 = getsums2dfft(name,128,noise);

endfunction;

calculate("book",0);