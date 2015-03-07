module Delaunay
  class Triangle
    def initialize(points = [])
      @matrix   = Matrix.new(points)
      raise 'Too many points in matrix for a triangle' unless @matrix.size == 3

      @complete = false
      @edges    = []
    end

    def valid?
      @matrix.size == 3 && !coincidental?
    end

    # returns true if any of the points coincide
    def coincidental?
      point_a.coincident?(point_b) ||
        point_b.coincident?(point_c) ||
        point_a.coincident?(point_c)
    end

    def complete?
      @complete == true
    end

    def complete!
      @complete = true
      @edges    = []
      @edges    = [
        Edge.new(point_a, point_b),
        Edge.new(point_b, point_c),
        Edge.new(point_c, point_a)
      ]
    end

    def matrix=(matrix)
      @matrix = matrix
    end

    def point_a
      @matrix[0]
    end

    def point_b
      @matrix[1]
    end

    def point_c
      @matrix[2]
    end

    def to_edges
      @edges
    end

    def to_a
      @matrix.map(&:to_a)
    end

    def to_s
      to_a.to_s
    end
  end
end
