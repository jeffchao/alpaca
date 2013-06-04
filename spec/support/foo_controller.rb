class FooController < ActionController::Base
  before_filter :enable_whitelist_and_deny_by_default

  def foo
  end
end
