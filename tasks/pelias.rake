require 'elasticsearch'

namespace :pelias do

  desc "setup index & mappings"
  task :setup do
    es = Elasticsearch::Client.new log: false
    es.indices.create index: 'pelias', body: {
      settings: {
        analysis: {
          char_filter: {
            ordinal_strip: {
              type: 'pattern_replace',
              pattern: '(?<=[0-9])(?:st|nd|rd|th)',
              replacement: ''
            }
          },
          analyzer: {
            us_en: {
              tokenizer: 'standard',
              filter: ['standard', 'lowercase'],
              char_filter: ['ordinal_strip']
            }
          }
        }
      },
      mappings: {
        street: {
          properties: {
            name: {
              type: 'string',
              analyzer: 'us_en'
            },
            location: {
              type: 'geo_shape'
            }
          }
        },
        address: {
          properties: {
            number: {
              type: 'string'
            },
            full_name: {
              type: 'string'
            },
            street_name: {
              type: 'string'
            },
            location: {
              type: 'geo_point' 
            }
          },
          _parent: {
            type: 'street'
          }
        }
      }
    }
  end

end
