--
-- Created by IntelliJ IDEA.
-- User: Gecko
-- Date: 07/08/2014
-- Time: 15:22
-- To change this template use File | Settings | File Templates.
--
require("table_helpers")



BLOCK_TYPE = {
    
    default = {name = "default", img = "media/block/default.png"},
    lava = {name = "lava", img = "media/block/lava01.png"},
    basalte = {name = "basalet", img = "media/block/basalt.png"},
    schiste = {name = "schiste", img = "media/block/schiste.png"},
    glaise = {name = "glaise", img = "media/block/glaise.png"},
    
}
setDefault(BLOCK_TYPE, BLOCK_TYPE.default)

function getRandomBlockType()
   local _t = {}
   local n = 0
   for i, k in pairs(BLOCK_TYPE) do 
       n = n + 1
       _t[n] = i
   end   
   local block = _t[math.random(n)]
   if block == "default" then
       return getRandomBlockType()
   else 
       return block
   end
end    



function newBlock(block_type, x, y)

    local self = {
        last_move = 0
    }

    self.__index = index

    local function initialize(block_type, x, y)
        --self position on screen
        self.x = x
        self.y = y

        --self texture
        self.image = love.graphics.newImage(BLOCK_TYPE[block_type].img)
    end

    local function getHeight() return self.image:getHeight() end
    local function getWidth()  return self.image:getWidth() end

    local function getRight() return self.x + getWidth() end
    local function getBottom() return self.y + getHeight() end
    local function getLeft() return self.x end
    local function getTop() return self.y end
    
    local function getLastMove()
        return self.last_move
    end
    
    local function setLastMove(caller, t) 
        self.last_move = t
    end

    local function move(caller, dx, dy)
        self.x = self.x + dx
        self.y = self.y + dy
    end

    local function draw()
        love.graphics.draw(self.image, self.x, self.y)
    end

    --initialize the new self
    initialize(block_type, x, y)

    return {
        getWidth = getWidth,
        getHeight = getHeight,

        getRight = getRight,
        getBottom = getBottom,
        getLeft = getLeft,
        getTop = getTop,

        getLastMove = getLastMove,
        setLastMove = setLastMove,
        
        move = move,
        draw = draw
    }
end


