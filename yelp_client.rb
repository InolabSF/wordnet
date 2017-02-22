require 'yelp'
require 'json'


class YelpClient

  # initialize
  def initialize
    @client = Yelp::Client.new(
      {
#        consumer_key: ENV['YELP_CONSUMER_KEY'],
#        consumer_secret: ENV['YELP_CONSUMER_SECRET'],
#        token: ENV['YELP_TOKEN'],
#        token_secret: ENV['YELP_TOKEN_SECRET']
        consumer_key: 'aEgsqiXtod6euKrDE3K7UQ',
        consumer_secret: '26Yr5oBbPkcdOnvb_j1UvoFJe1M',
        token: '1PC6SGoDEAXIQiojPiTJn48zCsbT8Sm9',
        token_secret: 'TIze7QMF6i_szxvwaXAobv9wXLo'
      }
    )
  end

  def search_by_bounding_box(bounding_box)
    begin
      get_hash_by_object(@client.search_by_bounding_box(bounding_box))
    rescue Exception => e
      {:application_code => 400}
    end
  end

  # search store by phone number
  #
  # @param [String] phone_number e.g. '+15555555555'
  # @return [Hash] reponse json
  def phone_search(phone_number)
    begin
      get_hash_by_object(@client.phone_search(phone_number))
    rescue Exception => e
      {:application_code => 400}
    end
  end

  # search business detail by business_id
  #
  # @param [String] business_id e.g. 'yelp-san-francisco'
  # @return [Hash] reponse json
  def business(business_id)
    begin
      get_hash_by_object(@client.business(business_id))
    rescue Exception => e
      {:application_code => 400}
    end
  end

  # get hash by object
  #
  # @param [Object] Ruby object
  # @return [Hash] reponse json
  def get_hash_by_object(object)
    json = {}

    object.instance_variables.each do |var|
      key = var.to_s.delete("@")
      value = object.instance_variable_get(var)
      if value.is_a? Array
        values = []
        value.each do |v|
          new_value = get_hash_by_object(v)
          values.push((new_value.empty?) ? value : new_value)
        end
        json[key] = values
      else
        new_value = get_hash_by_object(value)
        json[key] = (new_value.empty?) ? value : new_value
      end
    end

    json
  end

end

