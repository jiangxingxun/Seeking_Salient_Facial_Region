function B = ALM_ISLSR_fixednum(X,Y,B,num,fdim,channel_num)
% This routine solves the following nuclear-norm optimization problem,
% min |Z|_*+lambda_1|D - CAZ|_F^2+lambda*|E|_2,1
% min |X - APY|_F^2+lambda*|B|_2,1
% s.t., P = B
% inputs:
%        X -- D*N data matrix, D is the data dimension, and N is the number
%             of data vectors.
%        A -- D*M matrix of a dictionary, M is the size of the dictionary

tol = 1e-8;
maxIter = 1e6;
[d n] = size(Y);
[m] = size(B,2);
[dx] = size(X,1);
rho = 1.1;
max_mu = 1e15;
mu = 1e-3;

%% Initializing optimization variables
% intialize

P = B;
% B = sparse(m,d);
T = zeros(d,m);

%% Start main loop
iter = 0;
if d > n
    [Q,R] = qr(Y,0);
    [Q1,D,Q1] = svd(R*R');
    U = Q*Q1;
    
else
    [U,D,U] = svd(Y*Y');
end

while iter<maxIter
    iter = iter + 1;
    if d > n
        tmp = 2*diag(D)/mu + ones(size(D,1),1);%(2*lambda/mu+1)*
        inv_tmp = tmp.^-1;
        temp_need_1 = U*(diag(inv_tmp)*(U'*(B+(2*Y*X'-T)/mu)));
        temp_need_2 = ((B+(2*Y*X'-T)/mu)-U*(U'*(B+(2*Y*X'-T)/mu)));
        P = temp_need_1 + temp_need_2;
        %P = U*(diag(inv_tmp)*(U'*(B+(2*Y*X'-T)/mu))) + ((B+(2*Y*X'-T)/mu)-U*(U'*(B+(2*Y*X'-T)/mu))); % 为了加快运算
    else
        tmp = 2*diag(D)/mu + ones(d,1);%(2*lambda/mu+1)*
        inv_tmp = tmp.^-1;
    %     inv_y = U*diag(inv_tmp)*U';
        P = U*(diag(inv_tmp)*(U'*(B+(2*Y*X'-T)/mu)));
    end

%     inv_y = inv(2*Y*Y'/mu+eye(d));
    %udpate P
%     P = (B+(2*A'*X*Y'-T)/mu)*inv_y;
    %update B

    W = P+T/mu;
    B = solve_l1l2(W,num,fdim,channel_num);
    

    leq = P-B;
    stopC =max(max(abs(leq)));
    if iter==1 || mod(iter,50)==0 || stopC<tol
        disp(['iter ' num2str(iter) ',mu=' num2str(mu,'%2.1e') ...
            ',stopALM=' num2str(stopC,'%2.3e')]);
    end
    if stopC<tol 
        disp('SSSR done.');
        break;
    else
        T = T + mu*leq;
        mu = min(max_mu,mu*rho);
    end
end
% tmp=P-B;

function [B] = solve_l1l2(W,num,fdim,channel_num)
n = size(W,2);
B = W;
%---------------------------
nWvector = sum(W.*W,2); % 按行求和
for i=1:num
    tmp = nWvector((i-1)*fdim+1:fdim*i);
    nW = sqrt(sum(tmp));
    Lambda(i)=nW;
end
[D,index] = sort(Lambda,'descend');
if channel_num < num
    lambda = Lambda(index(channel_num+1));
else
    lambda = 0;
end

for i = 1:num
    tmp = nWvector((i-1)*fdim+1:fdim*i);
    nW = sqrt(sum(tmp));
    nW_lambda = nW - lambda;
    if nW_lambda > 0
        B((i-1)*fdim+1:fdim*i,:) = W((i-1)*fdim+1:fdim*i,:)*(nW_lambda/nW);
    else
        B((i-1)*fdim+1:fdim*i,:) = zeros(fdim,size(B,2));
    end
end
