classdef LensImage
    %LENSIMAGE An Image created by the lens
    
    properties
        x;                  %   x-location of the object
        height;             %   The height of the object
        infinityAngle = 0;  %   Variable used when the rays are going to infinity, defines the angle
                            %   Of these rays with the x-axis 
    end
    
    methods
        function obj = LensImage(x, height, infinityAngle)
           obj.x = x;
           obj.height = height;            
           obj.infinityAngle = infinityAngle;
        end
        
        function handle = draw(obj)
           % Draw the image in green 
           handle = quiver(obj.x,0,0,obj.height,0,'color',[0,1,0],'linewidth',2,'maxheadsize', 1/norm([0,obj.height]));            
        end
        
        function outputObject = toObject(obj)
           outputObject = LensObject(obj.x,obj.height); 
           outputObject.infinityAngle = obj.infinityAngle;
        end
    end
    
end

