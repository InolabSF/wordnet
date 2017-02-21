require 'csv'
require 'natto'
require './word_net'


def get_text_by_csv(file_name)
  texts = []
  # read csv
  csv_reader = CSV.open(file_name, 'r', :col_sep => ',')
  csv_reader.each { |row| texts.push("#{row[0]}") }
  texts
end

def get_morphologies_by_text(text)
  # mecab
  natto = Natto::MeCab.new
  morphology_string = natto.parse(text)
  morphology_strings = morphology_string.split("\n")
  morphology_strings = morphology_strings[0...-1]
  # morphologies
  morphologies = []
  #word_classes = ['動詞', '形容詞', '形容動詞', '名詞', '感動詞',]
  word_classes = ['名詞']
  morphology_strings.each do |string|
    morphology = string.split("\t")
    will_store = false
    word_classes.each { |word_class| will_store = true and break if "#{morphology.last}".start_with?(word_class) }
    morphologies.push(morphology.first) if will_store
  end
  morphologieis
end



db_file = "wnjpn.db"
word_net = WordNet.new(db_file)

file_names = ["1.csv", "2.csv", "3.csv",]
file_names.each do |file_name|
  texts = get_text_by_csv(file_name)
  texts.each do |text|
    morphologies = get_morphologies_by_text(text)
    puts '///////////////////////////////////'
    morphologies.each do |morphology|
      puts morphology
      puts '--'
      puts word_net.get_relatives(morphology, 'jpn')
    end
  end
end

word_net.close_db
