class User < ActiveRecord::Base
  # new columns need to be added here to be writable through mass assignment
  attr_accessible :name, :company, :email, :password, :password_confirmation, :client_id, :hourly_rate, :works_at_eve, :deactivated

  attr_accessor :password
  # dont save password as plain text to the db. nstead add salt and hash it
  before_save :prepare_password

  #validations
  validates_presence_of :name, :email
  validates_uniqueness_of :name, :email, :allow_blank => true
  validates_format_of :name, :with => /^[-\w\._@]+$/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@"
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 4, :allow_blank => true

  # active record associations
  has_many :assignments
  has_many :projects, :through => :assignments
  has_many :comments
  has_many :images
  has_many :hours
  has_many :chat_messages
  has_many :answers
  
  has_many :user_plan_hours
  has_one :person
  belongs_to :client
  

  

  # login can be either username or email address
  def self.authenticate(login, pass)
    user = find_by_name(login) || find_by_email(login)
    return user if user && user.matching_password?(pass)
  end

  def matching_password?(pass)
    self.password_hash == encrypt_password(pass)
  end

  # sum of all user hours in the given month
  def monthly_hours(month)
    month_hours = self.hours.by_month Date.new(2011, month)
    month_hours.to_a.sum { |month_hour| month_hour.amount }
  end
  
  # sum of all holiday days in the given month
  def monthly_holidays(month)
    month_hours = self.hours.holiday.by_month Date.new(2011, month)
    sum = month_hours.to_a.sum { |month_hour| month_hour.amount }
    (sum / 8).to_i
  end
  
  # sum of all ill days in the given month
  def monthly_illdays(month)
    month_hours = self.hours.ill.by_month Date.new(2011, month)
    sum = month_hours.to_a.sum { |month_hour| month_hour.amount }
    (sum / 8).to_i
  end
  
  def workdays(month)
    d1 = Date.new( Time.now.year, month, 1) #first day of month\period
    d2 = Date.new( Time.now.year, month, -1) #end day of month\period
    wdays = [0,6] #weekend days by numbers on week
    weekdays = (d1..d2).reject { |d| wdays.include? d.wday} #Day.wday number day in week
  end

  def extra_hours(month, year)
    d1 = Date.new( year, month, 1) #first day of month\period
    d2 = Date.new( year, month, -1) #end day of month\period
    wdays = [0,6] #weekend days by numbers on week
    weekdays = (d1..d2).reject { |d| wdays.include? d.wday} #Day.wday number day in week
    todo_hours = weekdays.count * 8
    ist_hours = self.monthly_hours( month )
    if ist_hours > 0
      ist_hours - todo_hours
    else
      0
    end
  end

  private

  def prepare_password
    unless password.blank?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = encrypt_password(password)
    end
  end

  def encrypt_password(pass)
    BCrypt::Engine.hash_secret(pass, password_salt)
  end
end
