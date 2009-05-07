class AuthenticationFeaturesGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.dependency 'cucumber', [], :collision => :skip

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
    end
  end
end
