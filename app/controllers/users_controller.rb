class UsersController < ApplicationController
    layout "creative"
    
    def index
        @current_nav_selection = "nav_users"
    
        @users = User.all
    end

    def edit
        @current_nav_selection = "nav_users"
        
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

        #if we are removing the current user form the party they set as their current party
        if(@user.party_at_index(@user.current_party_index).id ==  @party.id)
            @user.current_party_index = [0, @user.current_party_index - 1].max
        end

        @user.parties.delete(@party)

        redirect_to action: 'edit', id: @user.id
    end
end
