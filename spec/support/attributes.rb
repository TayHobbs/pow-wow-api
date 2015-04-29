def user_attributes(overrides = {})
  {
    id: 1,
    username: 'William Wallace',
    email: 'william.wallace@scotland.com',
    password: 'Testing1'
  }.merge(overrides)
end
