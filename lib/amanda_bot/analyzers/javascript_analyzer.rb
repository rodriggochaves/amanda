require_relative 'analyzer'
require_relative 'visitable'

class JavascriptAnalyzer < Analyzer
  include Visitable
end