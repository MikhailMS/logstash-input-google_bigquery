# Logstash Google Cloud BigQuery input plugin


This is an input plugin for [Logstash](https://github.com/elastic/logstash) to enable consumption of data from Google Cloud BigQuery


## Building
0. To build the plugin, you need to have:
    1. JRuby    installed
    2. Java     installed
    3. Logstash binaries
1. It is recommended to have `rbenv` installed, so you can install any required JRuby (as logstash gets upgraded, you may need newer JRuby each time you build plugin for that version of logstash)
2. It is recommended to have `jenv`  installed, so you can install any required Java  (as logstash gets upgraded, you may need newer Java  each time you build plugin for that version of logstash)
3. You need to set 2 env varialbes
```bash
export LOGSTASH_PATH=/path/to/logstash/binaries
export LOGSTASH_SOURCE=1
```
4. Install dependencies*
```sh
bundle install
bundle exec rake vendor
```
5. Build plugin
```sh
gem build logstash-input-google_bigquery.gemspec
```


## Test
- Run tests

```sh
bundle exec rspec
```


## Use plugin in Logstash
1. Build plugin locally
2. Install plugin to the local version of Logstash that was used to build the plugin
3. Once plugin is installed to local Logstash, create offline-package with the plugin
```sh
./bin/logstash-plugin prepare-offline-pack logstash-input-google_bigquery
```
4. Deploy artifact generated in Step 3 onto server where Logstash runs
5. To install offline-package run following command from Logstash directory
```sh
./bin/logstash-plugin install --local file:///path/to/custom/plugin.zip
```


## Notes:
1. If plugin is used on Logstash that is behind proxies, ensure to add below flags when starting Logstash process
```
export HTTPS_PROXY=<proxy_url>:<proxy_port>
```
2. *Sometimes you can face an issue that some gems are too old - in this case you need to upgrade the gems versions in `build.gradle`
