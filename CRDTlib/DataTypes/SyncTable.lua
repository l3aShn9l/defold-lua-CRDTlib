SyncTable = {}

function SyncTable:new(input_table)
  local table = {}
  local Storage = {123}
  for k,v in pairs(input_table) do
    table[k] = v
  end
  setmetatable(table,self)
  self.__index = self; return table
end

function SyncTable:getStorage()
  return self.Storage
end

function SyncTable:set(key,value)
  self[key] = value
end

function SyncTable:remove(key)
  if type(key) == "string" then
    self[key] = nil
  elseif type(key) == "number" then
    table.remove(self,key)
  end
end

function SyncTable:insert(key,value)
  table.insert(self,key,value)
end
---------------------------------------------
a = {"a", "b","c","d"}
local t = SyncTable:new(a)
--for k,v in pairs(t) do
  --print(k,v)
--end
for k,v in pairs(t) do
  print(k,v)
end
--t:remove(2)
--t:set(2,nil)
--t[#t+1] = 6
t:insert(6,"joker")
t:insert(1,"thief")
--t:remove(5)
--t:insert(5,"hello")
t:remove(3)
--t:insert(1,"bastard")
for k,v in pairs(t) do
  print(k,v)
end
print(#t)
--print(t[1])