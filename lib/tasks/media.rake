namespace :media do
    desc "Reprocesses all the local carrierwave media files"
    task :reprocess_local => :environment do
        Attachment.all.each do |attachment|
            attachment.file.recreate_versions!
        end
    end

    desc "Reprocesses all the carrierwave media files which are stored using fog"
    task :reprocess_fog => :environment do
        Attachment.all.each do |attachment| 
          begin
            # attachment.process_file_uploader_upload = true # only if you use carrierwave_backgrounder
            attachment.file_uploader.cache_stored_file! 
            attachment.file_uploader.retrieve_from_cache!(attachment.file_uploader.cache_name) 
            attachment.file_uploader.recreate_versions! 
            attachment.save! 
          rescue => e
            puts  "ERROR: Attachment: #{attachment.id} -> #{e.to_s}"
          end
        end
    end
end