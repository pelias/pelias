# Pelias

OpenStreetMap + Elasticsearch 

## Installation

Add this line to your application's Gemfile:

    gem 'pelias'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pelias

## Usage

This is experimental!

    rake pelias:setup

    bundle console
    > Pelias::Street.index_all
    > Pelias::Address.index_all

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
