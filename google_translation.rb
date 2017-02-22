require 'json'
require 'faraday'


class GoogleTranslation

  # initialize
  def initialize(api_key)
    @base_uri = "https://translation.googleapis.com/"
    @api_key = api_key
  end

  def get_language_translation(q, source, target)
    uri_string = "#{@base_uri}language/translate/v2"
    connection = Faraday.new(:url => uri_string) do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end

    response = connection.get do |request|
      request.params['key'] = @api_key
      request.params['source'] = source
      request.params['target'] = target
      request.params['q'] = q
      request.headers['Content-Type'] = 'application/json'
      request.options.timeout = 30
      request.options.open_timeout = 10
    end

    begin
      JSON.parse(response.body)
    rescue Exception => e
      {:application_code => 400}
    end
  end

end

