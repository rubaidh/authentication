class AuthenticationGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.dependency 'authentication_features', [], :collision => :skip
      m.dependency 'authentication_migrations', [], :collision => :skip
      m.dependency 'authentication_models', [], :collision => :skip
      m.dependency 'authentication_assets', [], :collision => :skip
    end
  end
end
