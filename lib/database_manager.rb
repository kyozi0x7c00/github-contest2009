require 'pp'
require 'win32ole'
require 'user'
require 'repository'

class DatabaseManager
  def initialize
    @conn = WIN32OLE.new('ADODB.CONNECTION')
    @conn.Open('Provider=Microsoft.ACE.OLEDB.12.0;Data Source=C:/Documents and Settings/takahashi/My Documents/NetBeansProjects/github-contest/download/data.accdb;Persist Security Info=False;')
  end

  def finalize
    @conn.Close
  end

  def do_sql(sql='')
    rs = @conn.Execute(sql)
    if rs.EOF || rs.BOF
      return
    end
    rs.MoveFirst
    until rs.EOF || rs.BOF
      yield rs
      rs.MoveNext
    end
    rs.Close
  end

  def get_user(user_id=0)
    sql = "select * from data where user_id=#{user_id}"
    repos = Hash.new
    do_sql(sql) do |rs|
      repos[rs.Fields.Item("repo_id").Value] = 1.0
    end
    
    return User.new(user_id, repos)
  end

  def get_users(user)
    users = []
    return users unless user.repos.size > 0

    user_ids = Array.new
    sql = "select distinct user_id from data where user_id<>#{user.user_id} and repo_id in (#{user.repos.keys.join(',')}) order by user_id"
    do_sql(sql) do |rs|
      user_ids << rs.Fields.Item("user_id").Value
    end
    return users unless user_ids.size > 0

    if user.repos.size > 0
      sql = "select * from data where user_id in (#{user_ids.join(',')}) order by user_id, repo_id"
    else
      return users
    end
    
    is_first = true
    user_id = -1
    pre_user_id = -1
    repos = Hash.new
    do_sql(sql) do |rs|
      if is_first
        pre_user_id = rs.Fields.Item("user_id").Value
        is_first = false
      end
      user_id = rs.Fields.Item("user_id").Value

      if pre_user_id != user_id
        users << User.new(pre_user_id, repos)
        pre_user_id = rs.Fields.Item("user_id").Value
        repos = Hash.new
        repos[rs.Fields.Item("repo_id").Value] = 1.0
      else
        repos[rs.Fields.Item("repo_id").Value] = 1.0
      end
    end
    users << User.new(user_id, repos)
    
    return users
  end

  def get_all_user
    sql = "select * from data order by user_id, repo_id"
    users = Array.new
    is_first = true
    user_id = -1
    pre_user_id = -1
    repos = Hash.new
    do_sql(sql) do |rs|
      if is_first
        pre_user_id = rs.Fields.Item("user_id").Value
        is_first = false
      end
      user_id = rs.Fields.Item("user_id").Value

      if pre_user_id != user_id
        users << User.new(pre_user_id, repos)
        pre_user_id = rs.Fields.Item("user_id").Value
        repos = Hash.new
        repos[rs.Fields.Item("repo_id").Value] = 1.0
      else
        repos[rs.Fields.Item("repo_id").Value] = 1.0
      end
    end
    users << User.new(user_id, repos)

    return users
  end

  def get_repository

  end
  
  def get_repositories

  end

  def get_all_repository
    sql = "select repos.repo_id, name, date, fork_id, languages from repos left outer join lang on repos.repo_id = lang.repo_id order by repos.repo_id;"
    repos = Array.new
    do_sql(sql) do |rs|
      repo_id = rs.Fields.Item("repo_id").Value
      name = rs.Fields.Item("name").Value
      date = rs.Fields.Item("date").Value
      fork_id = rs.Fields.Item("fork_id").Value
      language = rs.Fields.Item("languages").Value

      unless language.nil?
        languages = Hash[*language.split(',').map { |e| e.split(';') }.flatten]
      end

      repos << Repository.new(repo_id, name, date, fork_id, languages)
    end

    return repos
  end
end

