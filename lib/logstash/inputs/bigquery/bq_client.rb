require 'google/cloud/bigquery'


module LogStash
  module Inputs
    module BigQuery

      class BQClient

        def initialize(json_key_file, project_id, query, logger)
          @logger = logger

          @client = initialise_google_client json_key_file, project_id
          @query  = query.gsub("\\", "")
        end


        def search(priority)
          run_time  = Time.now.utc.strftime("%Y-%m-%d %H:%M:%S")
          query_job = @client.query_job(@query, priority: priority, params: { run_time: run_time }, types: { run_time: :TIMESTAMP })

          @logger.debug("Created query job in #{query_job.gapi.job_reference.location}")
          @logger.debug("Final query: #{query_job.gapi.configuration.query.query}")

          query_job.wait_until_done!

          if query_job.done? && !query_job.failed?
            return query_job.query_results
          end
        end


        private

        def initialise_google_client(json_key_file, project_id)
          @logger.info("Initializing Google API client [#{project_id}] with key located @ #{json_key_file}")
          err = get_key_file_error json_key_file
          raise err unless err.nil?

          creds = Google::Cloud::Bigquery::Credentials.new json_key_file

          Google::Cloud::Bigquery.new(
            project_id:  project_id,
            credentials: creds
          )
          # Need to also set
          # .setHeaderProvider(http_headers())
          # .setRetrySettings(retry_settings())
        end

        # raises an exception if the key file is invalid
        def get_key_file_error(json_key_file)
          return nil if nil_or_empty?(json_key_file)

          abs = ::File.absolute_path json_key_file
          unless abs == json_key_file
            return "json_key_file must be an absolute path: #{json_key_file}"
          end

          unless ::File.exist? json_key_file
            return "json_key_file does not exist: #{json_key_file}"
          end

          nil
        end

        def nil_or_empty?(param)
          param.nil? || param.empty?
        end
      end
    end
  end
end
