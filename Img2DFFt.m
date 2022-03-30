function Img2DFFt(img,res)

     [M,N]=size(img);
    
     M=2^nextpow2(M);
     N=2^nextpow2(N);

     fx=GetFreqVec(N,res);
     fy=GetFreqVec(M,res);

     mask= isnan(img);
     img(mask)=0;

     
     H_tilde= fftshift(fft2(img,M,N));
     A = N*res*M*res;
     imgfp = (A/(M*N)^2)*abs(H_tilde).^2;   
%      imgfp= 10*log(imgfp);


      imagesc(fx,fy,imgfp)
      colormap('turbo')
      colorbar
      xlabel('Fq_x')
      ylabel('Fq_y')
      title('Power Spectrum')
%      figure(3)
%        compass(imgfp)

end