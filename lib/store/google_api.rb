require 'google/api_client'
module Store

    class GoogleApi
        attr_reader :application_name, :application_version, :service


        def initialize data
            @application_name       = data[:app_name]
            @application_version    = data[:app_version]
            @google_service         = data[:service]
        end

        def client
            @cached_client ||= Google::APIClient.new(
                application_name: application_name,
                application_version: application_version
            )
        end

        def service
            client.discovered_api(google_service)
        end
    end
end