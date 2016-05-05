class QuestionAnswerPair
    attr_accessor :question
    attr_accessor :answer
end

class NewAccountController < ApplicationController   
    def initialize
        super
    end

    def index
        user_id = session[:user_id]
        actions = UserAction.where("user_id = " + user_id.to_s)

        @user = User.find(user_id)

        @num_actions = actions.count

        actions_array = actions.to_a

        @questions = Array.new

        actions_array.each do |cur_action|

            if (cur_action.action_type == 0)
                qaPair = QuestionAnswerPair.new

                qaPair.question = Question.find(cur_action.action_id)
                qaPair.answer = QuestionAnswer.new

                @questions << qaPair
            end
        end
    end

    def enter_answer
    end
end
