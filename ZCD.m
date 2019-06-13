function [ vad ] = ZCD( Sin_array, size, Energy )
%UNTÝTLED2 Summary of this function goes here
%   Detailed explanation goes here

Sin_array = transpose(Sin_array);

for i = 1:size*4
    mean_sin = sum(Sin_array(1,(i-1)*256+1:i*256))/256;
    Sin_array(1,(i-1)*256+1:i*256) = Sin_array(1,(i-1)*256+1:i*256) - mean_sin;
end

zcd = zeros(1,size*4);

for i = 1:size*4
    for u = 1:256
        if (i-1)*256+u+1 <= length(Sin_array)
            zcd(i) = zcd(i) + abs(sign(Sin_array(1,(i-1)*256+u))-sign(Sin_array(1,(i-1)*256+u+1)));
        end
    end
end
zcd = zcd/2;


zcd_mean = 0;
zero_count = 0;

for i = 1:size*4
    if Energy(i) == 0
        
        if i > 12 && zcd(i) > 1.4*zcd_mean
            Energy(i) = 1;
        end
        
        zcd_mean = zcd_mean * zero_count + zcd(i);
        zero_count = zero_count + 1;
        zcd_mean = zcd_mean / zero_count;
        
    end
    
end

vad = Energy;

% xaxis = [256:256:1024*size];
% 
% figure % new figure
% ax1 = subplot(2,1,1); % top subplot
% ax2 = subplot(2,1,2); % bottom subplotplot(ax1,x,y1)
% 
% plot(ax1,Sin_array)
% title(ax1,'Input signal')
% ylabel(ax1,'amplitude)')
% 
% plot(ax2, xaxis, zcd,'-r')
% title(ax2,'VAD state ZCD')
% ylabel(ax2,'Speech:1, Noise:0')



end

