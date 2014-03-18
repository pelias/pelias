require_relative 'task_helper'

namespace :quattroshapes do

  task :prepare_all  => Pelias::QuattroIndexer::PATHS.map { |t, _| "prepare_#{t}" }

  Pelias::QuattroIndexer::PATHS.each do |type, file|
    task(:"prepare_#{type}") { perform_prepare(type, file) }
    task(:"populate_#{type}") { perform_index(type) }
  end

  private

  # Download the things we need
  def perform_prepare(type, file)
    sh "wget http://static.quattroshapes.com/#{file}.zip -P #{TEMP_PATH}" # download
    sh "unzip #{TEMP_PATH}/#{file}.zip -d #{TEMP_PATH}" # expand
    sh "shp2pgsql -D -d -Nskip -I -WLATIN1 #{TEMP_PATH}/#{file}.shp qs.qs_#{type} > #{TEMP_PATH}/#{file}.sql" # convert
    sh "#{psql_command} < #{TEMP_PATH}/#{file}.sql" # import
    sh "rm #{TEMP_PATH}/#{file}*" # clean up
  end

  # Perform an index
  def perform_index(type)
    # Get count
    results = Pelias::DB["SELECT COUNT(1) as count from qs.qs_#{type}"]
    count = results.first[:count].to_i
    bar = ProgressBar.create(total: count, format: '%e |%b>%i| %p%%')
    # And execute each
    Pelias::DB["select gid from qs.qs_#{type}"].use_cursor.each do |row|
      bar.progress += 1
      Pelias::QuattroIndexer.perform_async type, row[:gid], ENV['SKIP_LOOKUP'] == '1'
    end
  end

  def psql_command
    c = Pelias::PG_CONFIG
    [ 'psql',
      ("-U #{c[:user]}" if c[:user]),
      ("-h #{c[:host]}" if c[:host]),
      ("-p #{c[:port]}" if c[:post]),
      c[:database]
    ].compact.join(' ')
  end

end
