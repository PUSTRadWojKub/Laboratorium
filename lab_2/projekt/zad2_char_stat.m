%Wyznaczanie charakterystki statycznej

clear;

Tp = 0.5; %okres probkowania
T = 200; %czas symulacji
opoznienie = 6;

Umin=-10;
Umax=10;
Zmin=-10;
Zmax=10;
dU = Umin:0.5:Umax;
dZ = Zmin:0.5:Zmax;
Ustat(1:length(dU))=0;
Zstat(1:length(dZ))=0;
Ystat(1:length(dZ),1:length(dU))=0;
U(1:T/Tp)=0;
Z(1:T/Tp)=0;
Y(1:T/Tp)=0;
for i=1:length(dZ)
    Z(1:T/Tp)=dZ(i);
    for j=1:length(dU)
        U(1:T/Tp)=dU(j);
        for k=opoznienie+1:T/Tp
            Y(k)=symulacja_obiektu3y(U(k-5),U(k-6),Z(k-2),Z(k-3),Y(k-1),Y(k-2));
        end
        Ustat(j)=U(T/Tp);
        Ystat(i,j)=Y(T/Tp);
    end
    Zstat(i)=Z(T/Tp);
end

figure;
mesh(Ustat,Zstat,Ystat);
xlabel('U');
ylabel('Z');
zlabel('Y(Z,U)');
grid on;
title('Charakterystyka statyczna Y(Z,U)');
legend('Y(Z,U)');
% matlab2tikz ('zad2_char_stat.tex','showInfo', false );


% Wzmocnienie stayczne toru u-y
Kuy_stat1 = (Ystat(1,end)-Ystat(1,1)) / (Umax - Umin); % liczone dla Zmin
Kuy_stat2 = (Ystat(end,end)-Ystat(end,1)) / (Umax - Umin); % liczone dla Zmax

% Wzmocnienie stayczne toru z-y
Kzy_stat1 = (Ystat(end,1)-Ystat(1,1)) / (Zmax - Zmin); % liczone dla Umin
Kzy_stat2 = (Ystat(end,end)-Ystat(1,end)) / (Zmax - Zmin); % liczone dla Umax

%Wlasciwosci statyczne i dynamiczne procesu sa w przyblizeniu liniowe
%Wzmocnienie statyczne toru u-y wynosi 1.885738217823242
%Wzmocnienie statyczne toru z-y wynosi 1.090604005325325
