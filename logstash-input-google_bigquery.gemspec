# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name            = 'logstash-input-google_bigquery'
  s.version         = ::File.read('plugin_version').split("\n").first
  s.licenses        = ['MIT']
  s.summary         = 'Pulls events to Google BigQuery'
  s.description     = 'Input plugin to fetch records from Google Cloud BigQuery'
  s.authors         = ['Mikhail Molotkov']
  s.require_paths   = ['lib', 'vendor/cache']

  # Files
  s.files = Dir['CONTRIBUTORS', 'Gemfile', 'LICENSE', 'NOTICE.TXT', 'VERSION', 'plugin_version',
                '*.gemspec', '*.md', 'lib/**/*', 'spec/**/*', 'docs/**/*', 'vendor/cache/*.gem']

  # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { 'logstash_plugin' => 'true', 'logstash_group' => 'input' }

  # Gem dependencies
  s.add_runtime_dependency 'google-cloud-bigquery', '~> 1.43', '>= 1.43.1'

  s.add_runtime_dependency 'logstash-codec-plain'
  s.add_runtime_dependency 'logstash-core',            '~> 8.4', '>= 8.4.0'
  s.add_runtime_dependency 'logstash-core-plugin-api', '>= 1.60', '<= 2.99'
  s.add_runtime_dependency "logstash-mixin-scheduler", '~> 1.0'

  # s.add_runtime_dependency 'mime-types', '~> 2' # last version compatible with ruby 2.x

  s.add_development_dependency 'logstash-devutils'
end
