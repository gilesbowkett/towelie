class User < ActiveRecord::Base
  def login(credentials)
    find(:first, :conditions => ["name = ? and password = ?", credentials[:name], credentials[:password]])
  end

  def dropdown
    find(:all).collect { |u| [u.name, u.name] }
  end
end
