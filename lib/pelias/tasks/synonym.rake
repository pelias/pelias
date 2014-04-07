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
        file.puts line.split(',').map { |f| f.downcase.strip }.uniq.join(',')
      end

      # write out each of the directions
      file.puts 'north,n'
      file.puts 'south,s'
      file.puts 'east,e'
      file.puts 'west,w'
      file.puts 'northwest,nw'
      file.puts 'southwest,sw'
      file.puts 'northeast,ne'
      file.puts 'southeast,se'

      # and then generate for each number
      (0..1000).each do |num|
        file.puts [
          num,
          (num.to_words(remove_hyphen: true) if num < 100),
          (num.to_words(remove_hyphen: true, ordinal: true) if num < 100),
          "#{num}#{suffix_for(num)}"
        ].compact.join(',')
      end

    end

  end

end
