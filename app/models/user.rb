class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, (options[:message] || "is not an email") unless
      value =~ /\A([^@\s]+)@((?:[-a-z0-9_]+\.)+[a-z]{2,})\z/i
  end
end

class User < ActiveRecord::Base
	validates :name, :presence => true, :uniqueness => { :case_sensitive => false}
	validates :email, :presence => true, :uniqueness => { :case_sensitive => false}, :email => true
	has_secure_password
	validates_presence_of :password, :on => :create
end
