file = File.open("I2610_20210311_034752.txt")

file_filter = []
File.foreach(file) do |line|
  words = line.split("|")
  fil
  #words.each do |e|
  #  p
  #end
end

File.