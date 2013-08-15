class Range
  #
  # Returns true if this range neighbors r
  def neighbors?( r )
    (first == r.last or last == r.first)
  end
  
  #
  # Returns true if this range intersects r
  def overlaps?( r )
    (((member? r.first or member? r.last) or 
      (r.member? first or r.member? last)) and
     (!neighbors? r))
  end
end