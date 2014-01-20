require 'spec_helper'

describe Admin::TransactionsController do

    login_admin

    describe 'GET #index' do
            it "populates an array of all transactions" do
                transaction_1 = create(:transaction)
                transaction_2 = create(:transaction)
                get :index
                expect(assigns(:transactions)).to match_array([transaction_1, transaction_2])
            end
            it "renders the :index template" do
                get :index
                expect(response).to render_template :index
            end
    end

end