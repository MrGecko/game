--
-- Created by IntelliJ IDEA.
-- User: Gecko
-- Date: 07/08/2014
-- Time: 20:49
-- To change this template use File | Settings | File Templates.
--



function newWell(x, y, nb_width, nb_height, size)

    local self = {
        x = x,
        y = y,
        width = nb_width,
        height = nb_height,
        size = size,

        padding = {top=2, left=4, bottom=6, right=4 },

        grid =  {}
    }

    local function getX() return self.x end
    local function getY() return self.y end

    -- get the count of columns
    local function getColumnCount()
        return self.width
    end

    local function getColumnX(caller, idx)
        return self.x + self.size * idx
    end

    -- get the number of the column where is located the current block
    local function getColumnNumber(caller, x)
        return  (x - self.x) / self.size
    end

    local function setBlock(caller, x, y, block)
        if self.grid[x][y] ~= nil and block ~= nil then
            error("cannot set block: " .. x .. "," .. y .. " is not empty")
        else
            self.grid[x][y] = block
        end
    end

    local function draw()

        --outer rect
        love.graphics.setColor(50, 50, 50, 110)
        love.graphics.rectangle("fill",
            self.x - self.padding.left,
            self.y - self.padding.top,
            self.width*self.size + self.padding.left + self.padding.right,
            self.height*self.size + self.padding.top + self.padding.bottom)

        --inner rect
        love.graphics.setColor(50, 50, 50, 255)
        love.graphics.rectangle("fill", self.x, self.y, self.width*self.size, self.height*self.size)

        love.graphics.setColor(255, 255, 255, 255 )

    end

    --initialize
    for i=1,self.width do
        self.grid[i] = {}
    end

    return {

        getX = getX,
        getY = getY,

        getColumnCount = getColumnCount,
        getColumnNumber = getColumnNumber,
        getColumnX = getColumnX,

        setBlock = setBlock,

        draw = draw
    }



end

