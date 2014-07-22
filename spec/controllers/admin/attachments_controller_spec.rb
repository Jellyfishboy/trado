require 'rails_helper'

describe Admin::AttachmentsController do

    store_setting
    login_admin

    describe 'DELETE #destroy' do
        let!(:attachment) { create(:product_attachment) }
        let!(:single_attachment) { create(:product) }

        it "should assign the requested attachment to @attachment" do
            xhr :delete, :destroy, id: attachment.id
            expect(assigns(:attachment)).to eq attachment
        end

        context "if the parent item attachment count is more than one" do

            it "should destroy the attachment" do
                expect{
                    xhr :delete, :destroy, id: attachment.id
                }.to change(Attachment, :count).by(-1)
            end

            it "should render the destroy partial" do
                xhr :delete, :destroy, id: attachment.id
                expect(response).to render_template(partial: 'admin/products/attachments/_destroy')
            end
        end

        context "if the parent item attachment count is one or less" do

            it "should render the failed_destroy partial" do
                xhr :delete, :destroy, id: single_attachment.attachments.first.id
                expect(response).to render_template(partial: 'admin/products/attachments/_failed_destroy')
            end
        end
    end
end