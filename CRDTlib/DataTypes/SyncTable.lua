SyncTable = {}
function SyncTable:new(username)
  local self = {}
  self.table = {}
  self.operations = {}
  self.user = username
  self.counter = 1
  return self
end

function SyncTable:getTable(sync_table,key,value)

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
function SyncTable:merge(first_sync_table,second_sync_table)
  first_inserts
  second_inserts
  common
  
end
---------------------------------------------
first_table = SyncTable:new("Vasya")
second_table = SyncTable:new("Petya")
SyncTable:insert(first_table, 1,"!")
SyncTable:insert(first_table, 1,"8")
--second_table:insert(second_table, 3,"?")
for k,v in pairs(first_table.table) do
    print(k,v.operation)
end
