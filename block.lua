--
-- Created by IntelliJ IDEA.
-- User: Gecko
-- Date: 07/08/2014
-- Time: 15:22
-- To change this template use File | Settings | File Templates.
--
require("table_helpers")

local BLOCK_TYPE = {
    default = {img = "media/block/default.png"},
    basalt = {img = "media/block/basalt.png"}
}




setDefault(BLOCK_TYPE, BLOCK_TYPE.default)


Block = {

}

function newBlock(self_type, x, y)

    local self = { }

    local function initialize(self_type, x, y)
        --self position on screen
        self.x = x
        self.y = y

        --self texture
        self.image = love.graphics.newImage(BLOCK_TYPE[self_type].img)
    end

    local function getHeight() return self.image:getHeight() end
    local function getWidth()  return self.image:getWidth() end

    local function getRight() return self.x + getWidth() end
    local function getBottom() return self.y + getHeight() end
    local function getLeft() return self.x end
    local function getTop() return self.y end

    local function move(caller, dx, dy)
        self.x = self.x + dx
        self.y = self.y + dy
    end

    local function draw()
        love.graphics.draw(self.image, self.x, self.y)
    end

    --initialize the new self
    initialize(self_type, x, y)

    return {
        getWidth = getWidth,
        getHeight = getHeight,

        getRight = getRight,
        getBottom = getBottom,
        getLeft = getLeft,
        getTop = getTop,

        move = move,
        draw = draw
    }
end


