function[CompoBond,Compostock,EarlyE, OptPrice ] = AmericanBin(S0,K,AmPayoff,r,h,u,d,T)
%Binomial Tree for American option pricing
% Input: Spot S0, strike K, payoff function , interest rate r, 
% length of period h,  up and down factors u and d,number of periods T

%probability of up move
p=(exp(r*h)-d)/(u-d);

for i=1:T+1
    for j=i:T+1
        S(i,j) = S0*u^(j-i)*d^(i-1);     % Stock Price
    end
end

% Calculate Terminal Price for Calls and Puts
for i=1:T+1
    OptPrice(i,T+1) = AmPayoff(S(i,T+1),K,0);
end

% Calculate Remaining entries for Calls and Puts

for j=T:-1:1
    for i=1:j
     NoExercise=exp(-r*h)*(p*OptPrice(i, j+1) + (1-p)*OptPrice(i+1, j+1));
    OptPrice(i, j) = AmPayoff(S(i, j), K, NoExercise);
    
    if OptPrice(i, j)>NoExercise
        EarlyE(i,j)=1;  % determine early exercise dates
    end
     %  Calculate composition of replicating portfolio
    CompoBond(i,j)=exp(-r*h)*(u*OptPrice(i+1, j+1)-d*OptPrice(i, j+1))/(u-d);
    Compostock(i,j)=1/S(i,j)*(OptPrice(i, j+1)-OptPrice(i+1, j+1))/(u-d);
    end
end
    if exist('EarlyE') ==0 
        EarlyE='No early exercise';
    end
end

