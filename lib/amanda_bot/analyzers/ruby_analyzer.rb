require_relative 'analyzer'
require_relative 'visitable'

class RubyAnalyzer < Analyzer
  include Visitable

  TMP_FOLDER = "./tmp/repositories"

  def extensions
    [ ".rb" ]
  end

  def analyze files
    @files = files
    run_rubocop
  end

  private def run_rubocop
    @files.map{ |e| "#{TMP_FOLDER}/#{@repo}/#{e}" }.each do |file|
      system "rubocop -a #{file}"
    end
  end
end