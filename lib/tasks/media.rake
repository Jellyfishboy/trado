namespace :media do
    desc "Reprocesses all the carrierwave media files"
    task :reprocess => :environment do
        Attachment.all.each do |attachment|
            attachment.file.recreate_versions!
        end
    end
end