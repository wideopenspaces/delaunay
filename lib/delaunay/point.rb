module Delaunay
  # A Point is an x,y pair
  class Point
    include Comparable

    EPSILON = 0.000001

    def initialize(coord)
      @coord = coord
      @x     = coord.first
      @y     = coord.last
    end

    def <=>(other)
      to_a <=> other.to_a
    end

    def coincident?(other)
      delta_x, delta_y = (x - other.x).abs, (y - other.y).abs
      [delta_x, delta_y, EPSILON].max == EPSILON
    end

    def level_to?(other)
      (y - other.y).abs < EPSILON
    end

    def x; @x; end
    def y; @y; end

    def to_a
      @coord
    end

    def to_s
      to_a.to_s
    end

    def to_h
      { x: @x, y: @y }
    end
  end
end
