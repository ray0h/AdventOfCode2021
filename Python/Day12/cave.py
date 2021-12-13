
class Cave:
  def __init__(self, name):
    self.name = name
    self.paths = []

  def add_path(self, path):
    if path not in self.paths:
      self.paths.append(path)

  