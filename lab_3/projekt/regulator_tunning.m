% Symulacja algorytmu PID i DMC dla procesu

clear all;

s = odp_skok(0,1);

%Stan ustalony
Upp = 0; %sygnal wejsciowy w stanie ustalonym
Ypp = 0; %sygnal wyjsciowy w stanie ustalonym

%Strojenie regulatorów lokalnych PID
% %R1
% Upp = -0.5;
% Ypp = -0.1264;
% %R2
% Upp = 0.76;
% Ypp = 3.225;
%R3
% Upp = 0.26;
% Ypp = 0.4062;
% %R4
% Upp = 0.16;
% Ypp = 0.1865;
%R5
% Upp = 0.4;
% Ypp = 0.896;

%Regulator: 0 - pid, 1 - dmc
piddmc = 1;
%Ograniczenia: 0 - wylaczone, 1 - wlaczone
ograniczenia = 1;

%Ograniczenia wartosci sygnalu sterowania
Umin = -1;
Umax = 1;

Tp = 0.5; %okres probkowania
T = 600; %czas symulacji
opoznienie = 6;

% Deklaracja zmiennych
U_cale(1:T/Tp) = 0;
dU_cale(1:T/Tp) = 0;
Y(1:T/Tp) = 0;
e(1:T/Tp) = 0;

%Parametry regulatora PID
if(piddmc == 0)
    % Nr = 1
    K = 0.11; 
    Ti = 4.6;
    Td = 0.65;
%     %R1
%     K = 4.9;
%     Ti = 7.5;
%     Td = 0.8;
%     %R2
%     K = 0.128;
%     Ti = 7.8;
%     Td = 0.42;
%     %R3
%     K = 0.18;
%     Ti = 2.8;
%     Td = 0.52;
%     %R4
%     K = 0.25;
%     Ti = 2;
%     Td = 1.1;
%     %R5
%     K = 0.1;
%     Ti = 2.4;
%     Td = 1.4;
    r0 = K*(1 + Tp/(2*Ti) + Td/Tp);
    r1 = K*(Tp/(2*Ti) - (2*Td)/Tp - 1);
    r2 = (K*Td)/Tp;
end


%Parametry regulatora DMC
if(piddmc == 1)
    %Horyzonty
    D=length(s);
    N=20; 
    Nu=3; 
    
    %Wspolczynnik kary za przyrosty sterowania
    lambda=2; %1
    
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
end


% Skok wartosci zadanej
% Test I
% Y_zad(1:19)=Ypp;
% Y_zad(20:T/Tp)=2;

% Test II    
Y_zad(1:99)=Ypp;
Y_zad(100:299)=0.5;
Y_zad(300:499)=1;
Y_zad(500:T/Tp)=-0.1;
Y_zad(700:T/Tp)=5;

%Strojenie regulatorów lokalnych PID
% %R1
% Y_zad(1:99)=Ypp;
% Y_zad(100:299)=-0.15;
% Y_zad(300:499)=-0.13;
% Y_zad(500:T/Tp)=-0.09;
% Y_zad(700:T/Tp)=Ypp
% %R2
% Y_zad(1:99)=Ypp;
% Y_zad(100:299)=4.1;
% Y_zad(300:499)=3.8;
% Y_zad(500:T/Tp)=2.4;
% Y_zad(700:T/Tp)=Ypp;
% %R3
% Y_zad(1:99)=Ypp;
% Y_zad(100:299)=0.57;
% Y_zad(300:499)=0.42;
% Y_zad(500:T/Tp)=0.27;
% Y_zad(700:T/Tp)=Ypp;
% %R4
% Y_zad(1:99)=Ypp;
% Y_zad(100:299)=0.3;
% Y_zad(300:499)=0.2;
% Y_zad(500:T/Tp)=0.09;
% Y_zad(700:T/Tp)=Ypp;
% %R5
% Y_zad(1:99)=Ypp;
% Y_zad(100:299)=1.2;
% Y_zad(300:499)=1;
% Y_zad(500:T/Tp)=0.7;
% Y_zad(700:T/Tp)=Ypp;


% Wartosci poczatkowe
U_cale(1) = Upp;
dU_cale(1) = 0;
Y(1) = Ypp;
e(1) = Y_zad(1)-Y(1);

%Opoznienie
for k = 2:opoznienie
    U_cale(k) = Upp;
    dU_cale(k) = U_cale(k)-U_cale(k-1);
    Y(k) = Ypp;
    e(k) = Y_zad(k)-Y(k);
end

err = 0;

%Przebieg
for k = opoznienie+1:(T/Tp)
    Y(k) = symulacja_obiektu3y(U_cale(k-5), U_cale(k-6), Y(k-1), Y(k-2));
    e(k) = Y_zad(k)-Y(k);
    err = err + e(k)^2;
    
    %Regulator PID
    if(piddmc == 0)
        dU = r2*e(k-2) + r1*e(k-1) + r0*e(k);
    end
    
    %Regulator DMC (wersja oszczedna)
    if(piddmc == 1)
        sum1 = 0;
        for j = 1:D-1
            if(k>j)
                sum1 = sum1 + K(1,:)*MP(:, j)*dU_cale(k-j);
            end
        end
        dU = ke*e(k)-sum1;
    end
    
    U = dU + U_cale(k-1);
    
    %Ograniczenia wartosci sygnalu sterowania
    if (ograniczenia)
        if (U > Umax)
            U = Umax;
        elseif (U < Umin)
            U = Umin;
        end
    end
    
    U_cale(k) = U;
    dU_cale(k) = U_cale(k) - U_cale(k-1);
end

err

figure;
stairs(U_cale);
grid on;
title("Sygna³ wejœciowy");
legend('$u(k)$', 'interpreter', 'latex');

figure;
plot(1:T/Tp, Y);
hold on;
grid on;
stairs(1:T/Tp, Y_zad, '--');
title("Sygna³ wyjœciowy i zadany");
legend('$y(k)$', '$y^{zad}(k)$', 'interpreter', 'latex');
