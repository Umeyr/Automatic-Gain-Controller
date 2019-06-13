function [ vad ] = ZCDind( Sin_array, Energy, init )
% input S_in should be normalized and an array
%Energy is the vad value of the current frame in terms of its energy


size = length(Sin_array);

zcd = 0;

    for u = 1:size
        if u+1 <= size
            zcd = zcd + abs(sign(Sin_array(1,u))-sign(Sin_array(1,u+1)));
        end
    end
    
zcd = zcd/2;

persistent zcd_mean zero_count frame_count


if init == 1
    zcd_mean = 0;
    zero_count = 0;
    frame_count = 0;
else
    frame_count = frame_count + 1;
    if Energy == 0
    
        zcd_mean = zcd_mean * zero_count + zcd;
        zero_count = zero_count + 1;
        zcd_mean = zcd_mean / zero_count;
        
        if (frame_count > 5) 
            if zcd > 1.4*zcd_mean
            Energy = 1;
            end
        end
        
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
% plot(ax2, xaxis, vad,'-r')
% title(ax2,'VAD state ZCD')
% ylabel(ax2,'Speech:1, Noise:0')



end

