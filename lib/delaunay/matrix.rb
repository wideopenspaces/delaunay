module Delaunay
  # A Matrix is a collection of Points
  class Matrix
    include Enumerable

    # generate a Matrix from an array of 2 element arrays
    # e.g. [[23,25], [33,31], [44,50]]
    def self.from_array(arr)
      new(arr.map { |a| Point.new(a) })
    end

    # Sort the points ahead of time
    def initialize(points = [])
      @points = points.sort_by { |pt| pt.x }
    end

    def <<(point)
      @points << point
    end

    def each(&block)
      @points.each do |point|
        block_given? ? block.call(point) : yield(point)
      end
    end

    def size
      @points.size
    end

    def [](index)
      @points[index]
    end

    def slice(pt_range)
      new(@points.slice pt_range)
    end

    def pop(n = 1)
      @points.pop(n)
    end

    def values_at(*i)
      @points.values_at(*i)
    end

    def min_x
      @min_x ||= x_sorted.first.x
    end

    def max_x
      @max_x ||= x_sorted.last.x
    end

    def min_y
      @min_y ||= y_sorted.first.y
    end

    def max_y
      @max_y ||= y_sorted.last.y
    end

    def delta_x
      max_x - min_x
    end

    def delta_y
      max_y - min_y
    end

    def delta_max
      [delta_x, delta_y].max
    end

    def mid_x
      (max_x + min_x) / 2.0
    end

    def mid_y
      (max_y + min_y) / 2.0
    end

    # Find the maximum and minimum bounds.
    # This is to allow calculation of the bounding triangle
    def boundaries
      bounds = [mid_x - 2.0 * delta_max, mid_y - delta_max],
  			       [mid_x, mid_y + 2.0 * delta_max],
      	       [mid_x + 2.0 * delta_max, mid_y - delta_max]
      Matrix.from_array bounds
    end

    def to_s
      @points.to_a.to_s
    end

    private

    def x_sorted
      @x_sorted ||= sort_by { |pt| pt.x }
    end

    def y_sorted
      @y_sorted ||= sort_by { |pt| pt.y }
    end
  end
end
