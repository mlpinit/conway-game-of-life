class Frame

  attr_reader :coordinates, :display

  def initialize(coordinates)
    @coordinates ||= coordinates
    @display = []
    build_display
  end

  def build_display
    0.upto(max_long) do |long|
      display << line(long)
    end
  end

  def line(long)
    str  = ''
    0.upto(max_lat) do |lat|
      if coordinates.include?([lat,long])
        str << 'o'
      else
        str << '-'
      end
    end
    str
  end

  private
  
  def max_lat
    coordinates.map(&:first).max
  end

  def max_long
    coordinates.map(&:last).max
  end

end

def next_round(alive)
  alive.select { |cell| cell if next_cell(cell, alive) } +
    neighbours_that_come_to_life(alive)
end

def next_cell(cell, alive)
  n = neighbors(cell)
  [2,3].include?((alive & n).length)
end

def neighbors(cell)
  x = cell.first
  y = cell.last
  [[x-1, y -1],[x -1, y], [x-1, y + 1],
  [x, y-1], [x, y+1],
  [x + 1, y -1], [x +1, y], [x+1, y+1]]
end

def alive?(cell, active)
  active.
    select { |c| c.first == cell.first }.
    select { |c| c.last == cell.last }.
    any?
end

def dimensions(active)
  max_row = active.map(&:first).max
  max_column = active.map(&:last).max
  [max_row, max_column]
end

# all neighbours that are present exactly 3 times
def neighbours_that_come_to_life(alive)
  alive.
    map { |cell| neighbors(cell) }.
    flatten(1).
    group_by { |x| x }.
    values.
    select { |x| x.size == 3 }.
    flatten(1).
    uniq
end

# round = [[1,1],[1,2],[1,3]]
# round = [[1,1],[1,2],[1,3],[2,2],[2,3],[2,4]]
round = [[10,10],[11,10],[12,10],[13,9],[13,8],[13,7],[15,7],[15,8],[15,9],[16,10],[17,10],[18,10],
         [18,12],[17,12],[16,12],[15,13],[15,14],[15,15],[13,15],[13,14],[13,13],[12,12],[11,12],[10,12]]

while next_round(round).any? do
  system('clear')
  frame = Frame.new(round)
  frame.display.each { |line| puts line }
  round = next_round(round)
  sleep 1
end
