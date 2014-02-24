module Pelias

  class Neighborhood < Location

    SUGGEST_WEIGHT = 10

    def suggest_weight
      admin_display_name ? SUGGEST_WEIGHT : 0
    end

    def admin_display_name
      locality_name || local_admin_name || admin2_name
    end

    def suggest_input
      input = []
      input << "#{name} #{admin1_abbr}" if admin1_abbr
      input << "#{name} #{admin1_name}" if admin1_name
      [local_admin_name, locality_name, admin2_name].each do |admin_name|
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
      if admin_display_name
        output << ", #{admin_display_name}"
      end
      if admin1_abbr
        output << ", #{admin1_abbr}"
      elsif admin1_name
        output << ", #{admin1_name}"
      end
      output
    end

    def neighborhood_name
      name
    end

  end

end
