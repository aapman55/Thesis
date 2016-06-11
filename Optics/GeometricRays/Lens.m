classdef Lens < handle
    %LENS This class represents an optical lens with certain focal length
    % It is able to compute the image of an object at distance do
    
    properties (SetAccess = private)
        f;              %   focal length                    [m]
        x;              %   x-location of the lens          [m]
        height;         %   height of the lens              [m]
        O;              %   Object placed in front of the lens
        computedImage;  %   The computed image        
    end
    
    methods
        function obj = Lens(f, x, height)
           obj.f = f; 
           obj.x = x; 
           obj.height = height; 
        end
        
        
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
        end
        
        function computeImage(obj)
           % Check if a LensObject is set
           if(isempty(obj.O))
               error('You have not set a LensObject yet!')
           end
           
           % Determine object distance
           do = obj.x - obj.O.x;
           % Calculate the image distance
           di = Lens.lensFormulaToImageDistance(obj.f, do);
           % Calculate the image height
           hi = Lens.imageDistanceToImageHeight(do, di, obj.O.height);
           % Calculate the exact x-coordinate of the image
           xi = obj.x + di;
           
           % Set the image object
           obj.computedImage = LensImage(xi, hi);
        end
        
        function draw(obj)
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
           % Horizontal from object to lens then through focal point (but
           % for now we just cheat)
           geometricalRaysHandle = plot([obj.O.x, obj.x, obj.computedImage.x],[obj.O.height, obj.O.height, obj.computedImage.height],'color','magenta');
           % Draw light ray through center of optic (we cheat again)
           plot([obj.O.x, obj.computedImage.x],[obj.O.height, obj.computedImage.height],'color','magenta')
           % Draw light ray from object to focal point, then after the lens
           % going horizontally (we cheat here again)
           plot([obj.O.x, obj.x, obj.computedImage.x],[obj.O.height, obj.computedImage.height, obj.computedImage.height],'color','magenta')
          
        end
    end
    
    methods (Static = true)
        function di = lensFormulaToImageDistance(f, do) 
           di = 1./(1./f-1./do); 
        end
        
        function hi = imageDistanceToImageHeight(do, di, ho)
           hi =  - di*ho/do;
        end
    end
    
end

