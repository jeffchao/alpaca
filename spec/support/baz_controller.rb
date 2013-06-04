class BazController < ActionController::Base
  before_filter :enable_whitelist_and_deny_by_default, ['0.0.0.4']

  def baz
    render({ status: :ok, text: "baz", content_type: 'text/plain' })
  end
end
