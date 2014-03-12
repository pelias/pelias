require 'hashie/mash'

module Pelias

  module Suggestion

    extend self

    def rebuild_suggestions_for_admin0(e)
      rebuild_suggestions_for_admin1(e)
    end

    def rebuild_suggestions_for_admin1(e)
      {
        input: [e.name],
        output: e.name,
        weight: 1
      }
    end

    def rebuild_suggestions_for_admin2(e)
      boost = e.population.to_i / 100_000
      {
        input:  [e.admin1_abbr, e.admin1_name].compact.map { |v| "#{e.name} #{v}" },
        output: [e.name, e.admin1_abbr || e.admin1_name].compact.join(', '),
        weight: boost < 1 ? 1 : boost
      }
    end

    def rebuild_suggestions_for_local_admin(e)
      inputs = []
      inputs.concat [e.admin1_abbr, e.admin1_name].compact.map { |v| "#{e.name} #{v}" }
      inputs.concat [e.locality_name, e.admin2_name].compact.map { |v| [e.name, v, e.admin1_abbr || e.admin1_name].join(' ') }
      {
        input: inputs,
        output: [e.name, e.admin1_abr || e.admin1_name].compact.join(', '),
        weight: (e.population.to_i / 100_000) + 12
      }
    end

    def rebuild_suggestions_for_locality(e)
      inputs = []
      inputs.concat [e.admin1_abbr, e.admin1_name].compact.map { |v| "#{e.name} #{v}" }
      inputs.concat [e.local_admin_name, e.admin2_name].compact.map { |v| [e.name, v, e.admin1_abbr || e.admin1_name].join(' ') }
      {
        input: inputs,
        output: [e.name, e.admin1_abbr || e.admin1_name].compact.join(', '),
        weight: (e.population.to_i / 100_000) + 12
      }
    end

    def rebuild_suggestions_for_neighborhood(e)
      adn = e.locality_name || e.local_admin_name || e.admin2_name
      inputs = []
      inputs.concat [e.admin1_abbr, e.admin1_name].compact.map { |v| "#{e.name} #{v}" }
      inputs.concat [e.local_admin_name, e.locality_name, e.admin2_name].compact.map { |v| [e.name, v, e.admin1_abbr || e.admin1_name].join(' ') }
      {
        input: inputs,
        output: [e.name, adn, e.admin1_abbr || e.admin1_name].compact.join(', '),
        weight: adn ? 10 : 0
      }
    end

    def rebuild_suggestions_for_address(e)
      adn = e.local_admin_name || e.locality_name || e.neighborhood_name || e.admin2_name
      inputs = [e.local_admin_name, e.locality_name, e.neighborhood_name, e.admin2_name].compact.map { |v| "#{e.name} #{v}" }
      {
        input: inputs,
        output: [e.name, adn, e.admin1_abbr || e.admin1_name].compact.join(', '),
        weight: adn ? 10 : 0
      }
    end

    def rebuild_suggestions_for_street(e)
      adn = e.local_admin_name || e.locality_name || e.neighborhood_name || e.admin2_name
      inputs = [e.local_admin_name, e.locality_name, e.neighborhood_name, e.admin2_name].compact.map { |v| "#{e.name} #{v}" }
      {
        input: inputs,
        output: [e.name, adn, e.admin1_abbr || e.admin1_name].join(', '),
        weight: adn ? 8 : 0
      }
    end

    def rebuild_suggestions_for_poi(e)
      # TODO
    end

  end

end
