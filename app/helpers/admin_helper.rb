# Admin Helper
#
# Created on April 30, 2009 15:41 by Mark Connell as part
# of the "authentication" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++

module AdminHelper

  def generate_admin_navigation
    # Dig into the routes and pull out all the admin ones
    routes = ActionController::Routing::Routes.routes.collect do |route|
      route.segments.to_s if route.segments.to_s.match(/^\/admin/)
    end.compact.flatten

    # get the unqiue controller names
    controllers = routes.map { |route| route.gsub(/^\/admin\/([^(\/]+).*$/, "\\1")}.uniq - ['/admin/']

    current_location = request.request_uri.gsub(/^\/admin\/([^(\/]+).*$/, "\\1")
    if current_location =~ /^\/admin\/?$/
      current_location = ActionController::Routing::Routes.routes.find { |s| s.segments.to_s == "/admin/" }.requirements[:controller].gsub('admin/', '')
    end

    output_string = "<ul>"
    controllers.each do |name|
      output_string << content_tag("li#{" class=\"active\"" if current_location == name}", link_to("#{name.humanize}", "/admin/#{name}"))
    end
    output_string << "</ul>"
    output_string
  end

end
