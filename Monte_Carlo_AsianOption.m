function[PriceM,PriceSd,PriceCI]=Monte_Carlo_AsianOption(S0,K,r,sigma,T,N,Npath)
% Monte Carlo on an arithmetic average price Asian option
randn('seed',0)
 h = T/N;  %length of step

% simulate stock price paths
Spath = S0*cumprod(exp((r-0.5*sigma^2)*h+sigma*sqrt(h)*randn(Npath,N)),2);

AriPath = mean(Spath,2);
PayoffPath = exp(-r*T)*max(AriPath-K,0);  % payoffs 
PriceM = mean(PayoffPath);
PriceSd = std(PayoffPath);
% 95% confidence interval
PriceCI= [PriceM-1.96*PriceSd/sqrt(Npath), PriceM+1.96*PriceSd/sqrt(Npath)];
end



