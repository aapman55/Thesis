classdef LensObject < handle
    %LENSOBJECT An object placed in front of the lens
    
    properties
        x;                  %   x-location of the object
        height;             %   The height of the object
        infinityAngle = 0;  %   Variable used when the rays are going to infinity, defines the angle
                            %   Of these rays with the x-axis 
    end
    
    methods
        function obj = LensObject(x, height)
           obj.x = x;
           obj.height = height;            
        end
        
        function setInfinityAngle(obj, angle)
           obj.infinityAngle = angle; 
        end
        
        function handle = draw(obj)
           % Draw the object in blue 
           handle = quiver(obj.x,0,0,obj.height,0,'color',[0,0,1],'linewidth',2,'maxHeadSize',norm([0,obj.height]));            
        end
    end
    
end

