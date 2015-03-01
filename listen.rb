require 'listen'

listener = Listen.to('/home/sandric/listen-test', debug: false) do |modified, added, removed|
  puts "modified absolute path: #{modified}" if modified.any?
  puts "added absolute path: #{added}" if added.any? 
  puts "removed absolute path: #{removed}" if removed.any? 
end
listener.start # not blocking
sleep
