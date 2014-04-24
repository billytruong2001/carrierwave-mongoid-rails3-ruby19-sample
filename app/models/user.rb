class User < ActiveRecord::Base
  attr_accessible :email, :name, :avatar

  mount_uploader :avatar, AvatarUploader
end
