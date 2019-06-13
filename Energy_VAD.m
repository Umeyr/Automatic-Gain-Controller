function [ vad ] = Energy_VAD( Sin_array, size )
%UNTÝTLED2 Summary of this function goes here
%   Detailed explanation goes here

Sin_array = transpose(Sin_array);

for i = 1:size*4
    mean_sin = sum(Sin_array(1,(i-1)*256+1:i*256))/256;
    Sin_array(1,(i-1)*256+1:i*256) = Sin_array(1,(i-1)*256+1:i*256) - mean_sin;
end

%determine the mean and normalize the frame


E = zeros(1,size*4);


for i = 1:size*4
E(i) = sum((Sin_array(1,(i-1)*256+1:i*256)).^2)/256;
end

%E_ref = sum(E(1:12))/12;

vad = zeros(1,size*4);

E_lasts = zeros(1,20);

t = 1;

E_ref = 0;

for i = 1:size*4
    
    if i < 20
        E_ref = (E_ref * (i-1) + E(i))/i ;
%         if E(i) >= E_ref
%             vad(i) = 1;
%         end
    end
    
    if E(i) >= (2.3)*E_ref
        vad(i) = 1;
    else
        
        if t > 20
        
            %calculation of the variance
            mean_lasts = sum(E_lasts(:))/20;
            
            var1 = ((E_lasts - mean_lasts).^2)/20;
            
            R = rem(t,20);
            if R == 0
                R=20;
            end
            
            E_lasts(R) = E(i);
            
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
            
            
            E_ref = (1-p)*E_ref + p*E(i); 
        else
            R = rem(t,20);
            if R == 0
                R=20;
            end
            
            E_lasts(R) = E(i);
        end
          t = t + 1;
    end
end

xaxis = [256:256:1024*size];

figure % new figure
ax1 = subplot(2,1,1); % top subplot
ax2 = subplot(2,1,2); % bottom subplotplot(ax1,x,y1)

plot(ax1,Sin_array)
title(ax1,'Input signal')
ylabel(ax1,'amplitude)')

plot(ax2, xaxis, vad,'-or')
title(ax2,'VAD state Enerji')
ylabel(ax2,'Speech:1, Noise:0')




end


