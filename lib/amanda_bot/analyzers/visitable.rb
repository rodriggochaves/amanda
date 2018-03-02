module Visitable
  def accept(visitor, files)
    visitor.visit(self, files)
  end
end