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

        limit_line = 3,
        
        padding = {top=2, left=6, bottom=6, right=6 },

        grid =  {}
    }

    local function getX() return self.x end
    local function getY() return self.y end
    local function getWidth() return self.width end
    local function getHeight() return self.height end
    local function getSize() return self.size end
    
    local function getLimitLine() return self.limit_line end
    
    -- get the count of columns
    local function getColumnCount()
        return self.width
    end

    local function getColumnX(caller, idx)
        return self.x + self.size * (idx - 1)
    end
    
    local function getBlockLine(caller, block)
        return 1 + math.ceil((block:getTop() - self.y) / self.size)
    end

    -- get the number of the column where is located the current block
    local function getColumnNumber(caller, x)
        return 1 + (x - self.x) / self.size
    end

    local function setBlock(caller, x, y, block)
        if self.grid[x][y] then
            error("cannot set block " .. x .. "," .. y .. ": it is not empty")
        else
            print("set block[" .. x .. "," .. y .. "]")
            self.grid[x][y] = block
        end
    end

    local function getBlock(caller, x, y)
        return self.grid[x][y]
    end
    
    local function getFloorLine(caller, col)
       local floor = self.height
       for y=1,self.height do
           if self.grid[col][y] then               
               floor = y - 1
               break
           end
       end 
       
       return floor
    end

    local function draw()

        --outer rect
        love.graphics.setColor(140, 62, 52, 255)
        love.graphics.rectangle("fill",
            self.x - self.padding.left,
            self.y,
            self.width * self.size + self.padding.left + self.padding.right,
            self.height * self.size + self.padding.bottom)

        --inner rect
        love.graphics.setColor(84, 84, 84, 255)
        love.graphics.rectangle("fill", self.x, self.y, self.width*self.size, self.height*self.size)

        love.graphics.setColor(255, 255, 255, 255 )
        
        --blocks
        for y=1,self.height do
            for x=1,self.width do
                local block = self.grid[x][y]
                if block then
                    block:draw()
                end
            end
        end

    end

    --initialize
    for i=1,self.width do
        self.grid[i] = {}
        for j=1,self.height do
            self.grid[i][j] = false
        end
    end

    return {

        getX = getX,
        getY = getY,
        getWidth = getWidth,
        getHeight = getHeight,
        getSize = getSize,

        getLimitLine = getLimitLine,

        getColumnCount = getColumnCount,
        getColumnNumber = getColumnNumber,
        getColumnX = getColumnX,
        getBlockLine = getBlockLine,
        getFloorLine = getFloorLine,

        setBlock = setBlock,
        getBlock = getBlock,

        draw = draw
    }



end

