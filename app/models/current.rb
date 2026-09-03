class Current < ActiveSupport::CurrentAttributes
  attribute :user, :account

  def user=(user)
    super
    self.account ||= user.account if user
  end
end