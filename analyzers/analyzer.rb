class Analyzer
  attr_reader :repository

  def initialize(repo)
    @repository = repo
  end

  def accept(visitor)
    visitor
  end
end