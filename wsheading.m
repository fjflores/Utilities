function wsheading( msg )
% Adds consecutive whitespace every call up to three.

persistent callCount;
if isempty( callCount )
    callCount = 0; % Initialize on first call
end

callCount = callCount + 1; % Increment call count
headingSpaces = repmat( ' ', 1, callCount ); % Create heading spaces
formattedMessage = [ headingSpaces, msg ]; % Prepend spaces to the message

disp( formattedMessage ); % Display the formatted message
