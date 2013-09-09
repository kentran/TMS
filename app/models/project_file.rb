class ProjectFile < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  attr_accessible :file_name, :file_path, :user_id, :project_id, :original_file_name

end
