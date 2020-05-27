% Obliczenia na wektorach i macierzach w celu wyznaczenia parametrów DMC
clear all;

load('ODP_SKOK_G1.mat')
load('ODP_SKOK_G2.mat')

s1_t1 = table2array(ODPSKOKG1(:,2));
s_1(:,1) = s1_t1(13:162)/800;
s1_t3 = table2array(ODPSKOKG1(:,4));
s_1(:,2) = s1_t3(13:162)/800;

s2_t1 = table2array(ODPSKOKG2(:,2));
s_2(:,1) = s2_t1(14:163)/800;
s2_t3 = table2array(ODPSKOKG2(:,4));
s_2(:,2) = s2_t3(14:163)/800;

% figure;
% plot(s_1(:,1));
% hold on;
% plot(s_1(:,2));
% hold on;
% plot(s_2(:,1));
% hold on;
% plot(s_2(:,2));
% hold on;

D = length(s_1);
N = 20;
Nu = 3;

S = [];

for i = 1 : D
    S(1,1,i) = s_1(i,1);
    S(1,2,i) = s_1(i,2);
    S(2,1,i) = s_2(i,1);
    S(2,2,i) = s_2(i,2);
end

M = cell(N, Nu);
for i=1:N
    for j=1:Nu
        if (i>=j)
            M{i,j}=S(:,:,i-j+1);
        else
            M{i,j} = [0 0;0 0];
        end
    end
end

MP = cell(N, (D-1));
for i=1:N
    for j=1:(D-1)
        if i+j<=D
            MP{i,j}=S(:,:,i+j)-S(:,:,j);
        else
            if j <= D
                MP{i,j}=S(:,:,D)-S(:,:,j);
            else
                MP{i,j}=S(:,:,D)-S(:,:,D-1);
            end
        end
    end
end

lambda = eye(Nu*2)*10;
psi = eye(N*2)*1;
Mt = M';

M = cell2mat(M);
MP = cell2mat(MP);
K = (M'*psi*M+lambda)^(-1)*M'*psi;
K1 = K(1:2,:);

Ku = K1*MP;

fprintf('DMC.KE1 := %.10f; \n', sum(K1(1,:)))
fprintf('DMC.KE2 := %.10f; \n', sum(K1(2,:)))


for i = 1:size(Ku, 2)
    fprintf('DMC.KU1[%d] := %.10f; \n', i, Ku(1, i))
end

for i = 1:size(Ku, 2)
    fprintf('DMC.KU2[%d] := %.10f; \n', i, Ku(2, i))
end

% Przesuwanie DUP

disp('DMC.DUP[0] := DMC.DU1;')
disp('DMC.DUP[1] := DMC.DU2;')

for i = 2:size(Ku, 2)
    fprintf('DMC.DUP[%d] := DMC.DUP1[%d]; \n', i, i-2)
end

% duk = K1*(Yzad(:,k) - Yk - MP*dUp);
