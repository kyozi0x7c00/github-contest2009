#120,867

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