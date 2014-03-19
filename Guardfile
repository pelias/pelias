guard :rspec, cmd: 'bundle exec rspec' do
  watch(/^spec\/.+_spec\.rb$/) { |m| m[0] } # individual
  watch(/^lib\/pelias\/(.+)\.rb$/)     { |m| "spec/examples/#{m[1]}_spec.rb".tap { |s| puts s } } # individual
  watch('spec/spec_helper.rb') { 'spec' } # all
end
