class User < ActiveRecord::Base
  has_one :roles
  has_and_belongs_to_many :projects
  has_many :project_files

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :title, :university, :department, :role
  # attr_accessible :title, :body

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :role, presence: true

end
