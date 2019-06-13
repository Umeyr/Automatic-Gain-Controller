function [ vadq ] = AVV( Sin_array, size )

Sin_array = transpose(Sin_array);

for i = 1:size*4
    mean_sin = sum(Sin_array(1,(i-1)*256+1:i*256))/256;
    Sin_array(1,(i-1)*256+1:i*256) = Sin_array(1,(i-1)*256+1:i*256) - mean_sin;
end

E = zeros(32,size*4);

for i = 1:size*4
    for h = 1:32
    E(h,i) = sum((Sin_array(1,(i-1)*256+(h-1)*8+1:(i-1)*256 + h*8)).^2)/8;
    end
end

Var = zeros(1,size*4);

for i = 1:size*4
    
    mean = sum(E(:,i))/32;
    
    Var(i) = sum(((E(:,i)-mean).^2))/32;
    
end

Var = sqrt(Var);

vadq = zeros(1,size*4);

Avv_ref = 0;

for i = 1:10
Avv_ref = sum(E(:,i)) + Avv_ref ;
end
Avv_ref = Avv_ref / 10;

%Avv_ref =  sum(E(:,1));



for i = 1:size*4
    if Var(i) > 0.05*Avv_ref
        vadq(i) = 1;
    else 
        Avv_ref = Avv_ref*0.9 + 0.1*sum( E(:,i));
    end
end

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
% plot(ax2, xaxis, vadq,'r-')
% title(ax2,'VAD state AVV')
% ylabel(ax2,'Speech:1, Noise:0')

end

