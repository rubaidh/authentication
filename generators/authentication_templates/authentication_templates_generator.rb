class AuthenticationTemplatesGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      # copy over the layout files since they are likely to be changes and makes it easier to
      # do just that.
      m.directory(File.join('app', 'views', 'layouts'))
      m.file( File.join('..', '..', '..', 'app', 'views', 'layouts', 'application.html.erb'),
              File.join('app', 'views', 'layouts', 'application.html.erb') )

      m.file( File.join('..', '..', '..', 'app', 'views', 'layouts', 'admin.html.erb'),
              File.join('app', 'views', 'layouts', 'admin.html.erb') )

      # copy over the mailer templates aswell since we will most probably want them in the main
      # app so they can be easily edited to maintain a consistency with other templates.
      m.directory(File.join('app', 'views', 'user_mailer'))
      m.file( File.join('..', '..', '..', 'app', 'views', 'user_mailer', 'activation_request.erb'),
              File.join('app', 'views', 'user_mailer', 'activation_request.erb') )

      m.file( File.join('..', '..', '..', 'app', 'views', 'user_mailer', 'activation_confirmation.erb'),
              File.join('app', 'views', 'user_mailer', 'activation_confirmation.erb') )

      m.file( File.join('..', '..', '..', 'app', 'views', 'user_mailer', 'deletion_notice.erb'),
              File.join('app', 'views', 'user_mailer', 'deletion_notice.erb') )

      m.file( File.join('..', '..', '..', 'app', 'views', 'user_mailer', 'password_reset.erb'),
              File.join('app', 'views', 'user_mailer', 'password_reset.erb') )

      m.file( File.join('..', '..', '..', 'app', 'views', 'user_mailer', 'suspension_notice.erb'),
              File.join('app', 'views', 'user_mailer', 'suspension_notice.erb') )
    end
  end
end
