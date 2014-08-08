--
-- Created by IntelliJ IDEA.
-- User: Gecko
-- Date: 07/08/2014
-- Time: 16:03
-- To change this template use File | Settings | File Templates.
--

require("block")
require("well")




function newBlockManager()

    local self = {
        last_move = 0,
        move_speed = 0.15,

        last_drop = 0,
        drop_speed = 250,
        slow_drop_speed = 250,
        fast_drop_speed = 900,
        dropping = false,

        group_size = 3,

        block_queue = {
            
        },

        well = nil
    }
    
    
    local function initialize()
        local size = 32
        local nb_width, nb_height = 12, 15
        local padX = 204
        local padY = 52
        self.well = newWell(padX, padY, nb_width, nb_height, size)
    end

    -- peek the last block of the queue
    local function peekLastBlock()
        --local a, b, c = #self.block_queue - 1, #self.block_queue, #self.block_queue + 1
        --a, b, c = self.block_queue[a], self.block_queue[b], self.block_queue[c]
        return self.block_queue[#self.block_queue]
    end
    
    -- push a new block to the queue and place it in the middle column
    local function pushBlock(caller, block_type)
        local x = self.well:getColumnX(0.5 * self.well:getColumnCount())
        local y = self.well:getY()

        local new_block = newBlock(block_type, x , y)
        self.block_queue[#self.block_queue + 1] = new_block
    end
    
    -- pop the last block from the queue and return it
    local function popLastBlock()
        if #self.block_queue <= 0 then
            return nil --error("list is empty")
        else
            local last_block = self.block_queue[#self.block_queue]
            self.block_queue[#self.block_queue] = nil
            return last_block
        end
    end


    -- get the idx of the column where is located the current block
    local function getCurrentColumn()
        local col = nil
        local cb = peekLastBlock()
        if cb ~= nil then
            col = self.well:getColumnNumber(cb:getLeft())
        end
        return col
    end


    -- move the current block on the horizontal axis
    local function moveCurrentBlock(caller, dx, dy)
        local cb = peekLastBlock()

        -- check if it is time to move
        if cb ~= nil and self.last_move >= self.move_speed then
            local col = getCurrentColumn()
            local next_col = col + dx
   
            -- boundarie checks
            if next_col < 1 or next_col > self.well:getColumnCount()  then
                dx = 0
            else
                -- check in order to not pass through higher columns
                local current_floor = self.well:getBlockLine(cb) 
                local next_floor = self.well:getFloorLine(next_col)
                if next_floor > current_floor then
                    -- calculate the horizontal delta for the block movement
                    dx = self.well:getColumnX(next_col) - cb.getLeft()
                else
                    dx = 0
                end
            end

            self.last_move = 0

            cb:move(dx, dy)
        end
    end
    
    local function startDroppingCurrentBlock( ... )
        self.dropping = true
    end

    -- drop the current block until it reaches the bottom of the well or another block
    local function dropCurrentBlock(dt)
        local cb = peekLastBlock()

        if cb ~= nil and self.dropping then
                            
            local col = getCurrentColumn()
            local floor = self.well:getFloorLine(col) 
            
            if floor >= self.well:getLimitLine() then
                local dy = math.floor(self.drop_speed * dt)
                local floor_line = (self.well:getY() + (floor) * self.well:getSize())
                
                if (cb:getBottom() + dy) > floor_line then
                    dy = floor_line - cb:getBottom()
                    self.dropping = false
                    self.last_drop = 0
                    self.well:setBlock(col, floor, popLastBlock())
                end
                cb:move(0, dy)
        
            else
                self.dropping = false
                self.last_drop = 0    
            end
        end
    end
    
    local function enableFastDrop()
        self.drop_speed = self.fast_drop_speed
    end
    
    local function disableFastDrop()
        self.drop_speed = self.slow_drop_speed
    end

    local function update(caller, dt)
        self.last_move = self.last_move + dt
        self.last_drop = self.last_drop + dt
        
        dropCurrentBlock(dt)
    end

    local function draw()

        -- draw the well
        self.well:draw()

        -- draw the current block
        local cb = peekLastBlock()
        if cb ~= nil then
            cb:draw()
            love.graphics.print("column: " .. getCurrentColumn())
        end
        
        love.graphics.print("blocks in queue: " .. #self.block_queue, 0, 30)
    end


    initialize()

    return {

        pushBlock = pushBlock,
        peekLastBlock = peekLastBlock,

        moveCurrentBlock = moveCurrentBlock,
        startDroppingCurrentBlock = startDroppingCurrentBlock,
        
        enableFastDrop = enableFastDrop,
        disableFastDrop = disableFastDrop,

        update = update,
        draw = draw,
    }
end