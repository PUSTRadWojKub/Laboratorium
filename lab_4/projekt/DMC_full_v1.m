clear;

T = 300;
Tp = 0.5;
opoznienie = 4;

% u1(1:T/Tp) = 0;
% u2(1:T/Tp) = 0;
% u3(1:T/Tp) = 0;
% u4(1:T/Tp) = 0;

% y1(1:T/Tp) = 0;
% y2(1:T/Tp) = 0;
% y3(1:T/Tp) = 0;

y1(1:opoznienie) = 0;
y2(1:opoznienie) = 0;
y3(1:opoznienie) = 0;

odpSkok = load('odpSkok_v1.mat');
% odpSkok = load('odpSkokAprok');

S = [];

s_11 = odpSkok.s11(1:150);
s_21 = odpSkok.s12(1:150);
s_31 = odpSkok.s31(1:150);
s_12 = odpSkok.s12(1:150);
s_22 = odpSkok.s22(1:150);
s_32 = odpSkok.s32(1:150);
s_13 = odpSkok.s13(1:150);
s_23 = odpSkok.s23(1:150);
s_33 = odpSkok.s33(1:150);
s_14 = odpSkok.s14(1:150);
s_24 = odpSkok.s24(1:150);
s_34 = odpSkok.s34(1:150);


D = length(s_11);
N = 20;
Nu = 8;

for i = 1 : D
    S(1,1,i) = s_11(i);
    S(1,2,i) = s_12(i);
    S(1,3,i) = s_13(i);
    S(1,4,i) = s_14(i);
    S(2,1,i) = s_21(i);
    S(2,2,i) = s_22(i);
    S(2,3,i) = s_23(i);
    S(2,4,i) = s_24(i);
    S(3,1,i) = s_31(i);
    S(3,2,i) = s_32(i);
    S(3,3,i) = s_33(i);
    S(3,4,i) = s_34(i);
end



M = cell(N,Nu);
for i=1:N
    for j=1:Nu
        if (i>=j)
            M{i,j}=S(:,:,i-j+1);
        else
            M{i,j} = [0 0 0 0; 0 0 0 0; 0 0 0 0];
        end
    end
end

MP = cell(N,(D-1));
for i=1:N
    for j=1:(D-1)
        if i+j<=D
            MP{i,j}=S(:,:,i+j)-S(:,:,j);
        else
            if j <= D
                MP{i,j}=S(:,:,D)-S(:,:,j);
            else
                MP{i,j}=S(:,:,D)-S(:,:,D-1);
            end
        end
    end
end

% [-1.763608508984147,1.057212562561531,-6.745078568032117,2.602764972787554,0.836019367467205,-1.142572015654686,-7.081704299044541]
% x = [2.004772235800591e+02,65.361398686084290,-33.915426416600420,5.930139941157276,-4.761515964590753,-2.474090598864295e+02,0.306555758792898]

psi1 = 1;
psi2 = 1;
psi3 = 1;
p = [2.004772235800591e+02,65.361398686084290,-33.915426416600420];
p=[1 1 1];
p=p*1;

lambda1 = 5;
lambda2 = 5;
lambda3 = 5;
lambda4 = 5;
l = [5.930139941157276,-4.761515964590753,-2.474090598864295e+02,0.306555758792898];
l=[1 1 1 1];
l=l*10;

lambda = cell(4,4);
for i = 1 : 4
    for j = 1 : 4
        if i == j
            lambda{i,j} = eye(Nu)*l(i);
        else
            lambda{i,j} = zeros(Nu);
        end
    end
end

psi = cell(3,3);
for i = 1 : 3
    for j = 1 : 3
        if i == j
            psi{i,j} = eye(N)*p(i);
        else
            psi{i,j} = zeros(N);
        end
    end
end

lambda = cell2mat(lambda);
psi = cell2mat(psi);
% lambda = eye(Nu*4*4)*5;
% psi = eye(N*3*3)*1;
% 
% 
Mt = M';

M = cell2mat(M);
MP = cell2mat(MP);
K = (M'*psi*M+lambda)^(-1)*M'*psi;
K1 = K(1:4,:);

Yplot = [];
Uplot = [];



duk = 0;
dUp = zeros((D-1)*4,1);
Yk = [];

% yzad = [3 5 0.5];

yzad1(1:49) = 0;
yzad1(50:149) = 3;
yzad1(150:T/Tp) = -1;

yzad2(1:49) = 0;
yzad2(50:249) = 5;
yzad2(250:T/Tp) = 1;

yzad3(1:49) = 0;
yzad3(50:349) = 0.5;
yzad3(350:T/Tp) = 6;

Yzad2 = [];

Yplot = [];
Uplot = [];

U = [0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0];

u1 = U(:,1);
u2 = U(:,2);
u3 = U(:,3);
u4 = U(:,4);
e = 0;

dUp = zeros((D-1)*4,1);

for k = opoznienie + 1 : T/Tp
    [y1(k),y2(k),y3(k)]=symulacja_obiektu3(u1(k-1),u1(k-2),u1(k-3),u1(k-4),...
                                        u2(k-1),u2(k-2),u2(k-3),u2(k-4),...
                                        u3(k-1),u3(k-2),u3(k-3),u3(k-4),...
                                        u4(k-1),u4(k-2),u4(k-3),u4(k-4),...
                                        y1(k-1),y1(k-2),y1(k-3),y1(k-4),...
                                        y2(k-1),y2(k-2),y2(k-3),y2(k-4),...
                                        y3(k-1),y3(k-2),y3(k-3),y3(k-4));
    
    Yzad = [];
    for i = 1 : N
        Yzad = [Yzad; [yzad1(k) yzad2(k) yzad3(k)]'];
    end
                                    
    e = e + (Yzad(1)-y1(k))^2 + (Yzad(2)-y2(k))^2 + (Yzad(3)-y3(k))^2;  
    
    Yk = [];
    for i = 1 : N
        Yk = [Yk; [y1(k) y2(k) y3(k)]'];
    end

    dY0 = MP * dUp;
    Y0 = Yk + dY0;
    dU = K*(Yzad - Y0);
    duk = dU(1:4);
    
    for j = 1 : 4
        for i =(D-1)*4 : -1 : 2
            dUp(i) = dUp(i-1);
        end
    end

    dUp(1) = duk(1);
    dUp(2) = duk(2);
    dUp(3) = duk(3);
    dUp(4) = duk(4);
    
    u1(k) = U(1,1)+duk(1);
    u2(k) = U(1,2)+duk(2);
    u3(k) = U(1,3)+duk(3);
    u4(k) = U(1,4)+duk(4);
    
    U = [[u1(k), u2(k), u3(k), u4(k)]; U];
%     U = U(1 : 4*N,:);
    
%     u1 = U(:,1);
%     u2 = U(:,2);
%     u3 = U(:,3);
%     u4 = U(:,4);
    
    dUp = [duk; dUp];
    dUp = dUp(1 : 4*(D-1));
  
    Yplot = [Yplot; [y1(k),y2(k),y3(k)]]; %subplot(2,1,1); plot(Yplot);                   drawnow
    Uplot = [Uplot; [u1(k), u2(k), u3(k), u4(k)]];     %subplot(2,1,2); stairs(Uplot);  drawnow
        
end
e
figure;
subplot(2,1,1); 
plot(Yplot);
str=['D=',num2str(D),', N=',num2str(N), ', Nu=',num2str(Nu), ', \lambda=[',num2str(l(1)),' ',num2str(l(2)),' ',num2str(l(3)),' ',num2str(l(4)),']'];
title(str);
ylabel('$y, y^\mathrm{zad}$','interpreter','latex');
xlabel('$k$','interpreter','latex');
grid on;
hold on;
plot(yzad1);
plot(yzad2);
plot(yzad3);
legend('$y_\mathrm{1}(k)$','$y_\mathrm{2}(k)$','$y_\mathrm{3}(k)$','$y_\mathrm{1}^\mathrm{zad}(k)$','$y_\mathrm{2}^\mathrm{zad}(k)$','$y_\mathrm{3}^\mathrm{zad}(k)$','interpreter','latex');
subplot(2,1,2); 
stairs(Uplot);
ylabel('$u$','interpreter','latex');
xlabel('$k$','interpreter','latex');
legend('$u_\mathrm{1}(k)$','$u_\mathrm{2}(k)$','$u_\mathrm{3}(k)$','$u_\mathrm{4}(k)$','interpreter','latex');
grid on;
% matlab2tikz('..\proj_sprawozdanie\rysunki\zad3_DMC4.tex', 'showInfo', false)


