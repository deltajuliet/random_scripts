#Test code to find valid URL's through forceful browsing and random guessing of a given URL with a 16 digit random url.

# Created by Dan Jones

require 'curb'

@base_url = ARGV[0]
@invalid_text = ARGV[1]

if @invalid_text == nil
  puts "Please use the following when invoking this script: brute_valid_urls.rb [base_url_path] [text_contained_in_invalid_response]"
  exit 1
end

#Script initiation text.
puts "This script will now test: #{@base_url} for a response that doesn't contain \"#{@invalid_text}.\""
puts ""
puts "Press Control-C to exit the script. The valid url's will be displayed."
puts ""
puts "Testing URLs now!"
puts ""

#Determines if a URL links to a valid page
def valid_url?(url)
  resp =  Curl.get  url

  if resp.body_str.include? @invalid_text
    return false
  else
    return true
  end
end

#Build a possible URL based on the suffix given
def build_url(url_suffix)
  return @base_url+url_suffix
end

#Builds an array of possible characters to create paths from
@possible_chars = []
@possible_chars.concat Array('a' .. 'z')
@possible_chars.concat Array('A' .. 'Z')
@possible_chars.concat Array('0' .. '9')

#Build possible suffixs for valid pages
def build_suffix(id_length = 16)
  possible_suffix = ""

  (1 .. id_length).each do |id|
    possible_suffix = possible_suffix.concat @possible_chars.sample
  end
  return possible_suffix
end

tested_suffixes = []
valid_urls_discovered = []

trap("INT") { puts "\nStopping now. The following URLs appear valid:"; p valid_urls_discovered; exit}

while true do
  suffix_to_test = build_suffix

  unless tested_suffixes.include? suffix_to_test
    url = build_url suffix_to_test
    url_valid = valid_url? url
    valid_urls_discovered.push url if url_valid
    puts "#{url}\t#{url_valid}"
    tested_suffixes.push suffix_to_test
  end
end
