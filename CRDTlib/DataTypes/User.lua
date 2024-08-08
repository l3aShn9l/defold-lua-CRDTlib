User = {}
function User:new(username)
  local self = {}
  self.username = username
  self.counter = 1
  return self
end