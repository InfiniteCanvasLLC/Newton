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

    def leave_group
        @user = User.find(params[:user])
        @party = Party.find(params[:party])

        @user.parties.delete(@party)

        redirect_to action: 'edit', id: @user.id
    end
end
