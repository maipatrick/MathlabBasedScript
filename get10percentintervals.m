function [y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11] = get10percentintervals(DATA, mass)
if nargin == 1
    DATAlong = fit_sw(DATA, zeros(1,1000));
    y1 = mean(DATAlong(1:100));
    y2 = mean(DATAlong(101:200));
    y3 = mean(DATAlong(201:300));
    y4 = mean(DATAlong(301:400));
    y5 = mean(DATAlong(401:500));
    y6 = mean(DATAlong(501:600));
    y7 = mean(DATAlong(601:700));
    y8 = mean(DATAlong(701:800));
    y9 = mean(DATAlong(801:900));
    y10 = mean(DATAlong(901:1000));
    y11 = mean(DATAlong);
end

if nargin == 2
    DATAlong = fit_sw_sw_sw(DATA, zeros(1,1000));
    y1 = mean(DATAlong(1:100))/mass;
    y2 = mean(DATAlong(101:200))/mass;
    y3 = mean(DATAlong(201:300))/mass;
    y4 = mean(DATAlong(301:400))/mass;
    y5 = mean(DATAlong(401:500))/mass;
    y6 = mean(DATAlong(501:600))/mass;
    y7 = mean(DATAlong(601:700))/mass;
    y8 = mean(DATAlong(701:800))/mass;
    y9 = mean(DATAlong(801:900))/mass;
    y10 = mean(DATAlong(901:1000))/mass;
    y11 = mean(DATAlong)/mass;
end