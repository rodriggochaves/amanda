require_relative 'analyzer'
require_relative 'visitable'

class RubyAnalyzer < Analyzer
  include Visitable

  TMP_FOLDER = "./tmp/repositories"

  def extensions
    [ ".rb" ]
  end

  def analyze files
    @files = files.select{ |f| extensions.include?(File.extname(f)) }
    run_rubocop
  end

  def parse result
    result.split("\n").map do |line|
      if line.include?("[Corrected]")
        line[(line.index("[Corrected]") + 11)..(line.length)]
      else
        ""
      end
    end
  end

  private def run_rubocop
    @files.map{ |e| "#{TMP_FOLDER}/#{@repo}/#{e}" }.each do |file|
      result = `rubocop -a #{file}`
      @report = parse(result).reject{ |s| s.empty? }
    end
  end
end