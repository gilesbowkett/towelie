class Post < ActiveRecord::Base
  def recent
    find(:all)
  end
end
