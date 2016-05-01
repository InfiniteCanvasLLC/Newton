class UsersController < ApplicationController

    def index
        @users = User.all
    end

    def edit
        @user = User.find(params[:id])
        @all_parties = Party.all
    end


end
