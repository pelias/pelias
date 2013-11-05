module Pelias

  class Base

    ES_CLIENT = Elasticsearch::Client.new log: false
    PG_CLIENT = PG.connect dbname: 'osm'

    def self.parse_nodes(nodes_str)
      nodes_str = nodes_str[1..nodes_str.length-2]
      nodes_str.split(',')
    end

    def self.parse_members(members_str)
      members_str = members_str[1..members_str.length-2]
      members_arr = members_str.split(',')
      members_hash = {}
      while members_arr.size > 0 do
        val = members_arr.shift
        val = [val[0], val[1..val.length]]
        key = members_arr.shift
        if members_hash[key]
          members_hash[key] << val
        else
          members_hash[key] = [val]
        end
      end
      members_hash
    end

    def self.parse_tags(tags_str)
      tags_str = tags_str[1..tags_str.length-2]
      tags_str = tags_str.gsub('"', '')
      tags_arr = tags_str.split(',')
      tags_hash = {}
      while tags_arr.size > 0 do
        val = tags_arr.pop
        key = tags_arr.pop
        tags_hash[key] = val.strip
      end
      tags_hash
    end

  end

end
