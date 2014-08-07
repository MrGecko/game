--
-- Created by IntelliJ IDEA.
-- User: Gecko
-- Date: 07/08/2014
-- Time: 16:11
-- To change this template use File | Settings | File Templates.
--
require("table_helpers")



function newList()

    local self = {
        first = 0,
        last = -1
    }

    self.__index = self

    local function pushRight (value)
        local last = self.last + 1
        self.last = last
        self[last] = value
    end

    local function pushLeft (value)
        local first = self.first - 1
        self.first = first
        self[first] = value
    end

    local function popLeft ()
        local first = self.first
        if first > self.last then error("list is empty") end
        local value = self[first]
        self[first] = nil        -- to allow garbage collection
        self.first = first + 1
        return value
    end

    local function popRight ()
        local last = self.last
        if self.first > last then error("list is empty") end
        local value = self[last]
        self[last] = nil         -- to allow garbage collection
        self.last = last - 1
        return value
    end

    local function peekLeft()
        local first = self.last
        if first > self.last then error("list is empty") end
        return self[first]
    end

    local function peekRight()
        local last = self.last
        if self.first > last then error("list is empty") end
        return self[last]
    end


    return {

        first = self.first,
        last = self.last,

        pushLeft = pushLeft,
        pushRight = pushRight,

        popLeft = popLeft,
        popRight = popRight,

        peekLeft = peekLeft,
        peekRight = peekRight
    }
end




