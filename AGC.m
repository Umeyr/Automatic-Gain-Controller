% split the frame into subframes containing 1024 elements
m = size(firoutdec,1);
n = m/1024;
n = floor(n);
signals = zeros(1024,n);

E = Energy_VAD( firoutdec, n );

Zcd = ZCD( firoutdec, n, E);

 VAr  = AVV( firoutdec, n );

for i = 1 : n
    for k = 1:1024
    signals(k,i) = firoutdec((i-1)*1024+k);
    end
end


%Calculation of the power of each subframe
pwr = zeros(1,n);
for i = 1:n
    pwr(i)=sum(signals(:,i).^2)/1024;
end


%256 subframe

signals_small = zeros(256,n*4);
for i = 1 : n*4
    for k = 1:256
    signals_small(k,i) = firoutdec((i-1)*256+k);
    end
end

signals_out_small = Gain_Control_Lastten_small( n, signals_small, Zcd);


signals_out_small_array = zeros(1, 256*n*4);
for i = 1 : n*4
    signals_out_small_array(1,(i-1)*256+1:i*256) =  signals_out_small(:,i);
end


%%%%%%%%%%%%%%5
%%%%%%%%%%%%%%%
%plots

figure % new figure
ax1 = subplot(3,1,1); % top subplot
ax2 = subplot(3,1,2); % bottom subplot
ax3 = subplot(3,1,3); % bottom subplot
%ax4 = subplot(5,1,4); % bottom subplot
%ax5 = subplot(5,1,5); % bottom subplot


plot(ax1,firoutdec)
title(ax1,'Input')
ylabel(ax1,'')

% plot(ax5,20*log10(M))
% title(ax5,'Peak value')
% ylabel(ax5,'')
% 
% plot(ax3,VAD_state,'.')
% title(ax3,'VAD')
% ylabel(ax3,'')
% 
% plot(ax4,pwr_db)
% title(ax4,'Input Power')
% ylabel(ax4,'db')



xaxiss = [256:256:1024*n];

plot(ax2,xaxiss,Zcd,'-o')
title(ax2,'VAD')
ylabel(ax2,' ')


% plot(ax2,signals_out_array,'-')
% title(ax2,'Output Signal')
% ylabel(ax2,' ')

plot(ax3,signals_out_small_array,'-')
title(ax3,'Output Signal')
ylabel(ax3,'')

% xaxis = [1024:1024:1024*n];
% plot(ax3,xaxis,Zcd,'-o')
% title(ax3,'Output Dyn')
% ylabel(ax3,'')


 

  
    