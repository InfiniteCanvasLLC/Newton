class QuestionAnswerPair
    attr_accessor :question
    attr_accessor :answer
end

class UsersController < ApplicationController
    layout "administrator"
    before_action :set_user, only: [:show, :edit, :update]

    before_filter :verify_administrator

    def index
        @current_nav_selection = "nav_users"

        @users = User.all
    end

    def edit
        @current_nav_selection = "nav_users"

        @all_parties = Party.all
        @user_parties = @user.parties;
    end

    def show
        # Unanswered Questions
        @questions = Array.new

        actions = UserAction.where("user_id = " + params[:id].to_s)
        actions.to_a.each do |action|
            if (action.action_type == 0) #0 = Question
                @questions << Question.find(action.action_id)
            elsif (action.action_type == 1) #1 = Link To
                #TODO
            end
        end

        # Answered Question
        @questions_answers = Array.new

        answers = QuestionAnswer.where("user_id = " + params[:id].to_s)
        answers.to_a.each do |answer|
            qaPair = QuestionAnswerPair.new

            qaPair.question = Question.find(answer.question_id)
            qaPair.answer = answer

            @questions_answers << qaPair
        end

        # Metadata
        @metadata = Array.new
        @metadata_types = UserMetadatum.type_name_to_type_id_array

        metadata = UserMetadatum.where("user_id = " + params[:id].to_s)
        metadata.each do |metadatum|
            @metadata << metadatum
        end
    end

    def update
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

    def send_email
        Outreach.mail_to_user_id(params[:id], params[:email_subject], params[:email_body]).deliver_now
        render nothing: true
    end

    def create_metadata
        @metadatum           = UserMetadatum.new
        @metadatum.user_id   = params[:id]
        @metadatum.data_type = params[:data_type]
        @metadatum.data      = params[:data]
        @metadatum.save
        render json: @metadatum
    end

    def destroy_metadata
        UserMetadatum.find(params[:metadatum_id]).destroy
        render nothing: true
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
        @user = User.find(params[:id])
    end
end
