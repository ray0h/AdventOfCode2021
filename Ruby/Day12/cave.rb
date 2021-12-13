class Cave
  attr_accessor :name, :paths
  def initialize(name)
    @name = name
    @paths = []
  end
  
  def add_path(path)
    @paths.push(path) unless @paths.include?(path)
  end
end