function [CompoBond,Compostock, OptPrice ] = EuropeanBin(S0,K,EuPayoff,r,h,u,d,T)
% Binomial Tree for European option pricing
% Input: Spot S0, strike K, payoff function , interest rate r, 
% length of period h,  up and down factors u and d,number of periods T


%probability of up move
p=(exp(r*h)-d)/(u-d);

for i=1:T+1
    for j=i:T+1
        S(i,j) = S0*u^(j-i)*d^(i-1);   % Stock Price
    end
end

% Calculate Terminal Price for Calls and Puts
for i=1:T+1
    OptPrice(i,T+1) = EuPayoff(S(i,T+1),K);
end

% Calculate Remaining entries for Calls and Puts

for j=T:-1:1
    for i=1:j
    OptPrice(i, j) = exp(-r*h)*(p*OptPrice(i, j+1) + (1-p)*OptPrice(i+1, j+1));
    %  Calculate composition of replicating portfolio
    CompoBond(i,j)=exp(-r*h)*(u*OptPrice(i+1, j+1)-d*OptPrice(i, j+1))/(u-d);
    Compostock(i,j)=1/S(i,j)*(OptPrice(i, j+1)-OptPrice(i+1, j+1))/(u-d);
    end
end
     

end

