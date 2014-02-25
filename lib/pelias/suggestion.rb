require 'hashie/mash'

module Pelias

  module Suggestion

    extend self

    def rebuild_suggestions_for_admin1(entry)
      e = Hashie::Mash.new(entry)
      {
        input: e.name,
        output: e.name,
        weight: 1
      }
    end

    def rebuild_suggestions_for_admin2(entry)
      e = Hashie::Mash.new(entry)
      {
        input:  [e.admin1_abbr, e.admin1_name].compact.map { |v| "#{e.name} #{v}" },
        output: [e.name, e.admin1_abbr || e.admin1_name].compact.join(', '),
        weight: entry['population'].to_i / 100_000
      }
    end

  end

end
