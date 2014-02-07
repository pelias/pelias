module Pelias

  class LocalAdmin < Location

    SUGGEST_WEIGHT = 12

    def encompassing_shapes
      %w(admin2 locality)
    end

    def suggest_weight
      SUGGEST_WEIGHT + population_weight_boost
    end

    def population_weight_boost
      return 0 if population.nil?
      boost = population.to_i / 100000
      boost < 1 ? 1 : boost.to_i
    end

    def suggest_input
      input = []
      input << "#{name} #{admin1_abbr}" if admin1_abbr
      input << "#{name} #{admin1_name}" if admin1_name
      [locality_name, admin2_name].each do |admin_name|
        next unless admin_name
        input_name = "#{name} #{admin_name}"
        if admin1_abbr
          input_name << " #{admin1_abbr}"
        elsif admin1_name
          input_name << " #{admin1_name}"
        end
        input << input_name
      end
      input
    end

    def suggest_output
      output = "#{name}"
      if admin1_abbr
        output << ", #{admin1_abbr}"
      elsif admin1_name
        output << ", #{admin1_name}"
      end
      output
    end

    def local_admin_name
      name
    end

  end

end
