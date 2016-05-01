class UsersController < ApplicationController

    def index
        @users = User.all
    end

    def edit
        @user = User.find(params[:id])
        @all_parties = Party.all
        @user_parties = @user.parties;
    end

    def update        
        @user = User.find(params[:id])
        @party = Party.find(params[:user][:party_id])

        @user.parties << @party

        redirect_to :action => 'index'
    end
end
