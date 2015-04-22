class User < ActiveRecord::Base
  has_secure_password
  has_many :api_keys, :dependent => :delete_all

  validates :username, presence: true,
                    uniqueness: { case_sensitive: false }

  validates :email, presence: true,
                    format: /.+@.+\..+/i,
                    uniqueness: { case_sensitive: false }


  def session_api_key
    api_keys.active.first_or_create
  end

  def access_token_matches?(access_token)
    session_api_key.access_token == access_token
  end

  def generate_new_access_token
    self.delete_tokens
    ApiKey.create(user: self)
  end

  def delete_tokens
    ApiKey.delete_all(["user_id = ?", self])
  end
end
