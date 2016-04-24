class NewAccountController < ApplicationController   
    def initialize
        super
    end

    def index
        user_id = session[:user_id]
        actions = UserAction.where("user_id = " + user_id.to_s)

        @num_actions = actions.count

        actions_array = actions.to_a

        @display_actions = Array.new

        actions_array.each do |cur_action|
            cur_display_action = Hash.new

            if (cur_action.action_type == 0)
                cur_display_action["type"] = "Question"

                question = Question.find(cur_action.action_id)

                cur_display_action["text"] = question.text
            end

            @display_actions << cur_display_action
        end
    end
end
