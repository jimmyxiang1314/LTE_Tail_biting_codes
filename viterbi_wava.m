%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Viterbi Decoding for tailbiting codes
%   Based on WAVA from the paper "On two algorithms for tailbiting codes"
%              -----------------                  
%   Author: Dama Sreekanth            
%                                                 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ipHat_v] = viterbi_wava(y,iter)

% Viterbi decoding
LUT = [zeros(64,32) ones(64,32)];
ref_soft = [0.707106781186548,0.707106781186548,0.707106781186548;-0.707106781186548,-0.707106781186548,-0.707106781186548;-0.707106781186548,0.707106781186548,0.707106781186548;0.707106781186548,-0.707106781186548,-0.707106781186548;0.707106781186548,0.707106781186548,-0.707106781186548;-0.707106781186548,-0.707106781186548,0.707106781186548;-0.707106781186548,0.707106781186548,-0.707106781186548;0.707106781186548,-0.707106781186548,0.707106781186548;-0.707106781186548,-0.707106781186548,0.707106781186548;0.707106781186548,0.707106781186548,-0.707106781186548;0.707106781186548,-0.707106781186548,0.707106781186548;-0.707106781186548,0.707106781186548,-0.707106781186548;-0.707106781186548,-0.707106781186548,-0.707106781186548;0.707106781186548,0.707106781186548,0.707106781186548;0.707106781186548,-0.707106781186548,-0.707106781186548;-0.707106781186548,0.707106781186548,0.707106781186548;-0.707106781186548,-0.707106781186548,-0.707106781186548;0.707106781186548,0.707106781186548,0.707106781186548;0.707106781186548,-0.707106781186548,-0.707106781186548;-0.707106781186548,0.707106781186548,0.707106781186548;-0.707106781186548,-0.707106781186548,0.707106781186548;0.707106781186548,0.707106781186548,-0.707106781186548;0.707106781186548,-0.707106781186548,0.707106781186548;-0.707106781186548,0.707106781186548,-0.707106781186548;0.707106781186548,0.707106781186548,-0.707106781186548;-0.707106781186548,-0.707106781186548,0.707106781186548;-0.707106781186548,0.707106781186548,-0.707106781186548;0.707106781186548,-0.707106781186548,0.707106781186548;0.707106781186548,0.707106781186548,0.707106781186548;-0.707106781186548,-0.707106781186548,-0.707106781186548;-0.707106781186548,0.707106781186548,0.707106781186548;0.707106781186548,-0.707106781186548,-0.707106781186548;0.707106781186548,-0.707106781186548,-0.707106781186548;-0.707106781186548,0.707106781186548,0.707106781186548;-0.707106781186548,-0.707106781186548,-0.707106781186548;0.707106781186548,0.707106781186548,0.707106781186548;0.707106781186548,-0.707106781186548,0.707106781186548;-0.707106781186548,0.707106781186548,-0.707106781186548;-0.707106781186548,-0.707106781186548,0.707106781186548;0.707106781186548,0.707106781186548,-0.707106781186548;-0.707106781186548,0.707106781186548,-0.707106781186548;0.707106781186548,-0.707106781186548,0.707106781186548;0.707106781186548,0.707106781186548,-0.707106781186548;-0.707106781186548,-0.707106781186548,0.707106781186548;-0.707106781186548,0.707106781186548,0.707106781186548;0.707106781186548,-0.707106781186548,-0.707106781186548;0.707106781186548,0.707106781186548,0.707106781186548;-0.707106781186548,-0.707106781186548,-0.707106781186548;-0.707106781186548,0.707106781186548,0.707106781186548;0.707106781186548,-0.707106781186548,-0.707106781186548;0.707106781186548,0.707106781186548,0.707106781186548;-0.707106781186548,-0.707106781186548,-0.707106781186548;-0.707106781186548,0.707106781186548,-0.707106781186548;0.707106781186548,-0.707106781186548,0.707106781186548;0.707106781186548,0.707106781186548,-0.707106781186548;-0.707106781186548,-0.707106781186548,0.707106781186548;0.707106781186548,-0.707106781186548,0.707106781186548;-0.707106781186548,0.707106781186548,-0.707106781186548;-0.707106781186548,-0.707106781186548,0.707106781186548;0.707106781186548,0.707106781186548,-0.707106781186548;0.707106781186548,-0.707106781186548,-0.707106781186548;-0.707106781186548,0.707106781186548,0.707106781186548;-0.707106781186548,-0.707106781186548,-0.707106781186548;0.707106781186548,0.707106781186548,0.707106781186548;-0.707106781186548,-0.707106781186548,-0.707106781186548;0.707106781186548,0.707106781186548,0.707106781186548;0.707106781186548,-0.707106781186548,-0.707106781186548;-0.707106781186548,0.707106781186548,0.707106781186548;-0.707106781186548,-0.707106781186548,0.707106781186548;0.707106781186548,0.707106781186548,-0.707106781186548;0.707106781186548,-0.707106781186548,0.707106781186548;-0.707106781186548,0.707106781186548,-0.707106781186548;0.707106781186548,0.707106781186548,-0.707106781186548;-0.707106781186548,-0.707106781186548,0.707106781186548;-0.707106781186548,0.707106781186548,-0.707106781186548;0.707106781186548,-0.707106781186548,0.707106781186548;0.707106781186548,0.707106781186548,0.707106781186548;-0.707106781186548,-0.707106781186548,-0.707106781186548;-0.707106781186548,0.707106781186548,0.707106781186548;0.707106781186548,-0.707106781186548,-0.707106781186548;0.707106781186548,0.707106781186548,0.707106781186548;-0.707106781186548,-0.707106781186548,-0.707106781186548;-0.707106781186548,0.707106781186548,0.707106781186548;0.707106781186548,-0.707106781186548,-0.707106781186548;0.707106781186548,0.707106781186548,-0.707106781186548;-0.707106781186548,-0.707106781186548,0.707106781186548;-0.707106781186548,0.707106781186548,-0.707106781186548;0.707106781186548,-0.707106781186548,0.707106781186548;-0.707106781186548,-0.707106781186548,0.707106781186548;0.707106781186548,0.707106781186548,-0.707106781186548;0.707106781186548,-0.707106781186548,0.707106781186548;-0.707106781186548,0.707106781186548,-0.707106781186548;-0.707106781186548,-0.707106781186548,-0.707106781186548;0.707106781186548,0.707106781186548,0.707106781186548;0.707106781186548,-0.707106781186548,-0.707106781186548;-0.707106781186548,0.707106781186548,0.707106781186548;-0.707106781186548,0.707106781186548,0.707106781186548;0.707106781186548,-0.707106781186548,-0.707106781186548;0.707106781186548,0.707106781186548,0.707106781186548;-0.707106781186548,-0.707106781186548,-0.707106781186548;-0.707106781186548,0.707106781186548,-0.707106781186548;0.707106781186548,-0.707106781186548,0.707106781186548;0.707106781186548,0.707106781186548,-0.707106781186548;-0.707106781186548,-0.707106781186548,0.707106781186548;0.707106781186548,-0.707106781186548,0.707106781186548;-0.707106781186548,0.707106781186548,-0.707106781186548;-0.707106781186548,-0.707106781186548,0.707106781186548;0.707106781186548,0.707106781186548,-0.707106781186548;0.707106781186548,-0.707106781186548,-0.707106781186548;-0.707106781186548,0.707106781186548,0.707106781186548;-0.707106781186548,-0.707106781186548,-0.707106781186548;0.707106781186548,0.707106781186548,0.707106781186548;0.707106781186548,-0.707106781186548,-0.707106781186548;-0.707106781186548,0.707106781186548,0.707106781186548;-0.707106781186548,-0.707106781186548,-0.707106781186548;0.707106781186548,0.707106781186548,0.707106781186548;0.707106781186548,-0.707106781186548,0.707106781186548;-0.707106781186548,0.707106781186548,-0.707106781186548;-0.707106781186548,-0.707106781186548,0.707106781186548;0.707106781186548,0.707106781186548,-0.707106781186548;-0.707106781186548,0.707106781186548,-0.707106781186548;0.707106781186548,-0.707106781186548,0.707106781186548;0.707106781186548,0.707106781186548,-0.707106781186548;-0.707106781186548,-0.707106781186548,0.707106781186548;-0.707106781186548,0.707106781186548,0.707106781186548;0.707106781186548,-0.707106781186548,-0.707106781186548;0.707106781186548,0.707106781186548,0.707106781186548;-0.707106781186548,-0.707106781186548,-0.707106781186548];

% ref_main = [0 0 0;1 1 1;1 0 0;0 1 1;0 0 1;1 1 0;1 0 1;0 1 0]; 
% ref_1 = [ref_main;double(xor(ref_main,kron([1 1 0],ones(size(ref_main,1),1))))];
% ref_2 = [ref_1;double(xor(ref_1,kron([1 1 1],ones(size(ref_1,1),1))))];
% ref_3 = [ref_2;double(xor(ref_2,kron([0 1 1],ones(size(ref_2,1),1))))];
% ref_last1 = [ref_3;double(xor(ref_3,kron([1 1 1],ones(size(ref_3,1),1))))];
%ref_soft=1/sqrt(2)*(ones(size(ref_last1))-2*ref_last1);
%ref_soft=1/sqrt(2)*(ones(size(ref_last))-2*ref_last);
   state_trellis = zeros(64,length(y)/3+1);
   path_surv = zeros(64,length(y)/3);
    ipHat_v = zeros(1,length(y)/3);
    ipHat = zeros(64,(length(y)/3));
   for tt=1:iter
   for ii = 1:size(y,2)/3
       
      r = y(3*ii-2:3*ii); % taking 3 coded bits
      
      
      % computing the Euclidian distance distance between ip coded sequence with [00x;x01;x10;x11]
      rv = kron(ones(128,1),r);
      euclidianDist = sum((rv.*ref_soft),2);
      for jj = 1:32
                    % state 1-32
%           bm1 = euclidianDist(2*jj-1)-euclidianDist(64+2*jj-1)+state_trellis(2*jj-1,ii);
%           bm2 = euclidianDist(2*jj)-euclidianDist(64+2*jj)+state_trellis(2*jj,ii);
          bm1 = euclidianDist(2*jj-1)+state_trellis(2*jj-1,ii);
          bm2 = euclidianDist(2*jj)+state_trellis(2*jj,ii);
          [state_trellis(jj,ii+1), idx] = max([bm1,bm2]);
          path_surv(jj,ii) = idx+2*(jj-1);
      end
                    % states 33-64
      for jj = 1:32
%           bm1 = euclidianDist(64+2*jj-1)-euclidianDist(2*jj-1)+state_trellis(2*jj-1,ii);
%           bm2 = euclidianDist(64+2*jj)-euclidianDist(2*jj)+state_trellis(2*jj,ii);
          bm1 = euclidianDist(64+2*jj-1)+state_trellis(2*jj-1,ii);
          bm2 = euclidianDist(64+2*jj)+state_trellis(2*jj,ii);
          
          [state_trellis(32+jj,ii+1), idx] = max([bm1,bm2]);
          path_surv(32+jj,ii) = idx+2*(jj-1);
      end

   end
   [~, currState1] = max(state_trellis(:,length(y)/3+1));
   currState = currState1;
   
   for jj = length(y)/3:-1:1
      prevState =  path_surv(currState,jj); 
      ipHat_v(jj) = int32(LUT(prevState,currState));
      currState = prevState;
   end
   if currState==currState1;%path_surv(currState1,1)
        %fprintf( 'ML is Tailbiting\n');
       break
   end
   state_trellis(:,1)=state_trellis(:,length(y)/3+1);
   t=0;tail_bp = zeros(1,64);
   if (tt==iter)
       for kk=1:64
   currState = kk;
   for jj = (length(y)/3):-1:1
      prevState =  path_surv(currState,jj); 
      ipHat(kk,jj) = LUT(prevState,currState);
      currState = prevState;
   end
   if currState==kk
        t=t+1;
       tail_bp(t) =kk; 
   end
   if (t~=0)
       [~,indexx] = max(state_trellis(tail_bp(1:t),length(y)/3+1));
       ipHat_v=ipHat(tail_bp(indexx),:);
       
   end
   %check the tail biting paths
   % make a list and find the best among them
       end
   end
   end
%     % trace back unit
%     [~, currState1] = max(state_trellis(:,length(y)/3+1));
%    
%     currState = currState1;
%    ipHat_v = zeros(1,length(y)/3);
%    for jj = length(y)/3:-1:1
%       prevState =  path_surv(currState,jj); 
%       ipHat_v(jj) = LUT(prevState,currState);
%       currState = prevState;
%    end