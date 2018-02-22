module LanguageSelector
  def create_analyzers(repository_full_name, files, repository_language, head_branch)
    analyzers = []
    parse_params(repository_language).each do |l|
      analyzers.push(add_analyser(repository_full_name, files, l, head_branch))
    end
    return analyzers
  end

  def add_analyser( repository_full_name, files, icon, head_branch )
    case icon
      when "R"
        ruby_files = files.select{ |e| e.match(/(\S)*.rb/) }
        return RubyAnalyzer.new(repository_full_name, head_branch, ruby_files)
      when "J"
        js_files = files.select{ |e| e.match(/(\S)*.js/) }
        return JavascriptAnalyzer.new(repository_full_name, head_branch, js_files)
      else
        nil
    end
  end

  def parse_params(params)
    params.split(" ").map { |e| e.tr('-', '') }
  end
end