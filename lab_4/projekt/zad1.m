clear;

U1pp = 0;
U2pp = 0;
U3pp = 0;
U4pp = 0;

Y1pp = 0;
Y2pp = 0;
Y3pp = 0;

Tp = 0.5; %okres probkowania
T = 200; %czas symulacji
opoznienie = 4;

u1(1:T/Tp) = U1pp;
u2(1:T/Tp) = U2pp;
u3(1:T/Tp) = U3pp;
u4(1:T/Tp) = U4pp;

y1(1:T/Tp) = 0;
y2(1:T/Tp) = 0;
y3(1:T/Tp) = 0;

y1(1:opoznienie) = Y1pp;
y2(1:opoznienie) = Y2pp;
y3(1:opoznienie) = Y3pp;

for k = opoznienie+1 : T/Tp
    [y1(k),y2(k),y3(k)]=symulacja_obiektu3(u1(k-1),u1(k-2),u1(k-3),u1(k-4),...
                                        u2(k-1),u2(k-2),u2(k-3),u2(k-4),...
                                        u3(k-1),u3(k-2),u3(k-3),u3(k-4),...
                                        u4(k-1),u4(k-2),u4(k-3),u4(k-4),...
                                        y1(k-1),y1(k-2),y1(k-3),y1(k-4),...
                                        y2(k-1),y2(k-2),y2(k-3),y2(k-4),...
                                        y3(k-1),y3(k-2),y3(k-3),y3(k-4));
                                    
end

figure;
plot(1:T/Tp, y1);
figure;
plot(1:T/Tp, y2);
figure;
plot(1:T/Tp, y3);