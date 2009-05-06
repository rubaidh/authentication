require 'spec/rake/spectask'

task :default => :spec

namespace :spec do
  namespace :plugins do
    desc "Runs the examples for authentication"
    Spec::Rake::SpecTask.new(:authentication) do |t|
      t.spec_opts = ['--options', "\"#{RAILS_ROOT}/spec/spec.opts\""]
      t.spec_files = FileList['vendor/plugins/authentication/spec/**/*_spec.rb']
    end
  end
end
