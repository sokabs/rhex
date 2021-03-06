require 'pqueue'

# TODO : finalize movement : add a cost limit (can't move more than n-points)
# TODO : add a method that give all movements from a points (withing a cost limit)

module Movement

  def compute_movement( start, goal, costs )

    start = hget( start )
    goal = hget( goal )

    frontier = PQueue.new(){ |a,b| a[1] > b[1] }
    frontier << [start, 0 ]
    came_from = {}
    cost_so_far = {}
    came_from[ start.qr ] = nil
    cost_so_far[ start.qr ] = 0

    until frontier.empty?
      current = frontier.shift.first

      break if current == goal

      neighbors = current.get_surrounding_hexs
      new_cost = nil

      neighbors.each do |neighbor|
        neighbor = hget( neighbor ) # get_surrounding_hexs only give us a position. We need to transform it into an hex on the grid.
        if neighbor
          new_cost = cost_so_far[ current.qr ] + costs[ neighbor.val ]
          if ! cost_so_far.has_key?( neighbor.qr ) || new_cost < cost_so_far[ neighbor.qr ]
            cost_so_far[ neighbor.qr ] = new_cost
            priority = new_cost + heuristic_distance( goal, neighbor )
            frontier << [ neighbor, priority ]
            came_from[ neighbor.qr ] = current
          end
        end
      end
    end

    current = goal
    path = [ current ]
    until current == start
      current = came_from[ current.qr ]
      cost = cost_so_far[ current.qr ]
      path << current
    end

    path.reverse!
    path_cost = []
    path.each do |h|
      path_cost << cost_so_far[ h.qr ]
    end

    [ path, path_cost ]
  end


  private

  def heuristic_distance( a, b )
    ( a.q - b.q ).abs + ( a.r - b.r ).abs
  end

end