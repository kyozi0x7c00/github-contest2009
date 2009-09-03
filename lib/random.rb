class Random
  def random
    File::open("../download/results.txt") do |f|
      f.each do |line|
        line.chomp!
        id_result = line.split(":")
        if (id_result.size == 2)
          result = id_result[1].split(",").map { |e| e.to_i }
          if (result.size == 10)
            puts line
          else
            until result.size == 10
              result << rand(500+1)
              result.uniq!
            end
            puts "#{id_result[0]}:#{result.sort.join(",")}"
          end
        else
          result = []
          until result.size == 10
            result << rand(500+1)
            result.uniq!
          end
          puts "#{id_result[0]}:#{result.sort.join(",")}"
        end
      end
    end
  end
end
