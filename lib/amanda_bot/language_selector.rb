module LanguageSelector
  def create_analyzer(repository_full_name, files, repository_language, head_branch)
    case repository_language
      when "-R"
        ruby_files = files.select{ |e| e.match(/(\S)*.rb/) }
        RubyAnalyzer.new(repository_full_name, head_branch, ruby_files)
      else
        nil
    end
  end
end