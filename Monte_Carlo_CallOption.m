function[PriceM,PriceCI]=Monte_Carlo_CallOption(S0,K,r,delta,sigma,T,N,Npath)
% Monte Carlo on an arithmetic average price Asian option
randn('seed',0)
 h = T/N;  %length of step

% simulate stock price paths
SPath = S0*exp((r-delta-0.5*sigma^2)*T+sigma*sqrt(T)*randn(Npath,1));

PayoffPath = exp(-r*T)*max(SPath-K,0);  % payoffs 
PriceM = mean(PayoffPath);
PriceSd = std(PayoffPath);
% 95% confidence interval
PriceCI= [PriceM-1.96*PriceSd/sqrt(Npath), PriceM+1.96*PriceSd/sqrt(Npath)];
end
