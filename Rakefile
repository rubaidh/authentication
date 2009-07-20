require 'rake'
require 'rake/rdoctask'

require 'spec/rake/spectask'

task :default => :spec

Spec::Rake::SpecTask.new do |spec|
  spec.rcov = true
  spec.rcov_opts = %w{-x ^/ -x spec -x generators -x config}
end

desc 'Generate documentation for the authentication plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Authentication'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  gem 'ci_reporter'
  require 'ci/reporter/rake/rspec'
  task :bamboo => "ci:setup:rspec"
rescue LoadError
end

task :bamboo => [ :spec ]
