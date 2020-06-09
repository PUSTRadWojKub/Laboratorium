clear;

T = 500;
Tp = 0.5;
opoznienie = 4;

y1(1:opoznienie) = 0;
y2(1:opoznienie) = 0;
y3(1:opoznienie) = 0;

odpSkok = load('odpSkok_v1.mat');

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


nu = 4;
ny = 3;

D = length(s_11);
N = 25;
Nu = 10;

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

x = [-85.492891781738650,8.466419160078384,8.717574079150893,-3.208515788465103,-9.048500699139900,-0.261124146022409,4.325324526121760];

% p = [0.5 0.5 0.5];
p = [x(1) x(2) x(3)];

% l = [4 4 4 4];
l = [x(4) x(5) x(6) x(7)];

lambda = cell(nu,nu);
for i = 1 : Nu
    for j = 1 : Nu
        if i == j
            lambda{i,j} = [l(1) 0 0 0; 0 l(2) 0 0; 0 0 l(3) 0; 0 0 0 l(4)];
        else
            lambda{i,j} = zeros(nu);
        end
    end
end

psi = cell(ny,ny);
for i = 1 : N
    for j = 1 : N
        if i == j
            psi{i,j} = [p(1) 0 0; 0 p(2) 0; 0 0 p(3)];
        else
            psi{i,j} = zeros(ny);
        end
    end
end

lambda = cell2mat(lambda);
psi = cell2mat(psi);

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

yzad1(1:200) = 0;
yzad2(1:200) = 0;
yzad3(1:200) = 0;
yzad1(201:400) = 3;
yzad2(201:400) = 5;
yzad3(201:400) = 0.5;
yzad1(401:600) = 1;
yzad2(401:600) = 0.5;
yzad3(401:600) = 5;
yzad1(601:900) = 6;
yzad2(601:900) = 2;
yzad3(601:900) = 10;
yzad1(901:T/Tp) = 0.5;
yzad2(901:T/Tp) = 8;
yzad3(901:T/Tp) = 3;
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
    
    u1(k) = U(1,1)+duk(1);
    u2(k) = U(1,2)+duk(2);
    u3(k) = U(1,3)+duk(3);
    u4(k) = U(1,4)+duk(4);
    
    U = [[u1(k), u2(k), u3(k), u4(k)]; U];

    
    dUp = [duk; dUp];
    dUp = dUp(1 : 4*(D-1));
  
    Yplot = [Yplot; [y1(k),y2(k),y3(k)]];
    Uplot = [Uplot; [u1(k), u2(k), u3(k), u4(k)]];
        
end
e

figure;
subplot(4,2,1);
stairs(Uplot(:,1));
ylabel('$u_\mathrm{1}(k)$','interpreter','latex');
grid on;
subplot(4,2,2);
plot(yzad1);
hold on;
plot(Yplot(:,1));
ylabel('$y_\mathrm{1}(k)$, $y_\mathrm{1}^\mathrm{zad}(k)$','interpreter','latex');
grid on;

subplot(4,2,3);
stairs(Uplot(:,2));
ylabel('$u_\mathrm{2}(k)$','interpreter','latex');
grid on;
subplot(4,2,4);
plot(yzad2);
hold on;
plot(Yplot(:,2));
ylabel('$y_\mathrm{2}(k)$, $y_\mathrm{2}^\mathrm{zad}(k)$','interpreter','latex');
grid on;

subplot(4,2,5);
stairs(Uplot(:,3));
ylabel('$u_\mathrm{3}(k)$','interpreter','latex');
grid on;
subplot(4,2,6);
plot(yzad3);
hold on;
plot(Yplot(:,3));
xlabel('$k$','interpreter','latex');
ylabel('$y_\mathrm{3}(k)$, $y_\mathrm{3}^\mathrm{zad}(k)$','interpreter','latex');
grid on;

subplot(4,2,7);
stairs(Uplot(:,4));
xlabel('$k$','interpreter','latex');
ylabel('$u_\mathrm{4}(k)$','interpreter','latex');
grid on;

% print('..\proj_sprawozdanie\rysunki\zad6_DMC_full','-dpdf');