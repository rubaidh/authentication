class AuthenticationControllersGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.directory(File.join('app', 'controllers'))
      m.directory(File.join('app', 'controllers', 'admin'))

      Dir.entries(File.join(File.dirname(__FILE__), 'templates')).each do |file_name|
        m.file file_name, File.join('app', 'controllers', file_name) if file_name.match(/\.rb$/)
      end

      Dir.entries(File.join(File.dirname(__FILE__), 'templates', 'admin')).each do |file_name|
        m.file File.join('admin', file_name), File.join('app', 'controllers', 'admin', file_name) if file_name.match(/\.rb$/)
      end
    end
  end
end
