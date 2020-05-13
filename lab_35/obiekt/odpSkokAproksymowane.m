clear;

fitness_fun = @coeffOptim;

[x,fval,exitflag,output] = ga(fitness_fun, 6);

T1_1 = x(1); 
T2_1 = x(2);
K1 = x(3);
T1_2 = x(4); 
T2_2 = x(5); 
K2 = x(6);
Td = 2;

y1 = zeros(100, 2);
y2 = zeros(100, 2);
u1 = zeros(100, 2);
u2 = zeros(100, 2);
u1(:,1) = 1;
u2(:,2) = 1;

odpSkok = load('OdpSkok.mat');

s1 = odpSkok.s1;
s2 = odpSkok.s2;

s_1 = s1(201:300,:);
s_2 = s2(201:300,:);

s_1(:,1) = (s_1(:,1) - s_1(1,1))/20;
s_1(:,2) = (s_1(:,2) - s_1(1,2))/20;
s_2(:,1) = (s_2(:,1) - s_2(1,1))/20;
s_2(:,2) = (s_2(:,2) - s_2(1,2))/20;

alpha1_1 = exp(-1/T1_1);
alpha2_1 = exp(-1/T2_1);
a11 = -alpha1_1 - alpha2_1; 
a21 = alpha1_1*alpha2_1;
b11 = K1*(T1_1*(1 - alpha1_1)-  T2_1*(1 - alpha2_1))/(T1_1 - T2_1);
b21 = K1*(alpha1_1*T2_1 * (1 - alpha2_1) - alpha2_1*T1_1 * (1 - alpha1_1)) / (T1_1 - T2_1);

alpha1_2 = exp(-1/T1_2);
alpha2_2 = exp(-1/T2_2);
a12 = -alpha1_2 - alpha2_2; 
a22 = alpha1_2*alpha2_2;
b12 = K2*(T1_2*(1 - alpha1_2)-  T2_2*(1 - alpha2_2))/(T1_2 - T2_2);
b22 = K2*(alpha1_2*T2_2 * (1 - alpha2_2) - alpha2_1*T1_2 * (1 - alpha1_2)) / (T1_2 - T2_2);

for k = floor(Td)+3 : 100
y1(k,1) = b11*u1(k - Td -1,1)+b21*u1(k-Td-2,1)-a11*y1(k-1,1)- a21*y1(k-2,1);
y1(k,2) = b12*u1(k - Td -1,1)+b22*u1(k-Td-2,1)-a12*y1(k-1,2)- a22*y1(k-2,2);
end
for k = floor(Td)+3 : 100
y2(k,1) = b11*u2(k - Td -1,2)+b21*u2(k-Td-2,2)-a11*y2(k-1,1)- a21*y2(k-2,1);
y2(k,2) = b12*u2(k - Td -1,2)+b22*u2(k-Td-2,2)-a12*y2(k-1,2)- a22*y2(k-2,2);
end

e1 = s_1 - y1;
e2 = s_2 - y2;
E1 = (norm(e1))^2;
E2 = (norm(e2))^2;
E = E1 + E2;

figure;
plot(y1);
hold on;
plot(s_1);
title("Aproksymacja odpowiedzi skokowej"); legend("$\widehat{s}^{T1}$", "$\widehat{s}^{T2}$", "$s^{T1}$", "$s^{T2}$", "interpreter", "latex");
xlabel("$i$", "interpreter", "latex"); ylabel("$s_i$", "interpreter", "latex");
print("odp_skok_g1_aproksym.pdf",'-dpdf');

figure;
plot(y2);
hold on;
plot(s_2);
title("Aproksymacja odpowiedzi skokowej"); legend("$\widehat{s}^{T2}$", "$\widehat{s}^{T1}$", "$s^{T1}$", "$s^{T2}$", "interpreter", "latex");
xlabel("$i$", "interpreter", "latex"); ylabel("$s_i$", "interpreter", "latex");
print("odp_skok_g2_aproksym.pdf",'-dpdf');

% G = tf(K,[T1*T2, (T2+T1),1], 'OutputDelay',Td); 
% Gz = c2d(G,1);
% 
% y = step(1:100,Gz); 
% 
% figure;
% plot(y);

s_1 = y1;
s_2 = y2;

% save('odpSkokAprok');