function pos = segment(input, start, stop, threshold)
%{ 
find the transitions in input sequence and lists the points where
transitions occur in a struct field called segs

start - start of useful data 
stop - end of useful data
threshold - used for finding transition (jumps) in the data
%}


%% Find Transitions In Input
% find discrete derivative of Input by finding difference between points
shiftInput = circshift(input, 1); % shift normal force array
shiftInput(1) = input(1); % eliminate first point which was last index
dInput = input - shiftInput; % subtract previous points from following points

% find transitions where derivative exceeds threshold
jumps = abs(dInput) > threshold; % transition positions in binary
dInput = jumps.*dInput; % derivative at transition positions
pos = find(abs(dInput) > 0); % positions where transitions occur

% remove positions that come before and after useful data
temp = (pos >= start) & (pos <= stop);
pos = pos(temp);

%{
hold all
plot(input)
scatter(pos, input(pos))
%}

end