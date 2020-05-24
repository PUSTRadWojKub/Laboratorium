function e = coeffOptimDMC(x)
T = 500;
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

odpSkok = load('odpSkok.mat');
% odpSkok = load('odpSkokAprok');

S = [];

s_11 = odpSkok.s11(5:150);
s_21 = odpSkok.s12(5:150);
s_31 = odpSkok.s31(5:150);
s_12 = odpSkok.s12(5:150);
s_22 = odpSkok.s22(5:150);
s_32 = odpSkok.s32(5:150);
s_13 = odpSkok.s13(5:150);
s_23 = odpSkok.s23(5:150);
s_33 = odpSkok.s33(5:150);
s_14 = odpSkok.s14(5:150);
s_24 = odpSkok.s24(5:150);
s_34 = odpSkok.s34(5:150);


D = length(s_11);
N = 40;
Nu = 40;

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

psi1 = x(1);
psi2 = x(2);
psi3 = x(3);
p = [psi1 psi2 psi3];

lambda1 = x(4);
lambda2 = x(5);
lambda3 = x(6);
lambda4 = x(7);
l = [lambda1 lambda2 lambda3 lambda4];

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

Yzad = [];
for i = 1 : N
    Yzad = [Yzad; [0 0 0]'];
end

yzad = [1 2 0.5];
Yzad2 = [];
for i = 1 : N
    Yzad2 = [Yzad2; yzad'];
end

Yplot = [];
Uplot = [];

U = [0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0];

u1 = U(:,1);
u2 = U(:,2);
u3 = U(:,3);
u4 = U(:,4);
e = 0;
for k = opoznienie + 1 : T/Tp
    [y1(k),y2(k),y3(k)]=symulacja_obiektu3(u1(k-1),u1(k-2),u1(k-3),u1(k-4),...
                                        u2(k-1),u2(k-2),u2(k-3),u2(k-4),...
                                        u3(k-1),u3(k-2),u3(k-3),u3(k-4),...
                                        u4(k-1),u4(k-2),u4(k-3),u4(k-4),...
                                        y1(k-1),y1(k-2),y1(k-3),y1(k-4),...
                                        y2(k-1),y2(k-2),y2(k-3),y2(k-4),...
                                        y3(k-1),y3(k-2),y3(k-3),y3(k-4));
    
    
    e = e + (yzad(1)-y1(k))^2 + (yzad(2)-y2(k))^2 + (yzad(3)-y3(k))^2;                             
    Yk = [];
    for i = 1 : N
        Yk = [Yk; [y1(k) y2(k) y3(k)]'];
    end
    if k == 100
        Yzad = Yzad2;
    end
    duk = K1*(Yzad - Yk - MP*dUp);
    
    controls = [U(1,1)+duk(1), U(1,2)+duk(2), U(1,3)+duk(3), U(1,4)+duk(4)];
    u1(k) = U(1,1)+duk(1);
    u2(k) = U(1,2)+duk(2);
    u3(k) = U(1,3)+duk(3);
    u4(k) = U(1,4)+duk(4);
    
    U = [controls; U];
%     U = U(1 : 4*N,:);
    
%     u1 = U(:,1);
%     u2 = U(:,2);
%     u3 = U(:,3);
%     u4 = U(:,4);
    
    dUp = [duk; dUp];
    dUp = dUp(1 : 4*(D-1));
  
    Yplot = [Yplot; [y1(k),y2(k),y3(k)]]; %subplot(2,1,1); plot(Yplot);                   drawnow
    Uplot = [Uplot; controls];     %subplot(2,1,2); stairs(Uplot);  drawnow
        
end
end