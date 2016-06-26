class AdministratorController < ApplicationController
    layout "administrator"

    before_filter :verify_administrator

end
