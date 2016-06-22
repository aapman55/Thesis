function [  ] = FourierPlaneFilter( image,  varargin)
%FOURIERPLANEIMAGE Takes an image and fourier transforms it. Then after
%applying the bounds to block off frequencies in the Fourier plane,
%reconstruct the image.
%
% Available parameters
% image - An image loaded using imgread
% filter- Defines the type of filter 'highpass' or 'lowpass'
% top   - How much from the top is being blocked (in percentage between 0 and 100)
% bot   - How much from the bot is being blocked (in percentage between 0 and 100)
% left  - How much from the left is being blocked (in percentage between 0 and 100)
% right - How much from the right is being blocked (in percentage between 0 and 100)
%

% Check the kind of image (monochrome or RGB)

if (size(image,3) == 1)
    isRGB = 0;
elseif (size(image,3) == 3)
    isRGB = 1;
else
    error('Image type is not supported!');
end

% Set default values for the variables
filter = 'lowpass';
top = 25;
bot = 25;
left = 25;
right = 25;

% Retrieve variables from the varargin

% Read out optional input
% Check if it is in the form 'property', 'value'
if (mod(length(varargin),2) ~= 0)
    error('Unbalanced input. Use format "property", "value"');
end

% loop over the arguments
for i=1:length(varargin)/2
    property = varargin{2*i-1};
    value = varargin{2*i};

    % Check property
    switch property
        % Filter
        case {'filter','Filter'}
            if (strcmp(value, 'lowpass') || strcmp(value, 'highpass'))
                filter = value;
            else
                error('Filter type can only be "lowpass" or "highpass"!');
            end
        %Top
        case {'top','Top'}
            if (isnumeric(value) && length(value) == 1)
                % Set top, automatically limit bouns between 0 and 100
                top = min(max(value,0),100);
                
                % Give warning when the input has changed
                if (top ~= value)
                    warning(['You input value for "top" was out of bounds and has been changed to: ',num2str(top)]);
                end
            else
                error('Please enter a correct number!');
            end
        %Bottom
        case {'bot','Bot'}
            if (isnumeric(value) && length(value) == 1)
                % Set top, automatically limit bouns between 0 and 100
                bot = min(max(value,0),100);
                
                % Give warning when the input has changed
                if (bot ~= value)
                    warning(['You input value for "bot" was out of bounds and has been changed to: ',num2str(bot)]);
                end
            else
                error('Please enter a correct number!');
            end
        %Left
        case {'left','Left'}
            if (isnumeric(value) && length(value) == 1)
                % Set top, automatically limit bouns between 0 and 100
                left = min(max(value,0),100);
                
                % Give warning when the input has changed
                if (left ~= value)
                    warning(['You input value for "top" was out of bounds and has been changed to: ',num2str(left)]);
                end
            else
                error('Please enter a correct number!');
            end
        %Right
        case {'right','Right'}
            if (isnumeric(value) && length(value) == 1)
                % Set top, automatically limit bouns between 0 and 100
                right = min(max(value,0),100);
                
                % Give warning when the input has changed
                if (right ~= value)
                    warning(['You input value for "top" was out of bounds and has been changed to: ',num2str(right)]);
                end
            else
                error('Please enter a correct number!');
            end
        otherwise
            error(['property ',property,' does not exist']);
    end                
end

% Perform calculations and plots
if(isRGB)
    RGB(image, filter, top, bot, left, right);
else
    monochrome(image, filter, top, bot, left, right, true);
end

end

function [fourierImage, blockedFourierImage, IF] = monochrome(im, Filter, Top, Bot, Left, Right, drawImage)
    top = Top/100;
    bottom = 1 - Bot/100;
    left = Left/100;
    right = 1 - Right/100;
    
    % Determine whether a low pass is requested
    if (strcmp(Filter, 'lowpass'))
        lowPass = 1;
    else
        lowPass = 0;
    end
    
    % Load image
    if (drawImage)
        figure(1)
        subplot(1,4,1);
        imshow(im)
        title('Original image');
    end

    % Fourier transform
    f = fft2(double(im));

    % Recenter fft
    F = fftshift(f);

    % Take absolute value
    S = abs(F);

    % Show Fourier image
    fourierImage = log(1+S);
    if (drawImage)
        subplot(1,4,2)
        imshow(fourierImage,[]);
        title('Fourier image');
    end

    % Cut out part of frequency
    % Get the indices
    END = size(F);
    
    topindex = floor(END(1)*top);
    botindex = ceil(END(1)*bottom);
    leftindex= floor(END(2)*left);
    rightindex = ceil(END(2)*right);
    
    if (lowPass)
        if (topindex ~= 0)
            F(1:topindex,1:end) = zeros(size(F(1:topindex,1:end)));
        end
        
        if (botindex ~= END(1))
            F(botindex:end,1:end) = zeros(size(F(botindex:end,1:end)));
        end
        
        if (leftindex ~= 0)
            F(1:end,1:leftindex) = zeros(size(F(1:end,1:leftindex)));
        end
        
        if (rightindex ~= END(2))
            F(1:end, rightindex:end) = zeros(size(F(1:end, rightindex:end)));
        end
    else
        % For high pass filtering the indices need to be adjusted
        topindex = max(1, topindex);
        leftindex = max(1, leftindex);
        
        F(topindex:botindex,leftindex:rightindex) = zeros(size(F(topindex:botindex,leftindex:rightindex)));
    end

    % Take absolute value
    S = abs(F);

    % Show Fourier image
    blockedFourierImage = log(1+S);
    if (drawImage)
        subplot(1,4,3)
        imshow(blockedFourierImage,[]);
        title('Fourier image band passed');
    end

    % Inverse fourier transform
    I = ifftshift(F);
    IF = ifft2(I);
    
    if (drawImage)
        subplot(1,4,4)
        imshow(abs(IF),[]);
        title('Inverse Fourier image');
    end
end

function RGB(image, filter, top, bot, left, right)
    red = image(:,:,1);
    green = image(:,:,2);
    blue = image(:,:,3);
    
    % Fourier transfer all 3 parts
    [fourierImageRed, blockedFourierImageRed, IFRed] = monochrome(red, filter, top, bot, left, right, false);
    [fourierImageGreen, blockedFourierImageGreen, IFGreen] = monochrome(green, filter, top, bot, left, right, false);
    [fourierImageBlue, blockedFourierImageBlue, IFBlue] = monochrome(blue, filter, top, bot, left, right, false);
    
    colored(:,:,1) = IFRed;
    colored(:,:,2) = IFGreen;
    colored(:,:,3) = IFBlue;
    
    % Show original colored image and altered colored image
    figure
    subplot(1,2,1)
    imshow(image);
    subplot(1,2,2)
    imshow(uint8(abs(colored)));
    title('Band passed of original')
    
    % Show red portion
    plotPartialImage(red, fourierImageRed, blockedFourierImageRed, IFRed, 'red');
    
    % Show green portion
    plotPartialImage(green, fourierImageGreen, blockedFourierImageGreen, IFGreen, 'green');
    
    % Show blue portion
    plotPartialImage(blue, fourierImageBlue, blockedFourierImageBlue, IFBlue, 'blue');
end

function plotPartialImage(image, fourierImage, blockedFourierImage, IF, name)
    figure
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    
    subplot(1,4,1)
    imshow(image,[]);
    title(['Original image ',name]);
    
    subplot(1,4,2)
    imshow(fourierImage,[]);
    title(['Fourier image ',name]);
    
    subplot(1,4,3)
    imshow(blockedFourierImage,[]);
    title(['Fourier image ',name,' band pass']);
    
    subplot(1,4,4)
    imshow(abs(IF),[]);
    title(['Inverse Fourier image ',name]);
end


