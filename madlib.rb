# Pseudocode Algorithm
# ====================
# 1. Explain to user how a "reverse madlib" works
# 2. Prompt user for a sentence with some words left out
# 3. Save that sentence to the "catalog" list of sentences (if it's not already on the list)
# 4. Process the sentence and replace any instance of NOUN with a random word from the nouns.txt file
# 5. Print that sentence to the console
# 6. Ask the user if he wants to reload the same sentence again, choose from the catalog, add a new one or exit


# ===================== Method Definitions

def print_header(instructions = false) # <= Boolean
  system("clear")
  puts "Reverse Mad Libs"
  puts "----------------"
  
  if instructions
    puts ""
    say "How It Works:"
    say "In a typical madlib, we provide the sentence, and you provide the filler words."
    say "Since this is REVERSE, you now provide the sentence for which we provide the words."
    say "You can add NOUNs, ADJECTIVEs, ADVERBs and VERBs."
    puts ""
    say "For example, this:"
    example_sentence = get_random_sentence
    say "'#{example_sentence}'"
    puts ""
    say "Becomes this:"
    say "'#{madlib example_sentence}'"
    puts ""
    
    loop do
      if (prompt "Press [enter] to start") == ""
        print_header
        break
      end
    end
  end
  
end # => nil

def say(msg) # <= String
  puts " => #{msg}"
end # => nil

def prompt(msg) # <= String
  say msg
  gets.chomp
end # => String

def get_random_sentence # <= nil
  all_sentences = File.readlines("sentences.txt", "r")
  all_sentences.sample
end # => String

def madlib(template) # <= String
  words_in_sentence = template.split(" ")
  words_in_sentence.each do |word|
    word.gsub!("NOUN", fetch_madlib_word(:noun))
    word.gsub!("ADVERB", fetch_madlib_word(:adverb))
    word.gsub!("ADJECTIVE", fetch_madlib_word(:adjective))
    word.gsub!("VERB", fetch_madlib_word(:verb))
  end
  words_in_sentence.join(" ")
end # => String

def fetch_madlib_word(sym) # <= Symbol
  case sym
    when :noun
      return File.readlines("./FILTERED_parts_of_speech_lists/nouns.txt").sample.strip
    when :adverb 
      return File.readlines("./FILTERED_parts_of_speech_lists/adverbs.txt").sample.strip
    when :verb
      return File.readlines("./FILTERED_parts_of_speech_lists/verbs.txt").sample.strip
    when :adjective 
      return File.readlines("./FILTERED_parts_of_speech_lists/adjectives.txt").sample.strip
  end
end # => String


# ===================== Program Logic
print_header true