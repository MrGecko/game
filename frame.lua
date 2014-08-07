--
-- Created by IntelliJ IDEA.
-- User: Gecko
-- Date: 07/08/2014
-- Time: 13:42
-- To change this template use File | Settings | File Templates.
--


function newGameFrame(...)

    local self = {}

    local function initialize(...)
        self.right_frame = love.graphics.newImage("media/frame/right_box.png")
        print("Game Frame initialized")
        return self
    end

    local function draw()
        love.graphics.print("Darwin", 0, 14)
        love.graphics.draw(self.right_frame, self.right_frame:getWidth(), self.right_frame:getHeight())
    end

    --call the initialization method
    initialize(unpack(arg))

    return {
        draw = draw
    }

end





