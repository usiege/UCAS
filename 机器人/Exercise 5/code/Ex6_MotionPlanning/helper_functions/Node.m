classdef Node
    %NODE Node within the dijkstra algorithm
    
    properties(GetAccess = 'public', SetAccess = 'public')
        f
        idx
    end
    
    methods(Access=public)
        
        function self = Node(f, idx)
            self.f = f;
            self.idx = idx;
        end
        
        function rval = lt(node1,node2)
            rval = (node1.f < node2.f);
        end
        
        function rval = le(node1,node2)
            rval = (node1.f <= node2.f);
        end
        
        function rval = gt(node1,node2)
            rval = (node1.f > node2.f);
        end
        
        function rval = ge(node1,node2)
            rval = (node1.f >= node2.f);
        end

    end
    
end

