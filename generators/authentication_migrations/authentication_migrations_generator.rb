class AuthenticationMigrationsGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.directory File.join('db', 'migrate')

      Dir.entries(File.join(File.dirname(__FILE__), 'templates', 'migrations')).each do |file_name|
        m.file(File.join('migrations', file_name), File.join('db', 'migrate', file_name)) if file_name.match(/\.rb$/)
      end
    end
  end
end
