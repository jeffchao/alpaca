class BarController < ActionController::Base
  before_filter :enable_blacklist_and_allow_by_default

  def bar
  end
end
