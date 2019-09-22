%copy of it is in copy1
clc
clear all
data = xlsread('Onions_price.xlsx');
total=data(1:length(data),4);
plot(total);
%%
train=data(1:750,4);
test=data(750:length(data),4);
%%
%%
ts = train;
m         =         mean(ts);           % gives the mean
[n1,n2]   =         size(ts);           % gives the shape
ts        =         ts-m*ones(n1,n2);
%%
%%
%checking for parsimonious model -stochastic trend
N=length(ts);
yt=ts(2:N)-ts(1:N-1);

Model_yt=armax(yt,[1 1]);

res_yt=resid(Model_yt,yt)
res_yt=res_yt.y
predicted=predict(Model_yt,yt)+ts(1:N-1)+m*ones(n1-1,n2);

plot(res_yt)
%%