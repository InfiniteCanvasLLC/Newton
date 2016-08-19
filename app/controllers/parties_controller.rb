class PartiesController < ApplicationController
  layout "administrator"

  before_action :set_nav
  before_action :set_party, only: [:show, :edit, :update, :destroy]
  before_filter :verify_administrator

  # GET /parties
  # GET /parties.json
  def index
    @parties = Party.all
  end

  # GET /parties/1
  # GET /parties/1.json
  def show
    # Metadata
    @metadata = PartyMetadatum.where("party_id = " + params[:id].to_s).to_a
    @metadata_types = PartyMetadatum.type_name_to_type_id_array
  end

  # GET /parties/new
  def new
    @party = Party.new
  end

  # GET /parties/1/edit
  def edit
    @all_events = Event.all
    #@party_events = @party.events.to_a #Event.all.to_a
    #party = Party.find(params[:id])
    #@party.events << Event.find(1)
  end

  def unregister_for_event
     @party = Party.find(params[:party])
     @event = Event.find(params[:event])

     #remove all the event registration in this party for this event
     @party.event_registrations.where("event_id" => @event.id).delete_all
     #remove the event
     @party.events.delete(@event)

     redirect_to action: 'edit', id: @party.id
  end

  def register_for_event(event_id)
    event = Event.find(event_id)

    Outreach.event_registration(@party).deliver_now


    #prevents double insert
    if @party.events.exists?( event.id ) == false
      @party.events << event
      #create registration for each member in the party
      @party.users.each do |user|
        reg = EventRegistration.new
        reg.party_id   = @party.id
        reg.user_id    = user.id
        reg.event_id   = event.id
        reg.commitment = EventRegistration.user_going #by default
        reg.save
      end
    end
  end

  # POST /parties
  # POST /parties.json
  def create
    user = nil
    fail = false

    if (session[:user_id] != nil)
      user = User.find(session[:user_id])
    else
      fail = true
    end

    if (user != nil)
      @party = Party.new(party_params)
      @party.owner_user_id = user.id #by default, the Admin whom create the party
    else
      fail = true
    end

    respond_to do |format|
      if !fail && @party.save
        format.html { redirect_to @party, notice: 'Party was successfully created.' }
        format.json { render :show, status: :created, location: @party }
      else
        format.html { render(:file => File.join(Rails.root, 'public/500.html'), :status => 500, :layout => false) }
        format.json { render json: @party.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parties/1
  # PATCH/PUT /parties/1.json
  def update
    if params[:party][:event_id].nil? == false
      self.register_for_event( params[:party][:event_id] )
    end

    respond_to do |format|
      if @party.update(party_params)
        format.html { redirect_to @party, notice: 'Party was successfully updated.' }
        format.json { render :show, status: :ok, location: @party }
      else
        format.html { render :edit }
        format.json { render json: @party.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parties/1
  # DELETE /parties/1.json
  def destroy
    @party.destroy
    respond_to do |format|
      format.html { redirect_to parties_url, notice: 'Party was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def send_email
    self.mail_to_party_id(params[:id], params[:email_subject], params[:email_body])
    render nothing: true
  end

  def create_metadata
    @metadatum           = PartyMetadatum.new
    @metadatum.party_id  = params[:id]
    @metadatum.data_type = params[:data_type]
    @metadatum.data      = params[:data]
    @metadatum.save

    hash = Hash.new
    hash["id"]   = @metadatum.id
    hash["name"] = @metadatum.data_type_name
    hash["data"] = @metadatum.data

    render json: hash
  end

  def destroy_metadata
    PartyMetadatum.find(params[:metadatum_id]).destroy
    render nothing: true
  end

  def view_join_requests
    @join_requests = JoinPartyRequest.all.order(:party_id)
  end

  def view_party_invites
    @party_invites = PartyInvite.all.order(:party_id)
  end


  private
    # Use setting the correct nav value for the expanded side nav.
    def set_nav
      @current_nav_selection = "nav_parties"
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_party
      @party = Party.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def party_params
      params.require(:party).permit(:name, :description)
    end
end
