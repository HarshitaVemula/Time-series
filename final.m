%copy of it is in copy1
clc
clear all
data = xlsread('Onions_price.xlsx');
%%
train=data(1:750,4);
test=data(750:length(data),4);
%%
ts = train;
N         =         length(ts) ;        % gives the length
mean_         =         mean(ts);           % gives the mean
[n1,n2]   =         size(ts);           % gives the shape
ts        =         ts-mean_*ones(n1,n2);
[m,Model,res]=PostulateARMA(ts,0.95, 3);
rss=res.^2;
a=[1 2 3]
s_= sum(rss)
var=sqrt(s_)/(N-19)
plot(res);

p_=ts-res;
plot(p_);
hold on
plot(ts);
legend('fitted values','actual values')
title('training data set')
xlabel('weeks')
ylabel('Price')
%%
plot(res,'black')
title('Residuals')
%%
figure();
autocorr(res,'NumLags',100,'NumSTD',2)




%%
%accuracy
i=1;
m=length(p_);
diff_pred=p_(2:m)-p_(1:m-1);
diff_actual=ts(2:m)-ts(1:m-1);
acc=0;

while i
    if sign(diff_pred(i))==sign(diff_actual(i))
        
        acc=acc+1;
    end
    i=i+1;
    if i>m-1
        break
    end
end

accuracy=acc/m;
%%
forecast_=forecast(Model,ts,20)+mean_*ones(20,1)
plot([p_(end)+mean_;forecast_])
hold on
plot([train(end);test(1:20)])
%%
impulse(Model,100)

%%

AR_Poly=Model.a;
MA_Poly=Model.c;
l=roots(AR_Poly); %Roots of the characteristic polynomial.
 
disp(l)


plot( real(l(:)), imag(l(:)),'r*');
hold on
grid on
 
d = 0:0.01:2*pi;
x1 =  1*cos(d);
y1 = 1*sin(d);
 
plot( x1,y1,'black');
title('AR Roots')
xlim([-2 2]);
ylim([-2 2]);
%%

ar=Model.a;
roots_ar=round(roots(ar),2);
theta=angle(roots_ar);
w=(2*pi)./theta;
abs_=abs(roots_ar);
%%
predicted=p_+mean_*ones(n1,n2);
actual_data=train;%actual 
predicted_data=predicted;%predicted
res=res;%residuals

i=1
while i 
    N=length(actual_data)
    [n1,n2]   =         size(actual_data); 
    m_=mean(actual_data)
    demeaned=actual_data-m_*ones(n1,n2)
    n_ar=length(AR_Poly)
    n_ma=length(MA_Poly)
    X=demeaned(N-n_ar+2:N)
    ats=res(N-n_ma+2:N)
    forecast_=-AR_Poly(2:n_ar)*flipud(X)+MA_Poly(2:n_ma)*flipud(ats)+m_;
    forecast_list(i)=forecast_

    %appending forecasts,actual and predicted values
    predicted_data=vertcat(predicted_data,forecast_);
    actual_data=vertcat(actual_data ,test(i));
    res=vertcat(res ,test(i)-forecast_);
    
    i=i+1;
    if i>=100
        plot(res);
        break
    end
end
%%

%%    
plot(predicted_data(800:849))
hold on 
plot(actual_data(800:849))
%accuracy
i=1;
k=forecast_list;
m=length(k);
diff_pred=k(2:m)-k(1:m-1);
k_=test(1:100)
diff_actual=k_(2:m)-k_(1:m-1);
acc=0;

while i
    if sign(diff_pred(i))==sign(diff_actual(i))
        
        acc=acc+1;
    end
    i=i+1;
    if i>m-1
        break
    end
end

accuracy=acc/m;
%%

