require 'faraday_middleware/aws_signers_v4'
es_client = Elasticsearch::Client.new({
  log: true,
  url: ENV['ELASTICSEARCH_URL'],
  port: 443,
  scheme: "https",
  retry_on_failure: true,
  transport_options: {
    request: { timeout: 10 }
  }
}) do |f|
  f.request(
    :aws_signers_v4,
    credentials: Aws::Credentials.new(ENV.fetch('AWS_ACCESS_KEY_ID'), ENV.fetch('AWS_SECRET_ACCESS_KEY')),
    service_name: 'es',
    region: ENV.fetch('AWS_REGION')
  )
end

Searchkick.aws_credentials = {
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  region: ENV['AWS_REGION']
}

Elasticsearch::Model.client = es_client
Searchkick.client = es_client