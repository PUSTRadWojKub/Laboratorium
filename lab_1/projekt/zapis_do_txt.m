
% k=1:1:170;
% A=[k; s];
% plik0=fopen('s.txt','w');
% fprintf(plik0, '%f  %f\n', A); 
% fclose(plik0);



kkonc=400;

% k=1:1:kkonc;
% A=[k; Y_zad];
% plik1=fopen('yzad.txt','w');
% fprintf(plik1, '%f  %f\n', A); 
% fclose(plik1);


k=1:1:kkonc;
B=[k; Y];
plik2=fopen('p1_y.txt','w');
fprintf(plik2, '%f  %f\n', B); 
fclose(plik2);


k=1:1:kkonc;
C=[k; U_cale];
plik3=fopen('p1_u.txt','w');
fprintf(plik3, '%f  %f\n', C); 
fclose(plik3);