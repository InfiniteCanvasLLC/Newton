
class UserActionsController < ApplicationController

  layout "administrator"

  before_action :set_user_action, only: [:show, :edit, :update, :destroy]
  before_action :set_user_action_types, only: [:new, :edit]
  before_filter :verify_administrator

  # GET /user_actions
  # GET /user_actions.json
  def index
    @current_nav_selection = "nav_user_actions"

    @user_actions = UserAction.all
  end

  # GET /user_actions/1
  # GET /user_actions/1.json
  def show
    @current_nav_selection = "nav_user_actions"
  end

  # GET /user_actions/new
  def new
    @current_nav_selection = "nav_user_actions"

    @user_action = UserAction.new

    @users = User.all.to_a
    @questions = Question.all.to_a
    @link_tos  = LinkTo.all.to_a
  end

  # GET /user_actions/1/edit
  def edit
    @current_nav_selection = "nav_user_actions"

    @users = User.all.to_a
    @questions = Question.all.to_a
    @link_tos  = LinkTo.all.to_a
  end

  # POST /user_actions
  # POST /user_actions.json
  def create
    @user_action = UserAction.new(user_action_params)

    if @user_action.is_question() == true
      Outreach.mail_to_user_id(@user_action.user_id, "Quick question",
      "We have assigned you a small question. You can find it on your home page. Please take the time to answer it as it will improve our recommendation.\nCheck it out on Audicy.us").deliver_now
    elsif @user_action.is_linkto() == true
      Outreach.mail_to_user_id(@user_action.user_id, "Check it out",
      "We have found something you might be interested in. You can find it on your home page.\nCheck it out on Audicy.us").deliver_now
    end

    respond_to do |format|
      if @user_action.save
        format.html { redirect_to @user_action, notice: 'User action was successfully created.' }
        format.json { render :show, status: :created, location: @user_action }
      else
        format.html { render(:file => File.join(Rails.root, 'public/500.html'), :status => 500, :layout => false) }
        format.json { render json: @user_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_actions/1
  # PATCH/PUT /user_actions/1.json
  def update
    respond_to do |format|
      if @user_action.update(user_action_params)
        format.html { redirect_to @user_action, notice: 'User action was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_action }
      else
        format.html { render :edit }
        format.json { render json: @user_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_actions/1
  # DELETE /user_actions/1.json
  def destroy
    @user_action.destroy
    respond_to do |format|
      format.html { redirect_to user_actions_url, notice: 'User action was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_action
      @user_action = UserAction.find(params[:id])
    end

    def set_user_action_types
      @user_actions_types_list = UserAction.get_type_name_to_id_array
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_action_params
      params.require(:user_action).permit(:user_id, :action_type, :action_id)
    end
end
