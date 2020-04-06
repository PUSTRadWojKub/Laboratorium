% Symulacja algorytmu DMC dla procesu z zakloceniami
% 
clear all;

pomiar = 1;      % 0 - brak pomiaru zaklocen, 1 - z pomiarem zaklocen
typ_zak = 1;     % 1 - skok jednostkowy zaklocen, 2 - zaklocenia sinusoidalne
szum = 1;        % 0 - brak szumu, 1 - szum obecny

odp_skokU = load('odp_skokU.mat');
s = odp_skokU.odp_skok;

if (pomiar)
    odp_skokZ = load('odp_skokZ.mat');
    sz = odp_skokZ.odp_skok;
end

%Stan ustalony
Upp = 0; %sygnal wejsciowy sterowania w stanie ustalonym
Zpp = 0; %sygnal wejsciowy zaklocenia w stanie ustalonym
Ypp = 0; %sygnal wyjsciowy w stanie ustalonym


Tp = 0.5; %okres probkowania
T = 300; %czas symulacji
n = T/Tp; %liczba probek
opoznienie = 6; %opoznienie obiektu

%Opoznienie
U(1:n) = Upp;
Z(1:n) = Zpp;
Y(1:opoznienie) = Ypp;
e(1:n) = 0;
dU(1:n) = 0;
dZ(1:n) = 0;

%Horyzonty
D=length(s);
N=10; %20
Nu=1; %1
strD = string(D);
strN = string(N);
strNu = string(Nu);

if (pomiar)
    Dz = length(sz);
    strDz = string(Dz);
end
    
%Wspolczynnik kary za przyrosty sterowania
lambda=1; %1
strL = string(lambda);

err = 0;
    
%Generacja macierzy
M=zeros(N,Nu);
for i=1:N
    for j=1:Nu
        if (i>=j)
            M(i,j)=s(i-j+1);
        end
    end
end
    
MP=zeros(N,D-1);
for i=1:N
    for j=1:D-1
        if i+j<=D
            MP(i,j)=s(i+j)-s(j);
        else
            MP(i,j)=s(D)-s(j);
        end
    end
end

if (pomiar)
    
    MZ = zeros(N,Dz);
    
    for i = 1:N
        if i <= length(sz)
            MZ(i,1) = sz(i);
        else
            MZ(i,1) = sz(Dz);
        end
    end

    for i = 1:N
           for j = 1:Dz-1
              if i+j <= Dz
                 MZ(i,j+1) = sz(i+j)-sz(j);
              else
                 MZ(i,j+1) = sz(Dz)-sz(j);
              end
           end
    end
end
    
I=eye(Nu);
K=((M'*M+lambda*I)^-1)*M';
ku=K(1,:)*MP;
if (pomiar)
    kz=K(1,:)*MZ;
end
ke=sum(K(1,:));

% % Skok wartosci zadanej
Y_zad(1:99)=Ypp;
Y_zad(100:299)= 1; %1
Y_zad(300:499)= 1; %2
Y_zad(500:n)= 1; %-1

% Skok zaklocen
t_skoku = 300;
if(typ_zak == 1)
    Z(t_skoku:n) = 1;
elseif(typ_zak == 2)    %Zaklocenia sinusoidalne
    pom = (1 : 1 : n);
    Z(t_skoku:n) = 0.5*sin(0.08*pom(t_skoku:n));
end

if(szum == 1)
    noise = linspace(-1*pi, 1*pi); %noise = linspace(-2*pi, 2*pi);
    for k = t_skoku:n
        Z(k) = Z(k) + sum(rand(size(noise)))/25;
    end
end

for k = 1 : opoznienie
    e(k) = Y_zad(k)-Y(k);
end

%Przebieg
for k = opoznienie+1:(T/Tp)
    Y(k) = symulacja_obiektu3y(U(k-5),U(k-6),Z(k-2),Z(k-3),Y(k-1),Y(k-2));
    e(k) = Y_zad(k)-Y(k);
    err = err + e(k)^2;
    
    dZ(k) = Z(k)-Z(k-1);
       
    sum1 = 0;
    for j = 1:D-1
        if(k>j)
            sum1 = sum1 + ku(j)*dU(k-j);
        end
    end
    
    sum2 = 0;
    if(pomiar == 1)
        for j = 1:Dz
            if(k>j+1)
                sum2 = sum2 + kz(j)*dZ(k-j-1);
            end
        end
    end
    
    dU(k) = ke*e(k)-sum1 - sum2;
    
    U(k) = dU(k) + U(k-1);
end

figure;
subplot(2,1,1);
stairs(U);
hold on;
grid on;
stairs(Z);
ylim([-4 4]);
title("Sygna³ wejœciowy sterowania i zak³ócenia", 'FontName', 'Times New Roman CE');
xlabel('$k$', 'Interpreter', 'latex');
legend('$u(k)$', '$z(k)$', 'Interpreter', 'latex','Location','southwest');
hold off;

subplot(2,1,2);
plot(1:n, Y);
hold on;
grid on;
stairs(1:T/Tp, Y_zad, '--');
title("Sygna³ wyjœciowy i wartoœæ zadana", 'FontName', 'Times New Roman CE');
ylim([-2 3]);
xlabel('$k$', 'Interpreter', 'latex');
legend('$y(k)$','$y^{\mathrm{zad}}(k)$', 'Interpreter', 'latex','Location','southwest');
hold off;

if(pomiar)
    strfin = strcat('zad7_DMC_D',strD, '_N', strN, '_Nu', strNu, '_L', strL, '_Dz_2', '.tex');
else
    strfin = strcat('zad7_DMC_D',strD, '_N', strN, '_Nu', strNu, '_L', strL, '_Dz', '_bz_1', '.tex');
end

matlab2tikz (char(strfin), 'showInfo', false );

err