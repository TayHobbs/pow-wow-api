class ApiKey < ActiveRecord::Base
  before_create :generate_access_token, :generate_refresh_token, :set_expiry_date
  belongs_to :user

  scope :active,  -> { where('expired_at >= ?', Time.now) }

  private

  def set_expiry_date
    self.expired_at = 4.hours.from_now
  end

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end

  def generate_refresh_token
    begin
      self.refresh_token = SecureRandom.hex
    end while self.class.exists?(refresh_token: refresh_token)
  end

end
