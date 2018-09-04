function sc=scale(a,b)
    % get ref image
    image_ref=a;
    if ndims(image_ref)==3
        image_ref=rgb2gray(image_ref);
    end
    image_ref_backup=image_ref;
    if ndims(b)==3
        image_ch=rgb2gray(b);
    else
        image_ch=b;
    end
    image_ch_backup=image_ch;
    tic;
    [image_ref,image_ch]=zeropad(image_ref,image_ch);
   % subplot(1,3,1);
   % imshow(image_ref);
   % subplot(1,3,2);
   % imshow(image_ch);
    % logpol size
    logpol_m=size(image_ref,1);
    logpol_n=size(image_ref,2);

    % FFT and shift them to the center
    fft_ref=fft2(image_ref);
    fft_ref=fftshift(fft_ref);
    fft_ch=fft2(image_ch);
    fft_ch=fftshift(fft_ch);
    %figure,imshow(abs(fft_ref));
    %figure,imshow(abs(fft_ch));
    % Highpass Filtering
    mag_ref=highpass_filter(size(image_ref,1),size(image_ref,2)).*abs(fft_ref);
    mag_ch=highpass_filter(size(image_ch,1),size(image_ch,2)).*abs(fft_ch);

    % Cartesian to Logarithmic Polar Conversion
    center=floor((size(image_ref)+1)/2);
    [logpol_ref,rho,base]=logpol_transform(mag_ref,center,logpol_m,logpol_n,'bilinear','valid');
    center=floor((size(image_ch)+1)/2);
    logpol_ch=logpol_transform(mag_ch,center,logpol_m,logpol_n,'bilinear','valid');

    % Phase Correlation
    fft_logpol_ref=fft2(logpol_ref);
    fft_logpol_ch=fft2(logpol_ch);
    % 2 ways to get the cross power spectrum
    fft_phase=(fft_logpol_ref.*conj(fft_logpol_ch)./(abs(fft_logpol_ref.*fft_logpol_ch)));
    % or like this
    % fft_phase=exp(1i*(angle(fft_logpol_ref)-angle(fft_logpol_ch)));
    phase=real(ifft2(fft_phase));% reserve the real component
    % Get the angle and scaled
    phase_max=max(max(phase));
    % disp(['Phase peak: ',num2str(phase_max)]);
    [peak_x,peak_y]=find(phase==phase_max);
    degrees_per_pixel=360/size(phase,2);
    theta=(peak_y-1)*degrees_per_pixel;
    % disp(['Theta:',num2str(theta)]);
    % disp(abs(theta-theta_ch)/theta);
    scaled_1=rho(peak_x);
    % disp(scaled_1);
    scaled_2=rho(logpol_m+1-peak_x);
    % disp(1/scaled_2);
    if(scaled_1>scaled_2)
        scaled=1/scaled_2;
    else
        scaled=scaled_1;
    end
    disp(['Scaled: ',num2str(scaled)]);
    %subplot(1,4,1);
    %imshow(image_ref);
    %subplot(1,4,2);
    %imshow(image_ch);
    b=imresize(image_ch,scaled);
    %subplot(1,4,3);
    %imshow(b);
    sc=scaled;

