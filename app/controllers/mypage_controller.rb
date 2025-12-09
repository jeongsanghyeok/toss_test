class MypageController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def orders
  end

  def cancellations
  end

  def benefits
  end

  def coupons
  end

  def reviews
  end

  def inquiries
  end
end
