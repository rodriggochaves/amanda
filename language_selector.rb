module LanguageSelector
  def create_analyzer(repository_full_name, repository_language, head_branch)
    case repository_language
      when "-R"
        RubyAnalyzer.new(repository_full_name, head_branch)
      else
        nil
    end
  end
end