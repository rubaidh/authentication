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

    output_string = "<ul>"
    controllers.each do |name|
      output_string << content_tag("li#{" class=\"active\"" if controller_name == name.pluralize}", link_to("#{name.humanize}", "/admin/#{name}"))
    end
    output_string << "</ul>"
    output_string
  end

end
