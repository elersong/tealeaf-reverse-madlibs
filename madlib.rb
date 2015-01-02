# ========================================================= Pseudocode Algorithm
# 1. Explain to user how a "reverse madlib" works
# 2. Prompt user for a sentence with some words left out
# 3. Save that sentence to the "catalog" list of sentences (if it's not already on the list)
# 4. Process the sentence and replace any instance of NOUN with a random word from the nouns.txt file
# 5. Print that sentence to the console
# 6. Ask the user if he wants to reload the same sentence again, choose from the catalog, add a new one or exit



# =========================================================== Method Definitions

def add_sentence_to_catalogue_if_unique(template) # <= String
  all_sentences = File.readlines("sentences.txt")
  unless all_sentences.include? "#{template}\n"
    File.open("sentences.txt", "a+") do |file|
      file << "#{template}\n"
    end
  end
end # => nil

def collect_and_validate_input(msg, type) # <= String, Symbol
  input = msg.nil? ? gets.chomp : prompt(msg)
  
  if valid?(input, type) && type == :sentence
    add_sentence_to_catalogue_if_unique input
    return input
  elsif valid?(input, type) && type == :select
    return input
  elsif type == :select
    print_header
    print_menu
    puts ""
    puts "INVALID INPUT: Please try again"
    input = collect_and_validate_input msg, type
  else
    print_header
    puts "INVALID INPUT: Please try again"
    input = collect_and_validate_input msg, type
  end
end # => String

def fetch_madlib_word(sym, letter = "") # <= Symbol, String
  case sym
  
    when :noun
      if letter != ""
        loop do
          word = (File.readlines("./FILTERED_parts_of_speech_lists/nouns.txt").sample.strip).split("")
          return word.join if word[0].downcase == letter.downcase
        end
      else
        return File.readlines("./FILTERED_parts_of_speech_lists/nouns.txt").sample.strip
      end
      
    when :adverb 
      if letter != ""
        loop do
          word = (File.readlines("./FILTERED_parts_of_speech_lists/adverbs.txt").sample.strip).split("")
          return word.join if word[0].downcase == letter.downcase
        end
      else
        return File.readlines("./FILTERED_parts_of_speech_lists/adverbs.txt").sample.strip
      end
      
    when :verb
      if letter != ""
        loop do
          word = (File.readlines("./FILTERED_parts_of_speech_lists/verbs.txt").sample.strip).split("")
          return word.join if word[0].downcase == letter.downcase
        end
      else
        return File.readlines("./FILTERED_parts_of_speech_lists/verbs.txt").sample.strip
      end
      
    when :adjective 
      if letter != ""
        loop do
          word = (File.readlines("./FILTERED_parts_of_speech_lists/adjectives.txt").sample.strip).split("")
          return word.join if word[0].downcase == letter.downcase
        end
      else
        return File.readlines("./FILTERED_parts_of_speech_lists/adjectives.txt").sample.strip
      end
  end
end # => String

def get_random_sentence # <= nil
  all_sentences = File.readlines("sentences.txt")
  all_sentences.sample.strip
end # => String

def make_madlib(template, alliteration = false) # <= String, Boolean
  words_in_sentence = template.split(" ")
  
  # Alliteration mode
  if alliteration
    letter = %w(a b c d e f g h i j k l m n o p q r s t u v w x y z).sample
  else
    letter = ""
  end
  
  words_in_sentence.each_with_index do |word, index|
    
    is_a_noun = true if word.include? "NOUN" # this chunk checks whether or not to change "a" to "an"
    vowels = %w(a e i o u)
    word.gsub!("NOUN", fetch_madlib_word(:noun, letter))
    first_letter_of_word = words_in_sentence[index].split("")[0].downcase
    if is_a_noun && (words_in_sentence[index - 1] == "a") && (vowels.include? first_letter_of_word)
      words_in_sentence[index-1] = "an"
    end

    word.gsub!("ADVERB", fetch_madlib_word(:adverb, letter))
    word.gsub!("ADJECTIVE", fetch_madlib_word(:adjective, letter))
    word.gsub!("VERB", fetch_madlib_word(:verb, letter))
  end
  words_in_sentence.join(" ")
end # => String

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
    say "'#{make_madlib example_sentence}'"
    puts ""
    
    loop do
      if (prompt "Press [enter] to start in normal mode. Press [A] and then [enter] for alliteration mode (much slower).").downcase == "a"
        print_header
        return true
      else
        print_header
        return false
      end
    end
  end
  puts ""
end # => Boolean

def say(msg) # <= String
  puts " => #{msg}"
end # => nil

def print_menu # <= nil
  puts ""
  say "Please select an option by number:"
  say "  1) Run that sentence again!"
  say "  2) Choose a sentence from your catalog."
  say "  3) Enter a new sentence."
  say "  4) Exit."
  puts ""
end # => nil

def prompt(msg) # <= String
  say msg
  gets.chomp
end # => String

def say(msg) # <= String
  puts " => #{msg}"
end # => nil

def valid?(input, type) # <= String, Symbol
  if type == :select
    return (input =~ /^[0123456789]+$/)
  elsif type == :sentence
    return true if input.include? "NOUN"
    return true if input.include? "VERB"
    return true if input.include? "ADJECTIVE"
    return true if input.include? "ADVERB"
  elsif type == :again
    return (input =~ /[YNyn]/)
  end
  false
end # => Boolean



# ================================================================ Program Logic

alliteration_mode = print_header true
print_header

most_recent_sentence = collect_and_validate_input "Please enter a template sentence:", :sentence
puts ""
say make_madlib most_recent_sentence, alliteration_mode

selection = collect_and_validate_input print_menu, :select

loop do
  case selection
  
    when "1" # run same template again
      print_header
      say make_madlib most_recent_sentence, alliteration_mode
      selection = collect_and_validate_input print_menu, :select
      
    when "2" # select template from catalogue
      print_header
      templates = File.readlines("sentences.txt")
      say "Select a template by number:"
      
      if templates.count > 10
        catalog = templates.sample(10)
        catalog.each_with_index do |template, index|
          say "#{index+1}) #{template}"
        end
        template_choice = (collect_and_validate_input "", :select).to_i
        print_header
        most_recent_sentence = catalog[template_choice - 1]
        say make_madlib most_recent_sentence, alliteration_mode
      else
        templates.each_with_index do |template, index|
          say "#{index+1}) #{template}"
        end
        template_choice = (collect_and_validate_input "", :select).to_i
        print_header
        most_recent_sentence = templates[template_choice - 1]
        say make_madlib most_recent_sentence, alliteration_mode
      end
      
      selection = collect_and_validate_input print_menu, :select
      
    when "3" # enter new sentence
      print_header
      most_recent_sentence = collect_and_validate_input "Please enter a template sentence:", :sentence
      puts ""
      say make_madlib most_recent_sentence, alliteration_mode
      selection = collect_and_validate_input print_menu, :select
    
    when "4" 
      print_header
      say "Thanks for playing!"
      break # end the loop/program
  end
end 