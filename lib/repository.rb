class Repository
  attr_reader :repo_id, :name, :author_name, :project_name, :date, :fork_id, :language

  def initialize(repo_id, name, date, fork_id, language)
    @repo_id = repo_id
    @name = name
    @author_name = name.split('/')[0]
    @project_name = name.split('/')[1]
    @date = date
    @fork_id = fork_id
    @language = language
  end
end
