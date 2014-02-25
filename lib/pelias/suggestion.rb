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
        weight: entry['population'] / 100_000
      }
    end

    def rebuild_suggestions_for_local_admin(entry)
      e = Hashie::Mash.new(entry)
      {
        input: nil, # TODO
        output: [e.name, e.admin1_abr || e.admin1_name].compact.join(', '),
        weight: (entry['population'] / 100_000) * 12
      }
    end

    def rebuild_suggestions_for_locality(entry)
      e = Hashie::Mash.new(entry)
      {
        input: nil, # TODO
        output: [e.name, e.admin1_abbr || e.admin1_name].compact.join(', '),
        weight: (entry.population / 100_000) * 12
      }
    end

    def rebuild_suggestions_for_neighborhood(entry)
      # TODO
    end

    def rebuild_suggestions_for_address(entry)
      # TODO
    end

    def rebuild_suggestions_for_street(entry)
      # TODO
    end

    def rebuild_suggestions_for_poi(entry)
      # TODO
    end

  end

end
