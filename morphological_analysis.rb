require 'natto'


class MorphologicalAnalysis

  def initialize
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
    morphologies
  end

end
