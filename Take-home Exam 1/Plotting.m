close all
r=.1;
S=1;
T=.5;
K=.9;
sigma=.1;
b=1.3;
N_time=100;
N_sim=10^6;
MC_price=MCpriceBarrierUOD(r,sigma,N_time,N_sim,T,S,K,b);
Bin_price=zeros(100,1);

for i=1:100
    u=1+r*T/(i*2)+sigma*sqrt(T/(i*2));
    d=u-2*sigma*sqrt(T/(i*2));
    Bin_price(i)=BinomialpriceBarrierUOD(r,d,u,i*2,T,S,K,b);
end
x=2*(1:100);

plot(x,[Bin_price,MC_price*ones(100,1)])
ylabel('Price')
xlabel('N')
legend('Binomial pricing model','MC pricing')

function option_price_bin=BinomialpriceBarrierUOD(r,d,u,N,T,s,K,b)
r=r*T/N;
q_u=(1+r-d)/(u-d);
q_d=1-q_u;
prices=zeros(N+1,1);


for i = 0:N
    S_T = s*u^i*d^(N-i);
    if S_T < b 
        prices(i+1) = max(S_T-K,0);
    else 
        prices(i+1) = 0;
    end
end

for k = (N-1):-1:N/2
    price_k = zeros(k+1,1); 
    for i = 1:k+1
        price_k(i) =(q_u*prices(i+1) + q_d*prices(i))/(1+r);
    end
    prices = price_k;
end
prices;
for i = 0:N/2
    price_T_2 =d^(N-i)*u^i*s;

    if price_T_2 > b
        prices(i+1) = 0;
    end
end

for k = (N/2-1):-1:0
    price_k = zeros(k+1,1); 
    for i = 1:k+1
        price_k(i) = (q_u*prices(i+1) + q_d*prices(i))/(1+r);
    end
    prices = price_k;
end
option_price_bin=prices;
end


function option_price_BS = MCpriceBarrierUOD(r,sigma,N_time,N_sim,T,s,K,b)
dt = T/N_time;      

S = s*ones(N_sim,1);

for i = 1:N_time/2
    Z = randn(N_sim,1); 
    S = S.*(1 + r*dt + Z*sigma*sqrt(dt));
end

T_2 = S < b;

for i = (N_time/2+1):N_time
    Z = randn(N_sim,1); 
    S = S.*(1 + r*dt + Z*sigma*sqrt(dt));
end


T_1 = S < b;
payoff=0;
for i=1:N_sim

    if T_2(i) && T_1(i)
    payoff =payoff+ max(S(i)-K,0);
    end
end

option_price_BS = exp(-r*T)*payoff/N_sim;
end
