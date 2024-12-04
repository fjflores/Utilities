function wsheading( msg )
% Adds consecutive whitespace every call up to three.

persistent lastFunction;
persistent callCount;

if isempty(callCount)
    callCount = 0; % Initialize on first call
end

currentFunction = dbstack('-completenames', 1); % Get the name of the calling function
currentFunctionName = currentFunction.name;

if isempty(lastFunction) || ~strcmp(lastFunction, currentFunctionName)
    callCount = callCount + 1; % Increment call count only if from a different function
    lastFunction = currentFunctionName; % Update last function

end

if callCount <= 3
    headingSpaces = repmat( ' ',  1,  callCount); % Create heading spaces

end

formattedMessage = strcat( headingSpaces, msg ); % Prepend spaces to the message
disp(formattedMessage); % Display the formatted message

