class User < ActiveRecord::Base
  has_secure_password
  validates :username, presence: true,
                  uniqueness: { case_sensitive: false }
  validates :email, presence: true,
                  format: /.+@.+\..+/i,
                  uniqueness: { case_sensitive: false }
  validates :password, presence: true



end
