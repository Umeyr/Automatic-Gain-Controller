function [ S_Out ] = Gain_Control_Lastten_small(size_sig, S_In,VAD )
%UNTÝTLED4 Summary of this function goes here
%   Detailed explanation goes here
subframe_size = size_sig;

S_Out = zeros(256,subframe_size*4);

        last_ten = zeros(1,20);
        lastten_count = 1;

for i = 1 : subframe_size*4
    if VAD(i) == 1 
        
        mean = sum(S_In(:,i))/256;
        
        S_Out(:,i) = S_In(:,i) - mean;
        

        %%%%%%%%%%%%%%%%
        R = rem(lastten_count,20);
        if R == 0
            R = 20;
        end
        last_ten(R) = max(abs(S_Out(:,i)));
        
        lastten_count = lastten_count + 1;
        %%%%%%%%%%%%%%%%%%%%
        
        S_Out(:,i) = S_Out(:,i)/ max(last_ten);
    end   
end


end




