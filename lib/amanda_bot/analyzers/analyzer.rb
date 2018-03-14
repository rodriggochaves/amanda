require 'rugged'
require 'dot_env'

DotEnv.get_environment

# define a interface to class responsiable for run the static analyser
class Analyzer

  def initialize(repo)
    @repo = repo
  end

  def accept(visitor)
    raise NotImplementedError
  end

  def analyze
    raise NotImplementedError
  end

  def extensions
    raise NotImplementedError
  end

end