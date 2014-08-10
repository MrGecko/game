--
-- Created by IntelliJ IDEA.
-- User: Gecko
-- Date: 07/08/2014
-- Time: 15:46
-- To change this template use File | Settings | File Templates.
--


function setDefault (t, d)
    local mt = {__index = function () return d end}
    setmetatable(t, mt)
end


function prettyPrint(t)
    print("PP")
    for i in ipairs(t) do
        print(i .. "=" .. t[i])
    end
end

