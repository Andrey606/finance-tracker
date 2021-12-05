class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def stock_already_tracked?(ticker_symbol)
    stock = Stock.check_db ticker_symbol
    return false unless stock
    stocks.where(id: stock.id).exists?
  end

  def friend_already_tracked?(friend_name)
    friend = User.where(first_name: friend_name).first
    return false unless friend
    friends.where(id: friend.id).exists?
  end

  def under_stock_limit?
    stocks.count < 10
  end

  def can_track_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_tracked?(ticker_symbol)
  end

  def can_follow_friend?(friend_name)
    !(first_name == friend_name) && !friend_already_tracked?(friend_name)
  end

  def full_name
    return "#{first_name} #{last_name}" if first_name || last_name
    "Anonymous"
  end

  def self.search(param)
    # Returns a copy of str with leading and trailing whitespace removed
    param.strip!
    # uniq - Returns a new array by removing duplicate values in self.
    to_send_back = (first_name_mathes(param) + last_name_mathes(param) + email_mathes(param)).uniq
    return nil unless to_send_back
    to_send_back
  end

  def self.first_name_mathes(param)
    mathes('first_name', param)
  end

  def self.last_name_mathes(param)
    mathes('last_name', param)
  end

  def self.email_mathes(param)
    mathes('email', param)
  end

  # look for some field with param
  def self.mathes(field_name, param)
    where("#{field_name} like ?", "%#{param}%")
  end

  def except_current_user(users)
    users.reject { |user| user.id == self.id }
  end
end
