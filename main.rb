require 'csv'
require 'json'
require 'lemmatizer'
require './yelp_client'
require './google_translation'
require './word_net'
require './morphological_analysis'


def get_text_by_message_csv(file_name)
  texts = []
  # read csv
  csv_reader = CSV.open(file_name, 'r', :col_sep => ',')
  csv_reader.each { |row| texts.push("#{row[0]}") }
  texts
end

def get_businesses_from_yelp(south, west, north, east)
  businesses = []

  yelp_client = YelpClient.new
  lat_offset = 0.01; lng_offset = 0.01
  lat = south; lng = west
  while lat < north do
    while lng < east do
      bounding_box = { :sw_latitude => lat, :sw_longitude => lng, :ne_latitude => lat+lat_offset, :ne_longitude => lng+lng_offset }
      new_businesses = yelp_client.search_by_bounding_box(bounding_box)["businesses"]
      businesses = businesses + new_businesses if new_businesses

      lng = lng + lng_offset
    end

    lat = lat + lat_offset
    lng = west
  end
  businesses
end


db_file = "wnjpn.db"
word_net = WordNet.new(db_file)
morphological_analysis = MorphologicalAnalysis.new
google_translation = GoogleTranslation.new("AIzaSyAPx393Z09-TIV7IIZkeqcAL1jgC76a4ZY")


#json = {}
#file_names = ["./resources/message/1.csv", "./resources/message/2.csv", "./resources/message/3.csv",]
#file_names.each do |file_name|
#  texts = get_text_by_message_csv(file_name)
#  texts.each do |text|
#    morphologies = morphological_analysis.get_morphologies_by_text(text)
#    morphologies.each do |morphology|
#      json[morphology] = word_net.get_relatives(morphology, 'jpn')
#    end
#  end
#end
#File.open("./resources/morphology.json","w") { |file| file.write(json.to_json) }


#south = 37.808; west = -122.410; north = 37.810; east = -122.408
##businesses = get_businesses_from_yelp(south, west, north, east)
##File.open("./resources/#{south},#{west},#{north},#{east}.json","w") { |file| file.write(businesses.to_json) }
#categories = []
#lemmatizer = Lemmatizer.new
#businesses = JSON.parse(File.read("./resources/#{south},#{west},#{north},#{east}.json"))
#businesses.each do |business|
#  business['categories'].each do |category_lists|
#    category_lists.each do |category_list|
#      category_list.each do |category|
#        morphologies = morphological_analysis.get_morphologies_by_text(category.downcase)
#        morphologies.each do |morphology|
#          word = lemmatizer.lemma(morphology, :noun)
#          next if word.length < 3
#          categories.push(word) unless categories.include?(word)
#        end
#      end
#    end
#  end
#end
#
#ja_categories = {}
#categories.each do |category|
#  ja_categories[category] = []
#
#  json = google_translation.get_language_translation(category, 'en', 'ja')
#  next unless json["data"]
#  next unless json["data"]["translations"]
#  translations = json["data"]["translations"]
#  translations.each do |translation|
#    ja_categories[category].push(translation["translatedText"])
#  end
#end
#File.open("./resources/ja_categories.json","w") { |file| file.write(ja_categories.to_json) }
#
#expanded_ja_categories = {}
#ja_categories = JSON.parse(File.read("./resources/ja_categories.json"))
#ja_categories.each do |category, ja_category_list|
#  ja_category_list.each do |ja_category|
#    expanded_ja_categories[ja_category] = [] unless expanded_ja_categories[ja_category]
#    relatives = word_net.get_relatives(ja_category, 'jpn')
#    next unless relatives
#    relatives.each do |relative|
#      expanded_ja_categories[ja_category].push(relative) unless expanded_ja_categories[ja_category].include? relative
#    end
#  end
#end
#File.open("./resources/expanded_ja_categories.json","w") { |file| file.write(expanded_ja_categories.to_json) }



word_net.close_db
