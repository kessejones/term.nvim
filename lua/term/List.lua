---@class Node
---@field value any
---@field next? Node
---@field prev? Node

---@class List
---@field head Node
---@field tail Node
---@field len number
local List = {}

---create new list
---@return List
function List.new()
    local instance = {
        head = nil,
        tail = nil,
        len = 0,
    }

    setmetatable(instance, { __index = List })

    return instance
end

---push value to list
---@param value any
function List:push(value)
    local node = {
        value = value,
        next = nil,
        prev = nil,
    }

    if not self.head or not self.tail then
        self.head = node
        self.tail = self.head
    else
        node.prev = self.tail
        self.tail.next = node
        self.tail = node
    end
    self.len = self.len + 1
end

---remove value
---@param value any
---@return boolean
function List:remove(value)
    local node = self.head
    while node ~= nil do
        if node.value == value then
            if node == self.head then
                if node.next then
                    self.head = node.next
                    self.head.prev = nil
                else
                    self.head = nil
                    self.tail = nil
                end
            elseif self.tail == node then
                if node.prev then
                    self.tail = node.prev
                    self.tail.next = nil
                end
            else
                if node.next then
                    node.prev.next = node.next
                    node.next.prev = node.prev
                end
            end
            self.len = self.len - 1
            return true
        end

        node = node.next
    end

    return false
end

---delete value of index
---@param index number
---@return boolean
function List:delete(index)
    local node = self.head
    local i = 0
    while node ~= nil do
        if i == index then
            if node == self.head then
                if node.next then
                    self.head = node.next
                    self.head.prev = nil
                else
                    self.head = nil
                    self.tail = nil
                end
            elseif self.tail == node then
                if node.prev then
                    self.tail = node.prev
                    self.tail.next = nil
                end
            else
                if node.next then
                    node.prev.next = node.next
                    node.next.prev = node.prev
                end
            end
            self.len = self.len - 1
            return true
        end
        i = i + 1
        node = node.next
    end
    return false
end

---get index of value
---@param value any
---@return any?
function List:index_of(value)
    local node = self.head
    local i = 0
    while node ~= nil do
        if node.value == value then
            return i
        end

        node = node.next
        i = i + 1
    end
    return nil
end

---get value from index
---@param index number
---@return any?
function List:get(index)
    local node = self.head
    local i = 0
    while node ~= nil do
        if i == index then
            return node.value
        end

        node = node.next
        i = i + 1
    end
    return nil
end

---length of list
---@return number
function List:length()
    return self.len
end

return List
