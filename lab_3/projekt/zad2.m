%Wyznaczamy symulacyjnie odpowiedzi skokowe dla procesu, dla kilku zmian
%sygnalu sterowania z uwzglednieniem ograniczen

clear all;

%Stan ustalony
Upp = 0; %sygnal wejsciowy w stanie ustalonym
Ypp = 0; %sygnal wyjsciowy w stanie ustalonym

%Ograniczenia wartosci sygnalu sterowania
Umin = -1;
Umax = 1;

Tp = 0.5; %okres probkowania
T = 300; %czas symulacji
opoznienie = 6;

T1 = 20; %czas 1. skoku wartosci sygnalu sterowania
T2 = 80; %czas 2. skoku wartosci sygnalu sterowania
T3 = 140; %czas 3. skoku wartosci sygnalu sterowania
T4 = 200; %czas 4. skoku wartosci sygnalu sterowania

U1 = -1;
U2 = -0.5;
U3 = 0.5;
U4 = 1;

U_cale(1:T/Tp) = Upp;
Y(1:T/Tp) = Ypp;

U = U_cale;

%Przebieg
for i=1:4
for k = opoznienie+1:(T/Tp)
    switch i
        case 1
            U(opoznienie+10:T/Tp) = U1;
        case 2
            U(opoznienie+10:T/Tp) = U2;
        case 3
            U(opoznienie+10:T/Tp) = U3;
        case 4
            U(opoznienie+10:T/Tp) = U4;
    end
    
    %Ograniczenia
    if (U < Umin)
        U = Umin;
    elseif (U > Umax)
        U = Umax;
    end
    
    Y(k) = symulacja_obiektu3y(U(k-5), U(k-6), Y(k-1), Y(k-2));
end
subplot(2,1,1);
plot(1:T/Tp, Y);
grid on;
title("Sygna� wyj�ciowy");
hold on;
subplot(2,1,2);
stairs(1:T/Tp, U)
grid on;
title("Sygna� wej�ciowy");
hold on;
i=i+1;
end
% matlab2tikz('../sprawozdanie/rysunki/zad2_odp_skokowe.tex', 'showInfo', false)

%Wyznaczanie charakterystki statycznej
dU = Umin:0.01:Umax;
Ustat(1:length(dU))=0;
Ystat(1:length(dU))=0;
U(1:T/Tp)=Umin;
for i=1:length(dU)
    U(1:T/Tp)=dU(i);
    for k=opoznienie+1:T/Tp
        Y(k)=symulacja_obiektu3y(U(k-5),U(k-6),Y(k-1),Y(k-2));
    end
    Ustat(i)=U(T/Tp);
    Ystat(i)=Y(T/Tp);
end

figure;
plot(Ustat,Ystat);
xlabel('U');
ylabel('Y');
title('Charakterystyka statyczna Y(U)');
% matlab2tikz('../sprawozdanie/rysunki/zad2_char_stat.tex', 'showInfo', false)

%Wlasciwosci statyczne i dynamiczne procesu nie s� liniowe