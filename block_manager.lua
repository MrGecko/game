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
    
    local function peekLastGroup()
        local group = {}
        local last_idx = #self.block_queue
        for i = 1, self.group_size do
            group[i] = self.block_queue[last_idx - i + 1]
        end 
        return group
    end
    
    local function pushLastGroup(caller, group)
        local x = self.well:getColumnX(0.5 * self.well:getColumnCount() - math.ceil(0.5*self.group_size)) 
        local y = self.well:getY()
        
        for i, block_type in ipairs(group) do
            local new_block = newBlock(block_type, x + i * self.well:getSize(), y)
            self.block_queue[#self.block_queue + 1] = new_block
        end    
    end
    
    local function popLastGroup()
        if #self.block_queue < self.group_size then
            return nil --error("list is empty")
        else
            local group = {}
            for i=1, self.group_size do
                local last_block = self.block_queue[#self.block_queue - i]
                group[i] = last_block
                self.block_queue[#self.block_queue - i] = nil
            end
            return group
        end
    end


    -- get the idx of the column where is located the current block
    local function getColumn(block)
        local col = nil
        if block ~= nil then
            col = self.well:getColumnNumber(block:getLeft())
        end
        return col
    end
    
    
    local function moveCurrentGroup(caller, dx, dy)
        local group = peekLastGroup()
        
        for i, block in ipairs(group) do
            local col = getColumn(block)
            local next_col = col + dx
            
            local on_screen_dx = 0
            local on_screen_dy = 0
                    
            -- check if it is time to move
            if block ~= nil and block:getLastMove() >= self.move_speed then
                -- boundaries check
                if next_col < 1 or next_col <= (#group - i) or (next_col + i - 1) > self.well:getColumnCount()  then
                    on_screen_dx = 0
                else
                    -- check in order to not pass through higher columns
                    local current_floor = self.well:getBlockLine(block) 
                    local next_floor = self.well:getFloorLine(next_col)
                    if next_floor > current_floor then
                        -- calculate the horizontal delta for the block movement
                        on_screen_dx = self.well:getColumnX(next_col) - block.getLeft()
                    else
                        on_screen_dx = 0
                    end
                end

                block:setLastMove(0)
                
                block:move(on_screen_dx, on_screen_dy)
            end   
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
        
        local group = peekLastGroup()
        for i, block in ipairs(group) do
            block:setLastMove(block:getLastMove() + dt)
        end
        
        self.last_drop = self.last_drop + dt
        --dropCurrentBlock(dt)
    end

    local function draw()

        -- draw the well
        self.well:draw()

        -- draw the current block
        local group = peekLastGroup()
        
        for i,block in ipairs(group) do
            if block ~= nil then
                block:draw()
            end
        end
    
        
        love.graphics.print("blocks in queue: " .. #self.block_queue, 0, 30)
    end


    initialize()

    return {

        pushLastGroup = pushLastGroup,
        --pushBlock = pushBlock,
        --peekLastBlock = peekLastBlock,

        --moveCurrentBlock = moveCurrentBlock,
        moveCurrentGroup = moveCurrentGroup,
        startDroppingCurrentBlock = startDroppingCurrentBlock,
        
        enableFastDrop = enableFastDrop,
        disableFastDrop = disableFastDrop,

        update = update,
        draw = draw,
    }
end