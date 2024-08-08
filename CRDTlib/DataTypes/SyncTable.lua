SyncTable = {}
function SyncTable:new(username)
  local self = {}
  self.table = {}
  self.operations = {}
  self.user = username
  self.counter = 1
  return self
end
function SyncTable:remove(sync_table,key)
  if sync_table.table[key] ~= nil then
    if sync_table.operations[sync_table.table[key].operation] == nil then
      print("Error: SyncTable:remove")
    else
      sync_table.operations[sync_table.table[key].operation] = false
    end
  end
    table.remove(sync_table.table,key)
    
end

function SyncTable:insert(sync_table,key,value)
  local tuple = {}
  tuple.value = value
  tuple.operation = sync_table.user..":"..tostring(sync_table.counter)
  sync_table.operations[tuple.operation] = true
  sync_table.counter = sync_table.counter + 1
  table.insert(sync_table.table,key,tuple)
end

function SyncTable:set(sync_table,key,value)
  local tuple = {}
  tuple.data = {}
  tuple.data.set_operations = {}
  tuple.last_set_operation = {}
  tuple.last_set_operation
  tuple.is_not_removed = {}
  tuple.operation = sync_table.user..":"..tostring(sync_table.counter)
  sync_table.operations[tuple.operation] = true
  sync_table.counter = sync_table.counter + 1
  table.insert(sync_table.table,key,tuple)
end

function SyncTable:merge(first_table,second_table)
  local new_table = {}
  local new_operations = {}
  local major_table
  local minor_table
  if(first_table.user>=second_table.user) then
    major_table = first_table
    minor_table = second_table
  else
    major_table = second_table
    minor_table = first_table
  end


  major_f,major_t,major_k = pairs(major_table.table)
  major_k,major_v = major_f(major_t, major_k)
  minor_f,minor_t,minor_k = pairs(minor_table.table)
  minor_k,minor_v = minor_f(minor_t, minor_k)

  while major_k ~= nil and minor_k ~= nil do
    while major_k ~= nil do
      if (minor_table.operations[major_v.operation] == nil) then
        table.insert(new_table, major_v)
        major_k,major_v = major_f(major_t, major_k)

      else
        major_k,major_v = major_f(major_t, major_k)
        break
      end
    end
    while minor_k ~= nil do
      if major_table.operations[minor_v.operation] == nil then
        table.insert(new_table, minor_v)
        --minor_k,minor_v = minor_f(minor_t, minor_k)
      else
        --print(minor_table.operations[minor_v.operation], major_table.operations[minor_v.operation])
        xif = minor_table.operations[minor_v.operation] and major_table.operations[minor_v.operation]
        if xif then
          table.insert(new_table, minor_v)
        end    
        minor_k,minor_v = minor_f(minor_t, minor_k)
        if xif then
          break
        end 
      end
      minor_k,minor_v = minor_f(minor_t, minor_k)
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

  first_table.table = new_table
  first_table.operations = new_operations
end
---------------------------------------------
f_table = SyncTable:new("Vasya")
s_table = SyncTable:new("Petya")
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
SyncTable:merge(f_table,s_table)
--for k,v in pairs(f_table.operations) do
    --print(k,v)
--end
for k,v in pairs(f_table.table) do
    print(k,v.value)
end
print("----------------------")
SyncTable:insert(f_table, 4, "akaka")
SyncTable:insert(s_table, 2,"7")
SyncTable:remove(s_table, 3)
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
--[=
SyncTable:merge(s_table,f_table)
for k,v in pairs(s_table.table) do
    print(k,v.value, v.operation)
end
for k,v in pairs(s_table.operations) do
    print(k,v)
end
--]=]