module AmandaBot
  class LanguageSelector
    def self.analyzers repo, languages
      parse(languages).map { |l| get_analyzer(l, repo) }
    end

    def self.parse input
      input.split(" ").map { |e| e.gsub("--", "").to_sym }
    end

    def self.get_analyzer sym, repo
      analyzer_map[sym].new(repo)
    end

    def self.analyzer_map
      {
        ruby: RubyAnalyzer,
        javascript: JavascriptAnalyzer
      }
    end
  end
end