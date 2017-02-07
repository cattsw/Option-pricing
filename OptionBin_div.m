function[CompoBond,Compostock, EarlyE,OptPrice ] = OptionBin_div(Type,S0,K,OpPayoff,r,h,u,d,T,D,delta)

%Binomial Tree for  option pricing  with an underlying stock 
% paying a discrete-time dividend 

% Input: 
% Type of option: 'a'(American) or 'e'(European)
% Spot S0, strike K, payoff function Payoff, interest rate r
% length of period h,  up and down factors u and d,number of periods T

%probability of up move
p=(exp(r*h)-d)/(u-d);

% Stock Price
for i=1:T+1
    for j=i:T+1
        S(i,j) = S0*u^(j-i)*d^(i-1);    
    end
end

% Adjusted stock Price
adjusted_S = S;

for ( i=1:max(size(D)) ) 
    if (D(i)<=T)
        for j=D(i):T+1
        adjusted_S(:,j) =  adjusted_S(:,j)*(1-delta);
        end
    end
end

% Calculate Terminal Price for Calls and Puts

for i=1:T+1
    OptPrice(i,T+1) = OpPayoff(adjusted_S(i,T+1),K,0);
end

% Calculate Remaining entries for Calls and Puts
if (Type=='a')

for j=T:-1:1
    for i=1:j
      NoExercise= exp(-r*h)*(p*OptPrice(i, j+1) + (1-p)*OptPrice(i+1, j+1));
    OptPrice(i, j) = OpPayoff(adjusted_S(i, j), K,  NoExercise);
     if OptPrice(i, j)>NoExercise
        EarlyE(i,j)=1;  % determine early exercise dates
     end
     %  Calculate composition of replicating portfolio
    CompoBond(i,j)=exp(-r*h)*(u*OptPrice(i+1, j+1)-d*OptPrice(i, j+1))/(u-d);
    Compostock(i,j)=1/adjusted_S(i,j)*(OptPrice(i, j+1)-OptPrice(i+1, j+1))/(u-d);
    end
end
 if exist('EarlyE') ==0 
        EarlyE='No early exercise';
    end

elseif (Type=='e')
 
 for j=T:-1:1
    for i=1:j
    OptPrice(i, j) =  exp(-r*h)*(p*OptPrice(i, j+1) + (1-p)*OptPrice(i+1, j+1));
    CompoBond(i,j)=exp(-r*h)*(u*OptPrice(i+1, j+1)-d*OptPrice(i, j+1))/(u-d);
    Compostock(i,j)=1/adjusted_S(i,j)*(OptPrice(i, j+1)-OptPrice(i+1, j+1))/(u-d);
    end
 end   
EarlyE='Not applicable to European options'

end


