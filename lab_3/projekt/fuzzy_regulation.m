% Symulacja algorytmu PID i DMC dla procesu

clear all;

%Stan ustalony
Upp = 0; %sygnal wejsciowy w stanie ustalonym
Ypp = 0; %sygnal wyjsciowy w stanie ustalonym

%Regulator: 0 - pid, 1 - dmc
piddmc = 0;
%Liczba lokalnych regulatorow
nr = 3;
%Typ funkcji przynale¿noœci: trimf, trapmf, gaussmf
mf = "trimf";
%Parametr do odpowiedzi skokowych do DMC (o ile skacze)
dUskok = 0.12;
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
    switch nr
        case 2
            K = [4.9, 0.128];
            Ti = [7.5, 7.8];
            Td = [0.8, 0.42];
        case 3
            K = [4.9, 0.18, 0.128];
            Ti = [7.5, 2.8, 7.8];
            Td = [0.8, 0.52, 0.42];
        case 4
            K = [4.9, 0.25, 0.1, 0.128];
            Ti = [7.5, 2, 2.4, 7.8];
            Td = [0.8, 1.1, 1.4, 0.42];
        otherwise
            disp('Liczba regulatorow lokalnych powinna wynosic 2, 3 lub 4')
            return
    end
    r0 = zeros(1, nr);
    r1 = zeros(1, nr);
    r2 = zeros(1, nr);
    for k = 1:nr
        r0(k) = K(k)*(1 + Tp/(2*Ti(k)) + Td(k)/Tp);
        r1(k) = K(k)*(Tp/(2*Ti(k)) - (2*Td(k))/Tp - 1);
        r2(k) = (K(k)*Td(k))/Tp;
    end
end

%Parametry regulatora DMC
if(piddmc == 1)
    if ~ismember(nr, [2,3,4,5])
        disp('Liczba regulatorow lokalnych powinna wynosic 2, 3 lub 4')
        return
    end
    M = cell(1,nr);
    MP = cell(1,nr);
    K = cell(1,nr);
    ku = cell(1,nr);
    ke = cell(1,nr);
    for k = 1:nr
        Upocz = ((Umax-Umin)/(nr+1)*k)-1;
        s = odp_skok(Upocz, Upocz+dUskok);
        %Horyzonty
        D=length(s);
        N=20; 
        Nu=3; 

        %Wspolczynnik kary za przyrosty sterowania
        lambda=1; %1

        %Generacja macierzy
        M{k}=zeros(N,Nu);
        for i=1:N
            for j=1:Nu
                if (i>=j)
                    M{k}(i,j)=s(i-j+1);
                end
            end
        end

        MP{k}=zeros(N,D-1);
        for i=1:N
            for j=1:D-1
                if i+j<=D
                    MP{k}(i,j)=s(i+j)-s(j);
                else
                    MP{k}(i,j)=s(D)-s(j);
                end
            end
        end

        I=eye(Nu);
        K{k}=((M{k}'*M{k}+lambda*I)^-1)*M{k}';
        ku{k}=K{k}(1,:)*MP{k};
        ke{k}=sum(K{k}(1,:));
    end
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

mfs = fuzzy_membership_functions(Umin, Umax, nr, mf);

%Przebieg
for k = opoznienie+1:(T/Tp)
    Y(k) = symulacja_obiektu3y(U_cale(k-5), U_cale(k-6), Y(k-1), Y(k-2));
    e(k) = Y_zad(k)-Y(k);
    err = err + e(k)^2;
    
    weights = fuzzy_weights(U_cale(k-1), mfs);
    
    %Regulator PID
    if(piddmc == 0)
        fdU = zeros(1, nr);
        for l = 1:nr
            fdU(l) = r2(l)*e(k-2) + r1(l)*e(k-1) + r0(l)*e(k);
        end
        dU = weights*fdU'/sum(weights);
    end
    
    %Regulator DMC (wersja oszczedna)
    if(piddmc == 1)
        fdU = zeros(1, nr);
        for l = 1:nr
            sum1 = 0;
            for j = 1:D-1
                if(k>j)
                    sum1 = sum1 + K{l}(1,:)*MP{l}(:, j)*dU_cale(k-j);
                end
            end
        fdU(l) = ke{l}*e(k)-sum1;
        end
        dU = weights*fdU'/sum(weights);
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

s1 = '../sprawozdanie/rysunki/zad5_syg_we';
s2 = '../sprawozdanie/rysunki/zad5_syg_wy';

if ~piddmc
    s1 = strcat(s1, '_pid_nr_', string(nr), '_mf_', mf, '.pdf');
    s2 = strcat(s2, '_pid_nr_', string(nr), '_mf_', mf, '.pdf');
else
    s1 = strcat(s1, '_dmc_nr_', string(nr), '_mf_', mf, '.pdf');
    s2 = strcat(s2, '_dmc_nr_', string(nr), '_mf_', mf, '.pdf');
end

s1 = convertStringsToChars(s1);
s2 = convertStringsToChars(s2);

figure;
stairs(U_cale);
grid on;
% title('Sygna³ wejœciowy','interpreter', 'latex');
legend('$u(k)$', 'interpreter', 'latex','location','southeast');
ylim([-1.05,1.05]);
xlabel('$k$','interpreter', 'latex');
ylabel('$u(k)$', 'interpreter', 'latex');
% print(s1,'-dpdf');
% matlab2tikz(s1, 'showInfo', false)

figure;
plot(1:T/Tp, Y);
hold on;
grid on;
stairs(1:T/Tp, Y_zad, '--');
% title('Sygna³ wyjœciowy i zadany','interpreter', 'latex');
legend('$y(k)$', '$y^{zad}(k)$', 'interpreter', 'latex','location','southeast');
xlabel('$k$','interpreter', 'latex');
ylabel('$y(k)$, $y^{zad}(k)$', 'interpreter', 'latex');
% print(s2,'-dpdf');
% matlab2tikz(s2, 'showInfo', false)
