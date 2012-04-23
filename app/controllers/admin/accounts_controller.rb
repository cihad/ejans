module Admin
  class AccountsController < BaseController
    load_and_authorize_resource
    
    def index
      @accounts = Account.includes(subscriptions: :service)
    end
  end
end