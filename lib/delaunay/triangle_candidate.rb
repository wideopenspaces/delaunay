module Delaunay
  class TriangleCandidate < Struct.new(:p1, :p2, :p3, :complete)
    def complete?
      complete == true
    end

    def to_a
      [p1, p2, p3]
    end

    def edges
      [ [p1, p2], [p2, p3], [p3, p1] ]
    end

    def any_vertex_exceeds?(num)
      [p1, p2, p3].any? { |p| p >= num }
    end
  end
end
