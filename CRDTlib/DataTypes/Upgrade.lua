User = {}
function User:new(username)
  local self = {}
  self.username = username
  self.counter = 1
  return self
end

SyncTable = {}
function SyncTable:new(user)
  local self = {}
  self.table = {}
  self.short_table = {}
  self.operations = {}
  self.user = user
  self.level = 1
  self.max_operation_level = 1
  return self
end
function SyncTable:getTable(sync_table)
  output_table = {}
  for k,v in pairs(sync_table.table) do
    if sync_table.operations[v].is_not_removed == true then
      lso = sync_table.operations[v].last_set_operation
      table.insert(output_table,sync_table.operations[v].set_operations[lso])
    end
  end
  return output_table
end
function SyncTable:remove(sync_table,key)
  if sync_table.short_table[key] ~= nil then
    if sync_table.operations[sync_table.short_table[key]] == nil then
      print("Error: SyncTable:remove")
    else
      sync_table.operations[sync_table.short_table[key]].is_not_removed = false
    end
  end
    table.remove(sync_table.short_table,key)
end

function SyncTable:insert(sync_table,key,value)
  --local tuple = {}
  --tuple.value = value
  local operation = sync_table.user.username..":"..tostring(sync_table.user.counter)
  --tuple.operation = operation
  table.insert(sync_table.short_table,key,operation)
  local left_neighbour = nil
  if(key>1) then
    left_neighbour = sync_table.short_table[key-1]
  --else
    --left_neighbour = nil
  end
  local data = {}
  data.set_operations = {}
  data.last_set_operation = operation
  data.is_not_removed = true
  data.level = sync_table.level
  data.set_operations[operation] = value
  data.username = sync_table.user.username
  data.counter = sync_table.user.counter
  sync_table.operations[operation] = data
  if left_neighbour == nil then
    table.insert(sync_table.table,1,operation)
  else
    for k,v in pairs(sync_table.table) do
      if v == left_neighbour then
        table.insert(sync_table.table,k+1,operation)
        break
      end
    end
  end
  sync_table.max_operation_level = sync_table.level
  sync_table.user.counter = sync_table.user.counter + 1
end

function SyncTable:set(sync_table,key,value)
  if sync_table.short_table[key] ~= nil then
    local operation = sync_table.user.username..":"..tostring(sync_table.user.counter)
    sync_table.operations[sync_table.short_table[key]].set_operations[operation] = value
    sync_table.operations[sync_table.short_table[key]].last_set_operation = operation
    --sync_table.operations[sync_table.table[key].operation].is_not_removed = true
    sync_table.user.counter = sync_table.user.counter + 1
  else
    SyncTable:insert(sync_table,key,value)
  end
end

function SyncTable:merge(first_table,second_table)
  local new_table = {}
  local buf_table = {}
  local new_operations = {}

  ff,ft,fk = pairs(first_table.table)
  fk,fv = ff(ft, fk)
  sf,st,sk = pairs(second_table.table)
  sk,sv = sf(st, sk)

  while fk ~= nil and sk ~= nil do
    while fk ~= nil do
      if (second_table.operations[fv] == nil) then
        table.insert(new_table, fv)
        fk,fv = ff(ft, fk)

      else
        fk,fv = ff(ft, fk)
        break
      end
    end
    while sk ~= nil do
      if first_table.operations[sv] == nil then
        table.insert(new_table, sv)
      else  
        
      sk,sv = sf(st, sk)
    end
  end
  for k,v in pairs(major_table.operations) do
    if minor_table.operations[k]~= nil then
      new_operations[k] = v and minor_table.operations[k]
    else
      new_operations[k] = v
    end
  end
  for k,v in pairs(minor_table.operations) do
    if major_table.operations[k] == nil then
      new_operations[k] = v
    end
  end
  
  first_table.level = math.max(first_table.max_operation_level, second_table.max_operation_level)+1
  first_table.table = new_table
  first_table.operations = new_operations
end
end
---------------------------------------------
f_user = User:new("Vasya")
s_user = User:new("Petya")

f_table = SyncTable:new(f_user)
s_table = SyncTable:new(s_user)
SyncTable:insert(f_table, 1,"!")
SyncTable:insert(f_table, 1,"8")
SyncTable:insert(s_table, 1,"?")
SyncTable:insert(s_table, 2,"9")

--f,t,k = pairs(f_table.table) 
--k,v = f(t, k)
--while k ~= nil do
  --print('k: '..tostring(k)..', v: '..tostring(v.value))
  --k,v = f(t, k)
--end
--SyncTable:merge(f_table,s_table)
--for k,v in pairs(f_table.operations) do
    --print(k,v)
--end
for k,v in pairs(SyncTable:getTable(f_table)) do
    print(k,v)
end
print("----------------------")
SyncTable:insert(f_table, 3, "akaka")
SyncTable:insert(s_table, 2,"7")
--SyncTable:remove(f_table, 2)
--SyncTable:set(f_table, 1,"kkkk")
for k,v in pairs(SyncTable:getTable(f_table)) do
    print(k,v)
end
--SyncTable:remove(f_table, 2)
--[=[
SyncTable:merge(f_table,s_table)
for k,v in pairs(f_table.table) do
    print(k,v.value, v.operation)
end
for k,v in pairs(f_table.operations) do
    print(k,v)
end
--]=]
--[=[
SyncTable:merge(s_table,f_table)
for k,v in pairs(s_table.table) do
    print(k,v.value, v.operation)
end
for k,v in pairs(s_table.operations) do
    print(k,v)
end
--]=]