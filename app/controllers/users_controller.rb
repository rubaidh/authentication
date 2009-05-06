# User Controller
#
# Created on April 29, 2009 11:35 by Mark Connell as part
# of the "authentication" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++

class UsersController < AuthenticatableController
  skip_before_filter :login_required, :only => [:show, :new, :create]

  def show
    respond_to do |format|
      format.html { redirect_to new_user_path }
    end
  end

  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html # create.html.erb
      else
        format.html { render :action => "new" }
      end
    end
  end

end
