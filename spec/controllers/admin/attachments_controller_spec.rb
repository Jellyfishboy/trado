require 'rails_helper'

describe Admin::AttachmentsController do

    store_setting
    login_admin

    describe 'DELETE #destroy' do
        let!(:attachment) { create(:product_attachment, attachable: product) }
        let!(:single_attachment) { create(:product) }

        it "should assign the requested attachment to @attachment" do
            xhr :delete, :destroy, product_id: attachment.product.id, id: attachment.id
            expect(assigns(:attachment)).to eq attachment
        end

        context "if the parent item attachment count is more than one" do

            it "should destroy the attachment" do
                expect{
                    xhr :delete, :destroy, product_id: attachment.product.id, id: attachment.id
                }.to change(Attachment, :count).by(-1)
            end

            it "should render the destroy partial" do
                xhr :delete, :destroy, product_id: attachment.product.id, id: attachment.id
                expect(response).to render_template(partial: 'admin/products/attachments/_destroy')
            end
        end
    end
end