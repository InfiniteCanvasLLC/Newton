class NewAccountController < ApplicationController   
    def initialize
        super
    end

    def index
        user_id = session[:user_id]
        actions = UserAction.where("user_id = " + user_id.to_s)

        byebug
    end
end
