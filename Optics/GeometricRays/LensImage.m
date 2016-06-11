classdef LensImage
    %LENSIMAGE An Image created by the lens
    
    properties
        x;              %   x-location of the object
        height;         %   The height of the object
    end
    
    methods
        function obj = LensImage(x, height)
           obj.x = x;
           obj.height = height;            
        end
        
        function handle = draw(obj)
           % Draw the image in green 
           handle = quiver(obj.x,0,0,obj.height,0,'color',[0,1,0],'linewidth',2,'maxheadsize', 1/norm([0,obj.height]));            
        end
        
        function outputObject = toObject(obj)
           outputObject = LensObject(obj.x,obj.height); 
        end
    end
    
end

