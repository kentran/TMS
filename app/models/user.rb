class User < ActiveRecord::Base
  has_and_belongs_to_many :projects
  has_many :project_files
  has_many :notifications
  has_many :reminders, :order => "reminders.date"

  belongs_to :university
  belongs_to :department

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :title, :role,
                  :notif_on, :reminder_on, :upload_confirm_on
  # attr_accessible :title, :body

  validates :email, presence: true, uniqueness: true
  validates :role, presence: true

end
