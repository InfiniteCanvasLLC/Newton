class QuestionAnswerPair
    attr_accessor :question
    attr_accessor :answer
    attr_accessor :action_id
end

class NewAccountController < ApplicationController   

    def initialize
        super
    end

    def home
        user_id = session[:user_id]
        actions = UserAction.where("user_id = " + user_id.to_s)

        @user = User.find(user_id)
        @num_actions = actions.count

        actions_array = actions.to_a

        @questions = Array.new
        @current_nav_selection = "nav_home"

        #if current user id invalid (party deleted for instance)
        @current_user_party = get_user_current_party(@user)
        @current_user_party_name = @current_user_party.name;

        actions_array.each do |cur_action|

            if (cur_action.action_type == 0)
                qaPair = QuestionAnswerPair.new

                qaPair.question = Question.find(cur_action.action_id)
                qaPair.answer = QuestionAnswer.new
                qaPair.action_id = cur_action.id

                @questions << qaPair
            end
        end
    end

    def enter_answer
        questionAnswer = QuestionAnswer.new

        action = UserAction.find(params[:action_id])

        questionAnswer.question_id = action.action_id
        questionAnswer.user_id = session[:user_id]
        questionAnswer.answer_integer = params[:answer_integer]
        questionAnswer.answer_text = params[:answer_text]

        questionAnswer.save

        action.destroy

        render nothing: true
    end

    def switch_party
        user_id = session[:user_id]
        @user = User.find(user_id)
        @user.current_party_index = params[:party_index]
        @user.save
        redirect_to action: 'home'
    end

    def leave_party
        @user = User.find(params[:user])
        @party = Party.find(params[:party])
        @user.current_party_index = [0, @user.current_party_index - 1].max
        @user.parties.delete(@party)
        @user.save
    end

    def create_party
    #@TODO: Check for param validity (is there a party with the same name?)
        user_id = session[:user_id]
        @user = User.find(user_id)

        party = Party.new
        party.name = params[:name]
        party.description = params[:description]
        party.owner_user_id = user_id
        party.save

        #since the user created it, they are part of it
        @user.parties << party

        redirect_to action: 'party'
    end

    def edit_party
        #get and modify the party
        party = Party.find(params[:party_id])
        party.name = params[:name]
        party.description = params[:description]
        party.save

        redirect_to action: 'party'
    end

    def join_party
    end

    def calendar
        user_id = session[:user_id]
        @user = User.find(user_id)
        @current_party = get_user_current_party(@user)

        @current_nav_selection = "nav_calendar"
    end

    def stats
        @current_nav_selection = "nav_stats"
    end

    def party
        user_id = session[:user_id]
        @user = User.find(user_id)
        @current_user_party = get_user_current_party(@user)
        @all_parties = Party.all
        @current_nav_selection = "nav_party"
    end

    def feedback
        @current_nav_selection = "nav_feedback"
    end

    def profile
        @current_nav_selection = ""
    end

    def settings
        @current_nav_selection = ""
    end
    
    private

    #this function returns the user's current party
    def get_user_current_party(user)
        # if the @user.current_party_index is invalid in any way, this will returns user.pary[0]
        if user.current_party_index >= user.parties.count
            user.current_party_index = 0
            user.save
        end

        # if user.parties is empty we create a default party 0
        if user.parties.count == 0
           default_party = Party.new
           default_party.name = user.name + "'s Party"
           default_party.owner_user_id = user.id
           default_party.save
           user.parties << default_party
        end

        return user.party_at_index( user.current_party_index.to_i )
    end

end
