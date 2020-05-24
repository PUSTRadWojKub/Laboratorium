function e = coeffOptim(x)

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

U = [0 0 0 0;...
    0 0 0 0;...
    0 0 0 0;...
    0 0 0 0];

u1 = U(:,1);
u2 = U(:,2);
u3 = U(:,3);
u4 = U(:,4);

e1 = 0;
e2 = 0;
e3 = 0;

yzad = [1 2 0.5];

% Regulator 1
K1 = x(1);
Ti1 = x(2);
Td1 = x(3);
r01 = K1*(1 + Tp/(2*Ti1) + Td1/Tp);
r11 = K1*(Tp/(2*Ti1) - (2*Td1)/Tp - 1);
r21 = (K1*Td1)/Tp;


% Regulator 2
K2 = x(4);
Ti2 = x(5);
Td2 = x(6);
r02 = K2*(1 + Tp/(2*Ti2) + Td2/Tp);
r12 = K2*(Tp/(2*Ti2) - (2*Td2)/Tp - 1);
r22 = (K2*Td2)/Tp;


% Regulator 3
K3 = x(7);
Ti3 = x(8);
Td3 = x(9);
r03 = K3*(1 + Tp/(2*Ti3) + Td3/Tp);
r13 = K3*(Tp/(2*Ti3) - (2*Td3)/Tp - 1);
r23 = (K3*Td3)/Tp;

Uplot = [];
Yplot = [];

e = 0;

% Wybór sygna³ów wejœciowych
% 1 - U1, U2, U3
% 2 - U1, U2, U4
% 3 - U2, U3, U4
% 4 - U1, U3, U4
regulator = 3;

for k = opoznienie + 1 : T/Tp
    [y1(k),y2(k),y3(k)]=symulacja_obiektu3(u1(k-1),u1(k-2),u1(k-3),u1(k-4),...
                                        u2(k-1),u2(k-2),u2(k-3),u2(k-4),...
                                        u3(k-1),u3(k-2),u3(k-3),u3(k-4),...
                                        u4(k-1),u4(k-2),u4(k-3),u4(k-4),...
                                        y1(k-1),y1(k-2),y1(k-3),y1(k-4),...
                                        y2(k-1),y2(k-2),y2(k-3),y2(k-4),...
                                        y3(k-1),y3(k-2),y3(k-3),y3(k-4));
    
    e = e + (yzad(1)-y1(k))^2 + (yzad(2)-y2(k))^2 + (yzad(3)-y3(k))^2;
    
    e1(k) = yzad(1)-y1(k);
    e2(k) = yzad(2)-y2(k);  
    e3(k) = yzad(3)-y3(k);  
    
    dU1 = r21*e1(k-2) + r11*e1(k-1) + r01*e1(k);
    dU2 = r22*e2(k-2) + r12*e2(k-1) + r02*e2(k);
    dU3 = r23*e3(k-2) + r13*e3(k-1) + r03*e3(k);
    switch regulator
        case 1
            u1(k) = U(1,1)+dU1;
            u2(k) = U(1,2)+dU2;
            u3(k) = U(1,3)+dU3;
            u4(k) = 0;
        case 2
            u1(k) = U(1,1)+dU1;
            u2(k) = U(1,2)+dU2;
            u3(k) = 0;
            u4(k) = U(1,3)+dU3;
        case 3
            u1(k) = 0;
            u2(k) = U(1,1)+dU1;
            u3(k) = U(1,2)+dU2;
            u4(k) = U(1,3)+dU3;
        case 4
            u1(k) = U(1,1)+dU1;
            u2(k) = 0;
            u3(k) = U(1,2)+dU2;
            u4(k) = U(1,3)+dU3;
    end
    
    U = [[u1(k), u2(k), u3(k), u4(k)]; U];       
end


end