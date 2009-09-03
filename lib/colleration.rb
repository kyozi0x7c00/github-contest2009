require 'database_manager'
require 'pstore'

class Colleration
  def sim_calc(user, users)
    sim_user = Array.new
    users.each do |u|
      sim = user.cosine_sim(u)
      if (sim > 0.25)
        sim_user << u
      end
    end

    sim_rank = Hash.new
    sim_rank.default = 0.0
    sim_user.each do |u|
      sim_rank.update(u.repos) do |key, val1, val2|
        val1 + val2
      end
    end

    sim_rank = sim_rank.sort do |a, b|
      b[1] <=> a[1]
    end

    result = Array.new
    sim_rank.each do |repo|
      unless user.repos.key?(repo[0]) # repo_id
        result << repo[0]
      end
      if result.size == 10
        break
      end
    end

    puts "#{user.user_id}:#{result.sort.join(',')}"
  end

  def do_collaborative_filtering
    db = DatabaseManager.new
    all_user = db.get_all_user
    File::open("../download/test.txt") do |f|
      f.each do |line|
        user_id = line.chomp!.to_i
        user = all_user.select do |u|
          u.user_id == user_id
        end[0]
        users = all_user.select do |u|
          u.user_id != user_id && u.repos.size > 0
        end.to_a
        unless user.nil?
          sim_calc(user, users)
        else
          puts "#{user_id}:"
        end
      end
    end
  end
end
