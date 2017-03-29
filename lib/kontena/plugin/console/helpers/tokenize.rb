module Kontena::Plugin
  module Console
    module Helpers
      module Tokenize
        def tokenize
          split(/\s(?=(?:[^"]|"[^"]*")*$)/).map(&:strip)
        end

        def self.tokenize(string)
          string.dup.extend(self).tokenize
        end
      end
    end
  end
end
