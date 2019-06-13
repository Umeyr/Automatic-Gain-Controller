function [ vad ] = Energy_VADind( S_in, init )
%UNTÝTLED2 Summary of this function goes here
%   Detailed explanation goes here

% input S_in should be normalized and an array

persistent count E_ref E_lasts t

vad = 0;

size = length(S_in);


%Framýn enerjisi
E = sum((S_in(1,:)).^2)/size;

%initialize the values
if init == 1
    count = 1;
    E_ref = E;
    E_lasts = zeros(1,20);
    t = 1;
else
    if count < 20
        E_ref = (E_ref * (count-1) + E)/ (count );
        if E >= E_ref
            vad = 1;
        end
    end
     
    if E >= (2.5)*E_ref
        vad = 1;
    else
        if t > 20
            %calculation of the variance
            mean_lasts = sum(E_lasts(:))/20;
            
            var1 = ((E_lasts - mean_lasts).^2)/20;
            
            R = rem(t,20);
            if R == 0
                R=20;
            end
            
            E_lasts(R) = E;
            
            mean_lasts = sum(E_lasts(:))/20;
            
            var2 = ((E_lasts-mean_lasts).^2)/20;
            
            
            if  (var2/var1) >= (1.25)
                p = 0.25;
            elseif 1.25 >= var2/var1 && (var2/var1 >= 1.10)
                p = 0.20;
            elseif 1.10 >= var2/var1 && (var2/var1 >= 1)
                p = 0.15;
            elseif 1 >= var2/var1
                p = 0.1;
            end
            
            E_ref = (1-p)*E_ref + p*E;
        else
            R = rem(t,20);
            if R == 0
                R=20;
            end
            
            E_lasts(R) = E;
        end
         t = t + 1;
    end
    count = count + 1;   
        
end
end


