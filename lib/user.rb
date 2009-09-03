class User
  attr_reader :user_id, :repos, :norm
  
  def initialize(user_id=0, repos=[])
    @user_id = user_id
    @repos = repos
    norm = 0.0
    self.repos.values.each do |val|
      norm = norm + val * val
    end
    @norm = Math.sqrt(norm)
  end

  def cosine_sim(user)
    return 0.0 if @norm == 0.0 || user.norm == 0.0

    dot_product = 0.0
    keys = self.repos.keys + user.repos.keys
    keys.uniq!
    keys.each do |key|
      unless self.repos[key].nil?
        unless user.repos[key].nil?
          dot_product = dot_product + (self.repos[key] * user.repos[key])
        end
      end
    end

    return dot_product / (@norm * user.norm)
  end
end
