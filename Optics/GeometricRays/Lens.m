classdef Lens < handle
    %LENS This class represents an optical lens with certain focal length
    % It is able to compute the image of an object at distance do
    
    properties (SetAccess = private)
        f;              %   focal length                    [m]
        x;              %   x-location of the lens          [m]
        height;         %   height of the lens              [m]
        O;              %   Object placed in front of the lens
        computedImage;  %   The computed image  
        di;             %   Image distance                  [m]    
        do;             %   Object distance
    end
    
    methods
       %========================================
       % Constructor to initialise the lens
       %========================================
        function obj = Lens(f, x, height)
           obj.f = f; 
           obj.x = x; 
           obj.height = height; 
        end
        
       %========================================
       % Place an object in front of the lens
       %========================================
        function setObject(obj, O)
           % Check if the input object really is a LensObject
           if (~isa(O, 'LensObject'))
               error('You did not insert a "LensObject" object!');
           end
           
           % Check if the x-locations do not coindicide (lens and object)
           if (obj.x == O.x)
               error('The location of the lens and object coincide!');
           end
           
           % Passed all tests! Set the object.
           obj.O = O; 
           
           % Determine object distance
           obj.do = obj.x - obj.O.x;
               
           % Clear the computed image
           obj.computedImage = [];
           obj.di = [];
        end
        
       %========================================
       % Compute the image location
       %========================================
        function computeImage(obj)
           % Check if a LensObject is set
           if(isempty(obj.O))
               error('You have not set a LensObject yet!')
           end
           
           % If the rays are normal rays (not from infinity)
           if(abs(obj.O.x) ~= inf)             
                       
              % Calculate the image distance
               obj.di = Lens.lensFormulaToImageDistance(obj.f*sign(obj.do), obj.do);
               if (abs(obj.f - obj.do) < eps && obj.O.height == 0)
                   % Calculate the image height 
                   hi = tand(obj.O.infinityAngle) * obj.f;
               else
                   % Calculate the image height
                   hi = Lens.imageDistanceToImageHeight(obj.do, obj.di, obj.O.height);
               end
              % Calculate the exact x-coordinate of the image
               xi = obj.x + obj.di;

           else
               % There is no sound object distance
               % The image distance is the focal point
               obj.di = obj.f*sign(obj.do);
               % Image height depends on the infinityAngle
               hi = tand(obj.O.infinityAngle)*obj.di;
              % Calculate the exact x-coordinate of the image
               xi = obj.x + obj.di;
           end
           
           % Due to numerical precision infinity will not always be
           % infinity, so every number larger than 1E9 will be set to
           % infinity
           if(abs(xi) > 1E9)
               xi = sign(xi)*inf;
           end

           % Set the image object
           obj.computedImage = LensImage(xi, hi, atand(-obj.O.height/obj.f*sign(obj.do)));
        end
        
       %========================================
       % Draw the light ray diagram
       %========================================
        function handles = draw(obj, varargin)
            
            % Default variable values
            rayColor = 'magenta';
            rayWidth = 1;
            
            % Read out optional input
            % Check if it is in the form 'property', 'value'
            
            if (mod(length(varargin),2) ~= 0)
                error('Unbalanced input. Use format "property", "value"');
            end
            
            %loop over the arguments
            for i=1:length(varargin)/2
                property = varargin{2*i-1};
                value = varargin{2*i};
                
                % Check property
                switch property
                    case {'rayColor','raycolor'}
                        rayColor = value;
                    case {'rayWidth','raywidth'}
                        rayWidth = value;
                    otherwise
                        error(['property ',property,' does not exist']);
                end                
            end
            
            hold on;
            grid minor;
           % Draw the object if there is an object
           if (isempty(obj.O))
               error('There is no LensObject set!');
           end
           
           lensObjectHandle = obj.O.draw();
           
           % Draw the image if there is an image
           if (isempty(obj.computedImage))
               error('There is no LensImage computed!');
           end
           
           lensImageHandle = obj.computedImage.draw();
           
           % Draw the lens itself
           plot([obj.x,obj.x],[-0.5*obj.height, 0.5*obj.height],'color',[0,0,0],'linewidth',2)
           
           % Write the focal length of the lens on top
           text(obj.x, 0.6*obj.height, ['f = ',num2str(obj.f)]);
           
           % Draw lens focal points
           focalPointsHandle = scatter([obj.x-obj.f, obj.x+obj.f],[0,0],'markerfacecolor','k');
           
           % Draw optical axis
           plot([obj.O.x,obj.computedImage.x],[0,0],'color',[0,0,0])
            
           % Draw geometric optic rays
           
           % Calculate at which height the object ray hits the lens
           if (obj.O.height ~= 0 && abs(obj.O.x) ~= inf && obj.do ~= obj.f*sign(obj.do))
               
               % Round of do-obj.f
               do_objf = round(obj.do - obj.f*sign(obj.do), 8, 'decimals');
               slope1 = -obj.O.height/(do_objf);
               objectRayFocalPointHitLensHeight = obj.f*slope1*sign(obj.do);               
           elseif (abs(obj.O.x) == inf || obj.do == obj.f*sign(obj.do))
               objectRayFocalPointHitLensHeight = obj.O.height;
           else
               objectRayFocalPointHitLensHeight = obj.do*tand(obj.O.infinityAngle);
           end
           
           % Define how much you want to draw the infinity rays
           dX = obj.f*sign(obj.do);
           
           %========================================
           % Object side
           %========================================
           
           % 1) From object horizontally to lens
           if (abs(obj.O.x) == inf)
               Xvec = [obj.x - dX, obj.x];
               Yvec = [obj.O.height, obj.O.height];
           else
               Xvec = [obj.O.x, obj.x];
               Yvec = [obj.O.height, obj.O.height];
           end
           
           plot(Xvec,Yvec,'color',rayColor,'lineWidth',rayWidth);
           
           % 2) From object to center of optic lens
           Xvec = [obj.O.x, obj.x];
           Yvec = [obj.O.height, 0];

           geometricalRaysHandle = plot(Xvec, Yvec,'color',rayColor,'lineWidth',rayWidth);
           
           
           % 3) From object through focal point at the side of the object
           % continuing to the lens     
           if (abs(obj.O.x) == inf)
               Xvec = [obj.x - dX, obj.x];
               Yvec = [0, dX*tand(obj.O.infinityAngle)];
           else
               Xvec = [obj.O.x, obj.x];
               Yvec = [obj.O.height, objectRayFocalPointHitLensHeight];
           end
           
           plot(Xvec, Yvec,'color',rayColor,'lineWidth',rayWidth);
           
           %========================================
           % Image side
           %========================================
           lineStyle = '-';
           imaginary = false;
           % Check if the rays are imaginary
           if (obj.di*obj.do < 0)
               lineStyle = '--';
               imaginary = true;
           end
           
           % 4) From lens to image through focal point       
           
           if (abs(obj.computedImage.x) == inf)
               Xvec = [obj.x, obj.x + dX];
               Yvec = [objectRayFocalPointHitLensHeight, objectRayFocalPointHitLensHeight + dX * tand(obj.computedImage.infinityAngle)];               
           elseif (obj.O.height == 0)
               Xvec = [obj.x, obj.computedImage.x];
               Yvec = [objectRayFocalPointHitLensHeight, obj.computedImage.height];              
           else
               Xvec = [obj.x, obj.computedImage.x];
               Yvec = [obj.O.height, obj.computedImage.height];
           end
           
           plot(Xvec,Yvec,'color',rayColor,'lineStyle',lineStyle,'lineWidth',rayWidth);
           
           % When imaginary object also plot the physical/real rays
           if (imaginary)
               realXvec = [obj.x, obj.x + dX];
               realYvec = extrapolateLine(Xvec, Yvec, realXvec);
               plot(realXvec, realYvec,'color',rayColor,'lineWidth',rayWidth);
           end
           
           % 5) Ray through center of optic lens
           slope3 = - obj.O.height/obj.do;
           if (abs(obj.computedImage.x) == inf)
               Xvec = [obj.x, obj.x + dX];
               Yvec = [0, slope3*dX];
           else
               Xvec = [obj.x, obj.computedImage.x];
               Yvec = [0, obj.computedImage.height];
           end
           
           plot(Xvec,Yvec,'color',rayColor,'lineStyle',lineStyle,'lineWidth',rayWidth);
                      
           % When imaginary object also plot the physical/real rays
           if (imaginary)
               realXvec = [obj.x, obj.x + dX];
               realYvec = extrapolateLine(Xvec, Yvec, realXvec);
               plot(realXvec, realYvec,'color',rayColor,'lineWidth',rayWidth);
           end
           
           % 6) Ray horizontally leaving the lens        
           
           if (obj.computedImage.height ~= 0 && abs(obj.computedImage.x) ~= inf)               
               Xvec = [obj.x, obj.computedImage.x];
               Yvec = [objectRayFocalPointHitLensHeight, objectRayFocalPointHitLensHeight];
               plot(Xvec,Yvec,'color',rayColor,'lineStyle',lineStyle,'lineWidth',rayWidth);
                          
               % When imaginary object also plot the physical/real rays
               if (imaginary)
                   realXvec = [obj.x, obj.x + dX];
                   realYvec = extrapolateLine(Xvec, Yvec, realXvec);
                   plot(realXvec, realYvec,'color',rayColor,'lineWidth',rayWidth);
               end
           
           end
           
           % Handles to be used for the legend
           handles = [lensObjectHandle, lensImageHandle, focalPointsHandle, geometricalRaysHandle];
        end
    end
    
    %========================================
    % Static methods
    %========================================
    
    methods (Static = true)
        function di = lensFormulaToImageDistance(f, do) 
           % Round off 1/do first
           one_do = round(1./do, 7, 'significant');
           di = 1./(1./f-one_do); 
        end
        
        function hi = imageDistanceToImageHeight(do, di, ho)
           hi =  - di*ho/do;
        end
    end
    
end

