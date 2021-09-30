clear all;
tic
%% Input Image
A = imread('1s.JPG');
B = imread('2s.JPG');
C = imread('3s.JPG');

fringe1 = imread('4.JPG');
fringe2 = imread('5.JPG');
fringe3 = imread('6.JPG');


A=double(rgb2gray(A));
B=double(rgb2gray(B));
C=double(rgb2gray(C));

fringe1=double(rgb2gray(fringe1));
fringe2=double(rgb2gray(fringe2));
fringe3=double(rgb2gray(fringe3));


%%
 ImageA=(A-min(A(:)))/(max(A(:))-min(A(:)));
 [ImageA,rect]=imcrop(ImageA); 


A=imcrop(A,rect);
B=imcrop(B,rect);
C=imcrop(C,rect);


fringe1=imcrop(fringe1,rect);
fringe2=imcrop(fringe2,rect);
fringe3=imcrop(fringe3,rect);


% H = fspecial('gaussian',[15 15],0.5);
% A=imfilter(A,H);
% B=imfilter(B,H);
% C=imfilter(C,H);
% D=imfilter(D,H);
% fringe1=imfilter(fringe1,H);
% fringe2=imfilter(fringe2,H);
% fringe3=imfilter(fringe3,H);
% fringe4=imfilter(fringe4,H);
%%
Object_phase = atan2(double(2*B-A-C),double(sqrt(3)*(A-C)));
Reference_phase = atan2(double(2*fringe2-fringe1-fringe3),double(sqrt(3)*(fringe1-fringe3)));

figure(3);imagesc(Object_phase);   %imagesc(wrapped_phase); %imshow
figure(4);imagesc(Reference_phase);  %imagesc(original_phase);

%%
Reference_phase = single(Reference_phase);
unwrapped_ref = unwrap_phase(Reference_phase); %(sorting by reliability following a noncontinuous path)

Object_phase = single(Object_phase);
unwrapped_obj = unwrap_phase(Object_phase);

% %Least Square Method
figure(6);imagesc(unwrapped_ref);
figure(5);imagesc(unwrapped_obj);
%%
PhaseDifference =unwrapped_obj-unwrapped_ref;%phase difference

d = 250; 
L = 350;
Lp = 300;
T = .336;

H =Lp*T*PhaseDifference./(2*pi*d+unwrapped_ref-(unwrapped_obj*Lp/L));
figure(8);set(gcf,'Name','3D Reconstruction','NumberTitle','off');surf(H);shading interp;
colorbar;
%caxis([-2.5 2.5]);
%%
h=[];

    for x=1:99

            H(:,200)=H(:,550)+H(:,200+x);
    end
 H(:,200) =  H(:,200)/100;
figure(9),plot( H(:,200));

%Htop = mean(H(200:300,200));
%Hdown = mean(H(250:350,200));

%figure(7),plot(H(:,200));

toc