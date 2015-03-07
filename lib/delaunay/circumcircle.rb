module Delaunay
  class Circumcircle
    attr_reader :p, :p1, :p2, :p3, :cache

    DEFAULT_RES = { contained: false,
                    center: Point.new([0, 0]),
                    radius: 0
                  }.freeze

    # Takes an optional cache hash to use for radius/center caching
    def initialize(p, p1, p2, p3, cache = nil)
      @p, @p1, @p2, @p3, @cache = p, p1, p2, p3, cache
      @result = {}
      calculate!
    end

    # The return value is an array [ inside, xc, yc, r ]
    # TODO: This method really needs work :(
    def calculate!
      dx,dy,rsqr,drsqr = []
      cached = cache && cache[[p1, p2, p3]]
      xc, yc, r = []
      rsqr = 0

      if cached
  			xc, yc, r, rsqr = cached
      else
        @result = DEFAULT_RES and return if coincidental_points?(p1, p2, p3)

        if (p2.y-p1.y).abs < Point::EPSILON
          xc = mx(p2, p1)
          yc = m(p2, p3) * (xc - mx(p2,p3)) + my(p2,p3)
        elsif (p3.y-p2.y).abs < Point::EPSILON
          xc = mx(p3, p2)
          yc = m(p1, p2) * (xc - mx(p1, p2)) + my(p1,p2)
        else
          xc = (m(p1, p2) * mx(p1, p2) - m(p2, p3) * mx(p2,p3) + my(p2,p3) - my(p1,p2)) / (m(p1, p2) - m(p2, p3))
          yc = m(p1, p2) * (xc - mx(p1, p2)) + my(p1,p2)
        end

  			rsqr  = rsqr(dx(p2, xc), dy(p2, yc))
  			r     = Math.sqrt(rsqr)
        cache[[p1, p2, p3]] = [ xc, yc, r, rsqr ] if cache
      end

      drsqr   = drsqr(p, xc, yc)
      @result = { contained: (drsqr <= rsqr), center: Point.new([xc, yc]), radius: r }
    end

    # The circumcircle center is returned in Point.new(xc,yc)
    def center
      result[:center]
    end

    # Return TRUE if a point p is inside the circumcircle made up of the
    # points p1, p2, p3
    # NOTE: A point on the edge is inside the circumcircle
    def contained?
      result[:contained] == true
    end

    def radius
      result[:radius]
    end

    def result
      @result
    end

    private

    def coincidental_points?(p1, p2, p3)
      p1.coincident?(p2) || p2.coincident?(p3) || p3.coincident?(p1)
    end

    # The Maths

    def drsqr(p, xc, yc)
      rsqr dx(p, xc), dy(p, yc)
    end

    def dx(pt, xc)
      pt.x - xc
    end

    def dy(pt, yc)
      pt.y - yc
    end

    def m(a,b)
      -(b.x-a.x) / (b.y-a.y)
    end

    def my(a,b)
      (a.y + b.y) * 0.5
    end

    def mx(a, b)
      (a.x + b.x) * 0.5
    end

    def rsqr(dx, dy)
      dx*dx + dy*dy
    end
  end
end
