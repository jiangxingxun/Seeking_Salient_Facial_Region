function C = TransferISLSR(Ls,Xs,Xt,num,fdim,lambda,channel_num)

Lnew = [Ls,zeros(size(Ls,1),1)];
delta_Xst = mean(Xs,2) - mean(Xt,2); % mean(Xs,1) 列的平均 % mean(Xs,2) 行的平均
Xnew = [Xs,sqrt(lambda)*delta_Xst];
d = size(Xs,1); % size(Xs,1) 行的数目 size(Xs,2) 列的数目
c = size(Ls,1);
C = ones(d,c);
C = ALM_ISLSR_fixednum(Lnew,Xnew,C,num,fdim,channel_num);