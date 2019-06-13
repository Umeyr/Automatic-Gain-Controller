
frame_size = 256;

m = size(firoutdec,1);
n = m/frame_size;
n = floor(n);
signals_ind = zeros(frame_size,n);


for i = 1 : n
    for k = 1:frame_size
    signals_ind(k,i) = firoutdec((i-1)*frame_size+k);
    end
end



frame = zeros(1, frame_size);

VAD = zeros( 1, n);
signals_out_ind = zeros(1, n*frame_size);


for i = 1 : n

frame = signals_ind(:,i);

frame = transpose(frame);

mean_frame = sum(frame(1,1:frame_size))/frame_size;

frame = frame - mean_frame;



E = Energy_VADind( frame, i );

Zcd = ZCDind( frame, E, i);

frame_out = Gain_Control_Lastten_ind( frame,Zcd, i );


VAD(i) = Zcd;
signals_out_ind((i-1)*frame_size+1:i*frame_size) = frame_out(1,:);
end

firoutdec = transpose(firoutdec);

xaxis = [frame_size:frame_size:frame_size*n];

figure % new figure
ax1 = subplot(2,1,1); % top subplot
ax2 = subplot(2,1,2); % bottom subplotplot(ax1,x,y1)

plot(ax1,firoutdec)
title(ax1,'Input signal')
ylabel(ax1,'amplitude)')

plot(ax2, signals_out_ind,'-r')
title(ax2,'VAD state Enerji')
ylabel(ax2,'Speech:1, Noise:0')


