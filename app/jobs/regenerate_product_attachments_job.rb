class RegenerateProductAttachmentsJob < ActiveJob::Base
    queue_as :default

    def perform *args
        Product.all.each do |u|
            u.attachments.each do |attachment|
                next if attachment.file.blank?
                attachment.file.recreate_versions!(:square, :small, :medium, :large)
                attachment.save!
            end
        end
    end
end
