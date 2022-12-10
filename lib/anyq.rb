require 'json'
require 'securerandom'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: anyq [options]'
  opts.program_name = 'anyq'
  opts.version = '0.0.1'

  opts.on('-q', '--quote', 'Print only the quote') do |q|
    options[:quote] = q
  end

  opts.on('-a', '--author', 'Print the author of the quote') do |a|
    options[:author] = a
  end

  opts.on('-s', '--source', 'Print the source of the quote') do |s|
    options[:source] = s
  end

  opts.on('-Q', '--new-quote QUOTE', 'Add a quote to the JSON file') do |q|
    options[:new_quote] = q
  end

  opts.on('-A', '--new-author AUTHOR', 'Specify the author of the quote') do |a|
    options[:new_author] = a
  end

  opts.on('-S', '--new-source SOURCE', 'Specify the source of the quote') do |s|
    options[:new_source] = s
  end
end.parse!

quotes_file = File.read('./quotes.json')
quotes = JSON.parse(quotes_file)

if options[:new_quote]
  new_quote = {
    'quote': options[:new_quote],
    'author': options[:new_author] || 'Unknown',
    'source': options[:new_source] || 'Unknown'
  }
  quotes << new_quote

  File.write('./quotes.json', JSON.generate(quotes))

  puts 'New quote added'
else
  random_quote = quotes[SecureRandom.random_number(quotes.length)]

  if options[:quote]
    puts random_quote['quote']
    
    if options[:author] && options[:source]
      puts "-- #{random_quote['author']} (#{random_quote['source']})"
    else
      puts "-- #{random_quote['author']}" if options[:author]
      puts "Source: #{random_quote['source']}" if options[:source]
    end
  else
    puts random_quote['quote']
    puts "-- #{random_quote['author']} (#{random_quote['source']})"
  end
end