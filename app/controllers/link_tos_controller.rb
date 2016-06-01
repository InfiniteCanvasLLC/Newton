class LinkTosController < ApplicationController
  before_action :set_link_to, only: [:show, :edit, :update, :destroy]
  layout "administrator"
  
  # GET /link_tos
  # GET /link_tos.json
  def index
    @current_nav_selection = "nav_linktos"
    @link_tos = LinkTo.all
  end

  # GET /link_tos/1
  # GET /link_tos/1.json
  def show
    @current_nav_selection = "nav_linktos"
  end

  # GET /link_tos/new
  def new
    @current_nav_selection = "nav_linktos"
    @link_to = LinkTo.new
  end

  # GET /link_tos/1/edit
  def edit
    @current_nav_selection = "nav_linktos"
  end

  # POST /link_tos
  # POST /link_tos.json
  def create
    @link_to = LinkTo.new(link_to_params)

    respond_to do |format|
      if @link_to.save
        format.html { redirect_to @link_to, notice: 'Link to was successfully created.' }
        format.json { render :show, status: :created, location: @link_to }
      else
        format.html { render :new }
        format.json { render json: @link_to.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /link_tos/1
  # PATCH/PUT /link_tos/1.json
  def update
    respond_to do |format|
      if @link_to.update(link_to_params)
        format.html { redirect_to @link_to, notice: 'Link to was successfully updated.' }
        format.json { render :show, status: :ok, location: @link_to }
      else
        format.html { render :edit }
        format.json { render json: @link_to.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /link_tos/1
  # DELETE /link_tos/1.json
  def destroy
    @link_to.destroy
    respond_to do |format|
      format.html { redirect_to link_tos_url, notice: 'Link to was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link_to
      @link_to = LinkTo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def link_to_params
      params.require(:link_to).permit(:title, :description, :url, :link_text, :icon_style, :panel_style, :type_id)
    end
end
