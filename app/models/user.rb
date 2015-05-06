class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :stocks

  validates :username,
    :presence => true,
    :uniqueness => {
      :case_sensitive => false
    },
    length: {maximum: 255},
    format: { with: /\A[a-zA-Z0-9]*\z/, message: "may only contain letters and numbers." }

 def admin?
   role == 'admin'
 end
 
 def moderator?
   role == 'moderator'
 end

  attr_accessor :login

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end
end

