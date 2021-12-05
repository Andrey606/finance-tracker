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

  def self.find_by_name_email(name_or_email)
    user = where(first_name: name_or_email).first
    user = where(email: name_or_email).first unless user
    return user
  end
end
