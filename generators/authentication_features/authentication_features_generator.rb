class AuthenticationFeaturesGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.dependency 'cucumber', [], :collision => :skip
      m.dependency 'rspec', [], :collision => :skip

      # generate the .feature files
      Dir.entries(File.join(File.dirname(__FILE__), 'templates', 'features')).each do |file_name|
        m.file(File.join('features', file_name), File.join('features', file_name)) if file_name.match(/\.feature$/)
      end

      # generate authentication step definitions
      Dir.entries(File.join(File.dirname(__FILE__), 'templates', 'features', 'step_definitions')).each do |file_name|
        m.file(File.join('features', 'step_definitions', file_name), File.join('features', 'step_definitions', file_name)) if file_name.match(/\.rb$/)
      end

      # generate authentication support/paths
      # FIXME: when the generator is run this should ideally not replicate itself
      m.gsub_file File.join('features', 'support', 'paths.rb'), /case page_name/ do |match|
        "#{match}\n#{File.read(File.join(File.dirname(__FILE__), 'templates', 'features', 'support', 'authentication_paths.rb'))}"
      end

      # we use object_daddy for both features and specs and it is probably a good idea to give the application a copy of them
      m.directory(File.join('spec', 'exemplars'))
      m.file(File.join('..', '..', '..', 'spec', 'exemplars', 'user_exemplar.rb'), File.join('spec', 'exemplars', 'user_exemplar.rb'))


      ## generate spec_helper changes
      ## strictly this doesn't belong in this generator but seems the most appropriate without creating an additional
      m.gsub_file File.join('spec', 'spec_helper.rb'), /require \'spec\/rails\'/ do |match|
<<-STR
#{match}

def test_login_as(role = nil)
  user = (role.is_a?(Symbol) ? generate_user(role => true) : generate_user)
  controller.send :current_user=, user
end
alias :login :test_login_as

def generate_user(stubs = {})
  User.generate(stubs)
end
STR
      end
    end
  end
end
