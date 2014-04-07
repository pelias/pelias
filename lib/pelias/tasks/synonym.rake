require 'numbers_and_words'

namespace :synonyms do

  task :build do

    def suffix_for(i)
      n = i % 10
      case n
      when 1 then 'st'
      when 2 then 'nd'
      when 3 then 'rd'
      else        'th'
      end
    end

    File.open('config/synonyms.txt', 'w') do |file|

      # write each of the postal synonym lines
      File.read('config/data/en_postal_synonyms.txt').each_line do |line|
        file.puts line.split(',').map { |f| f.downcase }.uniq.join(',')
      end

      # write out each of the directions
      %w{west east north south}.each do |dir|
        file.puts "#{dir},#{dir[0]}"
      end

      # and then generate for each number
      (0..1000).each do |num|
        file.puts [
          num,
          num.to_words(remove_hyphen: true),
          num.to_words(remove_hyphen: true, ordinal: true),
          "#{num}#{suffix_for(num)}",
          "#{num} #{suffix_for(num)}"
        ].join(',')
      end

    end

  end

end
