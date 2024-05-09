clc;
clear all;
close all;

s = serialport("COM5", 115200);
message = "All laws in force in the territory of India immediately before the commencement of this Constitution, in so far as they are inconsistent with the provisions of this Part, shall, to the extent of such inconsistency, be void.";

imagePath = 'Sample50kb.jpg';
fileID = fopen(imagePath, 'rb');
imageBytes = fread(fileID, '*uint8');
fclose(fileID);
encodedBase64 = matlab.net.base64encode(imageBytes);
imageSize = size(imageBytes);

dataLength = length(encodedBase64);
inputString = encodedBase64;

splitSize = 248;
splitStrings = splitString(inputString, splitSize);

pause(2);

% Send the first packet immediately
writeline(s, splitStrings{1});

% Wait for confirmation from Arduino to send next packet
while ~s.NumBytesAvailable
    %pause(0.000000000000001);
end

% Loop through remaining packets
for i = 2:length(splitStrings)
    while s.NumBytesAvailable
        % Read and discard Arduino's confirmation signal
        readline(s);
    end
    
    writeline(s, splitStrings{i});
    
    % Wait for confirmation from Arduino to send next packet
    while ~s.NumBytesAvailable
        %pause(0.00001);
    end
end

disp("Data sent to Arduino.");

function splitStrings = splitString(inputString, splitSize)
    len = length(inputString);
    numSplits = ceil(len / splitSize);
    splitStrings = cell(1, numSplits);
    for i = 1:numSplits
        startIndex = (i - 1) * splitSize + 1;
        endIndex = min(i * splitSize, len);
        splitStrings{i} = inputString(startIndex:endIndex);
    end
end
