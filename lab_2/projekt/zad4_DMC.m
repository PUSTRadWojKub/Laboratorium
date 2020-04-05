% Symulacja algorytmu PID i DMC dla procesu
% 
clear all;

pomiar = 0;

odp_skokU = load('odp_skokU.mat');
s = odp_skokU.odp_skok;

%Stan ustalony
Upp = 0; %sygnal wejsciowy sterowania w stanie ustalonym
Zpp = 0; %sygnal wejsciowy zaklocenia w stanie ustalownym
Ypp = 0; %sygnal wyjsciowy w stanie ustalonym


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

%Horyzonty
D=length(s);
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
    
I=eye(Nu);
K=((M'*M+lambda*I)^-1)*M';
ku=K(1,:)*MP;
ke=sum(K(1,:));

% % Skok wartosci zadanej   
% Y_zad(1:99)=Ypp;
% Y_zad(100:299)= 1;
% Y_zad(300:499)= 2;
% Y_zad(500:n)= -1;

% Skok wartosci zadanej
Y_zad(1:n) = Ypp;
Y_zad(n/2:n) = 1;

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
    dU(k) = ke*e(k)-sum1;
    
    U(k) = dU(k) + U(k-1);
end

figure;
stairs(U);
grid on;
title("Sygnal wejsciowy");

figure;
plot(1:n, Y);
hold on;
grid on;
stairs(1:T/Tp, Y_zad, '--');
title("Sygnal wyjsciowy i zadany");

err