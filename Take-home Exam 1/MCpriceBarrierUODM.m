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
