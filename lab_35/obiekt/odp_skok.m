clear;

load('odpSkok.mat');

% Wartości zadane utrzymywać w granicach 20 - 60 st C

S = [];

s_1 = s1(201:300,:);
s_2 = s2(201:300,:);

s_1(:,1) = (s_1(:,1) - s_1(1,1))/20;
s_1(:,2) = (s_1(:,2) - s_1(1,2))/20;
figure;
plot(s_1);

s_2(:,1) = (s_2(:,1) - s_2(1,1))/20;
s_2(:,2) = (s_2(:,2) - s_2(1,2))/20;
figure;
plot(s_2);

D = length(s_1);

for i = 1 : D
    S(1,1,i) = s_1(i,1);
    S(1,2,i) = s_1(i,2);
    S(2,1,i) = s_2(i,1);
    S(2,2,i) = s_2(i,2);
end


N = 10;
Nu = 10;
M = cell(2*N,2*Nu);
for i=1:N*2
    for j=1:Nu*2
        if (i>=j)
            M{i,j}=S(:,:,i-j+1);
        else
            M{i,j} = [0 0;0 0];
        end
    end
end

MP = cell(N*2,(D-1)*2);
for i=1:N*2
    for j=1:(D-1)*2
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

lambda = eye(Nu*2*2)*1;
psi = eye(N*2*2)*1;
% 
Mt = M';




for i=1:Nu*2
    size(i)=2;
end
for i=1:N*2
    size2(i)=2;
end

Psi = mat2cell(psi,size2,size2);
Lambda = mat2cell(lambda,size,size);

C = num2cell((cell2mat(Mt)*psi*cell2mat(M)+lambda)^(-1)*cell2mat(Mt)*psi);
C1 = C(1:2,:);

% M_temp = cell(N*2,N*2);
% for i = 1 : N*2
%     for j = 1 : N*2
%         M_temp{i,j} = cell2mat(M(i,j))*cell2mat(Psi(i,j))*cell2mat(Mt(i,j));
%     end
% end

M = cell2mat(M);
MP = cell2mat(MP);
K = (M'*psi*M+lambda)^(-1)*M'*psi;
K1 = K(1:2,:);