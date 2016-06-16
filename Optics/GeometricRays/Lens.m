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
               % Determine object distance
               do = obj.x - obj.O.x;        
              % Calculate the image distance
               obj.di = Lens.lensFormulaToImageDistance(obj.f, do);
               if (abs(obj.f - do) < eps && obj.O.height == 0)
                   % Calculate the image height 
                   hi = tand(obj.O.infinityAngle) * obj.f;
               else
                   % Calculate the image height
                   hi = Lens.imageDistanceToImageHeight(do, obj.di, obj.O.height);
               end
              % Calculate the exact x-coordinate of the image
               xi = obj.x + obj.di;

           else
               % There is no sound object distance
               % The image distance is the focal point
               obj.di = obj.f;
               % Image height depends on the infinityAngle
               hi = tand(obj.O.infinityAngle)*obj.di;
              % Calculate the exact x-coordinate of the image
               xi = obj.x + obj.di;
           end
           
           % Set the image object
           obj.computedImage = LensImage(xi, hi, atand(-obj.O.height/obj.f));
        end
        
       %========================================
       % Draw the light ray diagram
       %========================================
        function handles = draw(obj)
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
           
           % Draw lens focal points
           focalPointsHandle = scatter([obj.x-obj.f, obj.x+obj.f],[0,0],'markerfacecolor','k');
           
           % Draw optical axis
           plot([obj.O.x,obj.computedImage.x],[0,0],'color',[0,0,0])
            
           % Draw geometric optic rays
           % Determine object distance
           do = obj.x - obj.O.x;
           
           % Calculate at which height the object ray hits the lens
           if (obj.O.height ~= 0 && abs(obj.O.x) ~= inf && do ~= obj.f)
               slope1 = -obj.O.height/(do - obj.f);
               objectRayFocalPointHitLensHeight = obj.f*slope1;               
           elseif (abs(obj.O.x) == inf || do == obj.f)
               objectRayFocalPointHitLensHeight = obj.O.height;
           else
               objectRayFocalPointHitLensHeight = do*tand(obj.O.infinityAngle);
           end
           
           % Define how much you want to draw the infinity rays
           dX = 2*obj.f;
           
           %========================================
           % Object side
           %========================================
           
           % 1) From object horizontally to lens
           if (abs(obj.O.x) == inf)
               plot([obj.x - 2*obj.f, obj.x],[obj.O.height, obj.O.height],'color','magenta');
           else
               plot([obj.O.x, obj.x],[obj.O.height, obj.O.height],'color','magenta');
           end
           
           % 2) From object to center of optic lens

           geometricalRaysHandle = plot([obj.O.x, obj.x],[obj.O.height, 0],'color','magenta');
           
           
           % 3) From object through focal point at the side of the object
           % continuing to the lens     
           if (abs(obj.O.x) == inf)
               plot([obj.x + sign(obj.O.x)*dX, obj.x],[0, 0],'color','magenta');
           else
                geometricalRaysHandle = plot([obj.O.x, obj.x],[obj.O.height, objectRayFocalPointHitLensHeight],'color','magenta');
           end
           
           %========================================
           % Image side
           %========================================
           % Check if the rays are imaginary
           if (obj.di < 0)
               lineStyle = '--';
           else
               lineStyle = '-';
           end
           
           % 4) From lens to image through focal point       
           
           if (abs(obj.computedImage.x) == inf)
               plot([obj.x, obj.x + dX],[objectRayFocalPointHitLensHeight, objectRayFocalPointHitLensHeight + dX * tand(obj.computedImage.infinityAngle)],'color','magenta','lineStyle',lineStyle);
           elseif (obj.O.height == 0)
               plot([obj.x, obj.computedImage.x],[objectRayFocalPointHitLensHeight, obj.computedImage.height],'color','magenta','lineStyle',lineStyle);
           else
               plot([obj.x, obj.computedImage.x],[obj.O.height, obj.computedImage.height],'color','magenta','lineStyle',lineStyle);
           end
           
           % 5) Ray through center of optic lens
           slope3 = - obj.O.height/do;
           if (abs(obj.computedImage.x) == inf)
               plot([obj.x, obj.x + 2*obj.f],[0, 2*slope3*obj.f],'color','magenta','lineStyle',lineStyle);
           else
               plot([obj.x, obj.computedImage.x],[0, obj.computedImage.height],'color','magenta','lineStyle',lineStyle);
           end
           
           % 6) Ray horizontally leaving the lens        
           
           if (obj.computedImage.height ~= 0 && abs(obj.computedImage.x) ~= inf)               
               plot([obj.x, obj.computedImage.x],[objectRayFocalPointHitLensHeight, objectRayFocalPointHitLensHeight],'color','magenta','lineStyle',lineStyle);
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
           di = 1./(1./f-1./do); 
        end
        
        function hi = imageDistanceToImageHeight(do, di, ho)
           hi =  - di*ho/do;
        end
    end
    
end

