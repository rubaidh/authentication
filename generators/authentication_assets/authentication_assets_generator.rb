class AuthenticationAssetsGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.directory(File.join('public', 'stylesheets'))

      m.file('403.html', File.join('public', '403.html'))
      m.file(File.join('stylesheets', 'base.css'), File.join('public', 'stylesheets', 'base.css'))
      m.file(File.join('stylesheets', 'style.css'), File.join('public', 'stylesheets', 'style.css'))
    end
  end
end
