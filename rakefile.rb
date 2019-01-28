require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do
  sh 'rubocop --lint'
end

task :default => :spec
