class User < ActiveRecord::Base
  has_secure_password
  before_create :generate_password_reset_code
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

  def generate_password_reset_code
    begin
      self.password_reset_code = SecureRandom.hex
    end while self.class.exists?(password_reset_code: password_reset_code)
  end

  def reset_password(reset_code)
    if password_reset_code == reset_code
      self.password = (0...10).map { (65 + rand(26)).chr }.join
    end
  end

end
