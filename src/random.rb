=begin
File::open("../download/test.txt") do |f|
  f.each do |line|
    result = []
    10.times do
      result << rand(120866+1)
    end
    line.chomp!
    puts "#{line}:#{result.join(",")}"
  end
end
=end
require 'pp'

USER_NUM = 56554
REPO_NUM = 123344

result = Array.new(USER_NUM)
result.each_with_index do |raw, index|
  result[index] = Array.new(REPO_NUM, 0)
end

File::open("../download/data.txt") do |f|
  f.each do |line|
    line.chomp!
    ary = line.split(":")
    result[ary[0].to_i-1][ary[1].to_i-1] = 1
  end
end

result.each do |raw|
  puts raw.join(",")
end