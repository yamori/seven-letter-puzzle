puts "** Loading word dictionary into cache..."

allowableChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split(//)
allowableWords = []

# Smaller file used for test/dev etc.
dictLocation = 'vendor/assets/'
wordFile = Rails.env.production? ? dictLocation + 'words.txt' : dictLocation + 'words_dev.txt'
# ... or for dev/test purposes, 'export PUZZLE_DICT=words.txt'
wordFile = ENV['PUZZLE_DICT'] ? dictLocation + ENV['PUZZLE_DICT'] : wordFile

File.open( wordFile ).each do |line|
  next if line.nil?

  # puts line

  # Only take words of length >=6, and eliminate words with punctuation
  candidateLine = line.strip.upcase
  checkChars = candidateLine
  allowableChars.each do |allowableChar|
    checkChars = checkChars.gsub(allowableChar,'')
  end

  next if checkChars.size>0 #There are punctuation or undesired chars
  next if candidateLine.size<6 #If this line is reached, it's only allowableChars

  allowableWords.push(candidateLine)
end

puts "**  words: #{allowableWords.size}"
Rails.cache.write("dictionary_words", allowableWords)
