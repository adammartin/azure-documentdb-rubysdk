require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do
  sh 'rubocop'
end

task :default => :spec
