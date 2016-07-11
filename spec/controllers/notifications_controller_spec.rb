# require 'rails_helper'

# describe NotificationsController do

#     store_setting

#     describe 'POST #create' do
#         let(:category) { create(:category) }
#         let(:product) { create(:product, active: true, category_id: category.id) }
#         let(:sku) { create(:sku, active: true, product_id: product.id) }

#         context "with valid attributes" do
            
#             it "should save a new notification to the database" do
#                 expect{
#                     xhr :post, :create, category_id: category.id, product_id: product.id, sku_id: sku.id, notification: attributes_for(:notification)
#                 }.to change(Notification, :count).by(1)
#             end

#             it "should render the success partial" do
#                 xhr :post, :create, category_id: category.id, product_id: product.id, sku_id: sku.id, notification: attributes_for(:notification)
#                 expect(response).to render_template(partial: "themes/#{Store.settings.theme.name}/products/skus/notify/_success")
#             end
#         end

#         context "with invalid attributes" do
#             let(:errors) { "{\"email\":[\"is required\",\"is invalid\"]}" }

#             it "should not save the notification to the database" do
#                 expect{
#                     xhr :post, :create, category_id: category.id, product_id: product.id, sku_id: sku.id, notification: attributes_for(:notification, email: nil)
#                 }.to_not change(Notification, :count)
#             end

#             it "should return a JSON object of errors" do
#                 xhr :post, :create, category_id: category.id, product_id: product.id, sku_id: sku.id, notification: attributes_for(:notification, email: nil)
#                 expect(assigns(:notification).errors.to_json(root: true)).to eq errors
#             end

#             it "should return a 422 status code" do
#                 xhr :post, :create, category_id: category.id, product_id: product.id, sku_id: sku.id, notification: attributes_for(:notification, email: nil)
#                 expect(response.status).to eq 422
#             end
#         end
#     end
# end