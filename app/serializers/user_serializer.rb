class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :admin
end
