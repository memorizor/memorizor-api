class User < ActiveREcord::Base
	validates :name, presence: true, uniqueness: { :case_sensitive => false}
	validates :email, presence: true, uniqueness: { :case_sensitive => false}
	has_secure_password
	validates_presence_of :password, :on => :create
end