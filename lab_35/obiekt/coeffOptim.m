function E = coeffOptim(x)
T1_1 = x(1); 
T2_1 = x(2); 
K1 = x(3); %Td = x(4);
T1_2 = x(4); 
T2_2 = x(5); 
K2 = x(6); %Td = x(4);
% T1 = 6.371; 
% T2 = 6.785; 
% K = 2.807;
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

e = s_1 - y1;

E = (norm(e))^2;

end