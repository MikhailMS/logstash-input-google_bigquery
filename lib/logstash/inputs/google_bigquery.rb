require 'logstash/inputs/base'
require 'logstash/namespace'
require 'logstash/json'

require "logstash/plugin_mixins/scheduler"

require 'logstash/inputs/bigquery/bq_client'
#
# === Summary
#
# This plugin fetches data from Google Cloud BigQuery
# It can either do so as a one-shot operation or at the provided frequency
#
# === Usage
# This is an example of logstash config:
#
# [source,ruby]
# --------------------------
# input {
#    google_bigquery {
#      project_id     => "test-bigquery-project" (required)
#      dataset        => "logs"                  (required)
#      table_name     => "test"                  (required)
#      json_key_file  => "/path/to/key.json"     (optional) *
#
#      region         => "europe-west1"          (optional)    
#      query          => "SELECT 1"              (optional)
#      schedule       => "* * * * *"             (optional)
#    }
# }
#
# * If the key is not used, then the plugin tries to find
#   https://cloud.google.com/docs/authentication/production[Application Default Credentials]
#
# --------------------------

class LogStash::Inputs::GoogleBigQuery < LogStash::Inputs::Base

  include LogStash::PluginMixins::Scheduler


  config_name 'google_bigquery'

  default :codec, 'plain'

  # Google Cloud Project ID
  config :project_id,    validate: :string, required: true

  # The BigQuery dataset
  config :dataset,       validate: :string, required: true

  # BigQuery table name
  config :table_name,    validate: :string, required: true

  # Specify path to Service Account JSON key file
  config :json_key_file, validate: :string, required: false


  # Specify query to execute
  config :query,    validate: :string, required: false

  # Specify region where Job would be executed
  config :region,   validate: :string, required: false, default: 'us-central1'
  
  # Specify schedule (in Cron format) to periodically run the query
  config :schedule, validate: :string, required: false


  def register
    @logger.debug('Registering Google Cloud BigQuery input plugin')

    @bq_client = LogStash::Inputs::BigQuery::BQClient.new @json_key_file, @project_id, @region, @query, @logger
    @stopping  = Concurrent::AtomicBoolean.new(false)
  end


  def run(queue)
    if @schedule
      # Run scheduler
      scheduler.cron(@schedule) { execute_search(queue) }
      scheduler.join
    else
      # Run once
      execute_search(queue)
    end
  end

  def execute_search(queue)
    result = @bq_client.search()
    @logger.info("Results: #{result}")
    # @codec.decode(result) do |event|
    #   queue << result
    # end
  end

  def stopping?
    @stopping.value
  end

  def close
    @stopping.make_true
  end
end
