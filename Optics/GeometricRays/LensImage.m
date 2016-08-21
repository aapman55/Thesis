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
           stdColors = lines; 
           % Draw the image in green 
           handle = quiver(obj.x,0,0,obj.height,0,'color',stdColors(5,:),'linewidth',2,'maxheadsize', norm([0,obj.height]));            
        end
        
        function outputObject = toObject(obj)
           outputObject = LensObject(obj.x,obj.height); 
           outputObject.infinityAngle = obj.infinityAngle;
           
           % In case the image is at infinity
           if (abs(obj.x) == inf)
               outputObject.x = -obj.x;
           end
        end
    end
    
end

