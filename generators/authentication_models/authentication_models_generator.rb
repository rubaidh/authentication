class AuthenticationModelsGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.directory File.join('app', 'models')
      m.file(File.join('..', '..', '..', 'app', 'models', 'user.rb'), File.join('app', 'models', 'user.rb'))
    end
  end
end
