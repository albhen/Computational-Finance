function option_price_bin=BinomialpriceBarrierUODM(r,d,u,N,T,s,K,b)
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
