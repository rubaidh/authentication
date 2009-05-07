# User Exemplar
#
# Created on April 29, 2009 11:35 by Mark Connell as part
# of the "authentication" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++

User.class_eval do
  generator_for :first_name, 'John'
  generator_for :last_name, 'Doe'
  generator_for :administrator, false
end
