
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
    error_user_action = nil
    user_actions = Array.new
    temp_params = user_action_params
    user_ids = temp_params[:user_id].split(',')
    user_ids.each do |user_id|
      temp_params[:user_id] = user_id.strip.to_i
      user_action = UserAction.new(temp_params)
      if user_action.save
        user_actions << user_action
      else
        error_user_action = user_action
        break
      end
    end

    if !error_user_action.nil?
      user_actions.each do |user_action|
        user_action.destroy
      end
    end

    respond_to do |format|
      if error_user_action.nil?
        format.html { redirect_to user_actions[0], notice: 'User action was successfully created.' }
        format.json { render :show, status: :created, location: user_actions[0] }
      else
        format.html { render(:file => File.join(Rails.root, 'public/500.html'), :status => 500, :layout => false) }
        format.json { render json: error_user_action.errors, status: :unprocessable_entity }
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
