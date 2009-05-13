require 'rake'
require 'rake/rdoctask'

require 'spec/rake/spectask'

task :default => :spec

Spec::Rake::SpecTask.new

desc 'Generate documentation for the authentication plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Authentication'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
