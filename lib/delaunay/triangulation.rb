module Delaunay
  # Accepts an array of arrays containing points
  # in the format [x, y]
  #
  # Returns a Hash containing:
  # => matrix: a Matrix of Points created from the original array
  # => triangles: an array of appropriate Triangles
  #
  # These triangles are arranged in a consistent clockwise order.?
  class Triangulation
    def initialize(points = [])
      @points    = points
      @matrix    = Matrix.from_array(@points)
      @edges     = []
      @triangles = []

      @center_cache  = {} # center/radius cache used by circum_circle
      @center_cache2 = {} # center/radius cache used by circum_circle
      @numpoints     = @matrix.size
    end

    def triangulate!
      prepare_supertriangle!
      check_matrix
      remove_supertriangle!

      nil
    end

    def triangles
      @triangles
    end

    private

    def add_edges(tri)
      tri.edges.each { |st,fi| @edges << Edge.new(st, fi) }
    end

    # Set up the supertriangle
    def prepare_supertriangle!
      # This is a triangle which encompasses all the sample points.
      st_matrix = @matrix.boundaries

      # The supertriangle coordinates are added to the end of the
      # vertex list.
      st_matrix.each { |bpt| @matrix << bpt }

      # The supertriangle is the first triangle in the triangle list.
      @triangles << TriangleCandidate.new(@numpoints, @numpoints + 1, @numpoints + 2)
    end

    # Include each point one at a time into the existing mesh
    def check_matrix
      @matrix.each_with_index do |current_point, i|
        @edges.clear # Set up the edge buffer.
        check_triangles(current_point)
        check_edges(i)
      end
    end

    def check_edges(i)
      until @edges.empty?
        edge     = @edges.shift
        rejected = @edges.reject! { |e| e == edge }
        @triangles << TriangleCandidate.new(edge.p1, edge.p2, i) if rejected.nil?
      end
    end

    # If the point (xp,yp) lies inside the circumcircle then the
    # three edges of that triangle are added to the edge buffer
    # and that triangle is removed.
    #
    # TODO: This needs further improvement
    def check_triangles(current_point)
      tris_size = @triangles.size
      j = 0
      while j < tris_size
        current_triangle = @triangles[j]
        unless current_triangle.complete?
          # Fetch points from the matrix
          p1, p2, p3 = @matrix.values_at(*current_triangle.to_a)

          # Check the circumcircle
          cc = Circumcircle.new(current_point, p1, p2, p3, @center_cache)
          # inside,xc,yc,r = cc.result

          # Complete the triangle if appropriate
          current_triangle.complete = true if (cc.center.x + cc.radius) < current_point.x

          if cc.contained?
            add_edges(current_triangle)
            @triangles.delete_at(j)
            tris_size -= 1
            j -= 1
          end
        end
        j += 1
      end
    end

    # Remove supertriangle vertices
    # Also remove triangles with supertriangle vertices
    # These are triangles which have a vertex number greater than numpoints
    def remove_supertriangle!
      @matrix.pop(3)
      @triangles.delete_if { |t| t.any_vertex_exceeds? @numpoints }
    end
  end
end
