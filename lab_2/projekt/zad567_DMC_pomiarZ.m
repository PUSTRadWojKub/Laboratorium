% Symulacja algorytmu PID i DMC dla procesu
% 
clear all;

pomiar = 1;      % 0 - brak pomiaru zak³óceñ, 1 - z pomiarem zak³óceñ
typ_zak = 1;     % 1 - skok jednostkowy zak³óceñ, 2 - zak³ócenia sinusoidalne
szum = 1;        % 0 - brak szumu, 1 - szum obecny

odp_skokU = load('odp_skokU.mat');
odp_skokZ = load('odp_skokZ.mat');
s = odp_skokU.odp_skok;
sz = odp_skokZ.odp_skok;

%Stan ustalony
Upp = 0; %sygnal wejsciowy w stanie ustalonym
Ypp = 0; %sygnal wyjsciowy w stanie ustalonym
Zpp = 0;


Tp = 0.5; %okres probkowania
T = 300; %czas symulacji
n = T/Tp;
opoznienie = 6;

%Opoznienie
U(1:n) = Upp;
Z(1:n) = Zpp;
Y(1:opoznienie) = Ypp;
e(1:n) = 0;
dU(1:n) = 0;
dZ(1:n) = 0;

%Horyzonty
D=length(s);
Dz = length(sz);
N=20; %20
Nu=3; %1
    
%Wspolczynnik kary za przyrosty sterowania
lambda=1; %1

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

MZ = zeros(N,Dz-1);
for i = 1:N
       for j = 1:Dz-1
          if i+j <= N
             MZ(i,j) = sz(i+j)-sz(j);
          else
             MZ(i,j) = sz(Dz)-sz(j);
          end
       end
end
    
I=eye(Nu);
K=((M'*M+lambda*I)^-1)*M';
ku=K(1,:)*MP;
kz=K(1,:)*MZ;
ke=sum(K(1,:));

% Skok wartosci zadanej   
Y_zad(1:99)=Ypp;
Y_zad(100:299)= 1;
Y_zad(300:499)= 2;
Y_zad(500:n)= -1;

% % Skok wartosci zadanej
% Y_zad(1:n) = Ypp;
% Y_zad(n/2:n) = 1;

% Skok zak³óceñ
t_skoku = 100;
if(typ_zak == 1)
    Z(t_skoku:n) = 1;
elseif(typ_zak == 2)    %Zak³ócenia sinusoidalne
    pom = (1 : 1 : n);
    Z(t_skoku:n) = 0.5*sin(0.08*pom(t_skoku:n));
end

if(szum == 1)
    noise = linspace(-2*pi, 2*pi);
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
    for j = 1:Dz-1
        if(k>j)
            sum2 = sum2 + kz(j)*dZ(k-j);
        end
    end
    if(pomiar ~= 1)
        sum2 = 0;
    end
    dU(k) = ke*e(k)-sum1 - sum2;
    
    U(k) = dU(k) + U(k-1);
end

figure;
subplot(2,1,1);
stairs(U);
grid on;
ylim([-4 3]);
title("Sygnal wejsciowy");

subplot(2,1,2);
plot(1:n, Y);
hold on;
grid on;
stairs(1:T/Tp, Y_zad, '--');
title("Sygnal wyjsciowy i zadany");
ylim([-2 3]);
hold off;
err