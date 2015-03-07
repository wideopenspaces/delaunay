module Delaunay
  class Edge
    def initialize(p1, p2)
      @p1 = p1
      @p2 = p2
    end

    def p1; @p1; end
    def p2; @p2; end

    def ==(o)
      (p1 == o.p1 && p2 == o.p2) || (p1 == o.p2 && p2 == o.p1)
    end

    def valid?
      p1 and p2
    end

    def reset!
      self.p1 = self.p2 = nil
    end
  end
end
