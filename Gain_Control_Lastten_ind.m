function [ S_Out ] = Gain_Control_Lastten_ind( S_In,VAD, init )
%UNTÝTLED4 Summary of this function goes here
%   Detailed explanation goes here


size = length(S_In);

S_Out = zeros(1,size);

persistent lastten_count last_ten

if init == 1
     last_ten = zeros(1,20);
     lastten_count = 1;
else
    if VAD == 1 

        R = rem(lastten_count,20);
        if R == 0
            R = 20;
        end
        last_ten(R) = max(abs(S_In));
        
        lastten_count = lastten_count + 1;
        
        S_Out(1,:) = S_In(1,:)/ max(last_ten);
    end  
end
end




