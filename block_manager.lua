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
        move_speed = 0.03,

        drop_speed = 0,
        slow_drop_speed = 500,
        fast_drop_speed = 1000,
        
        dropped = 0,
        dropping = false,


        group_size = 3,
        current_group = nil,

        block_queue = {
            
        },

        well = nil
    }
    
    
    
    local function peekLastGroup()
        local group = {}
        for i = 1, self.group_size do
            group[i] = self.block_queue[last_idx - i + 1]
        end 
        return group
    end
    
    local function popLastGroup()
        if #self.block_queue < self.group_size then
            return nil --error("list is empty")
        else
            local group = {}
            for i=1, self.group_size do
                local last_block = self.block_queue[#self.block_queue]
                group[i] = last_block
                self.block_queue[#self.block_queue] = nil
            end
            return group
        end
    end
    
    local function pushLastGroup(caller, group)
        local x = self.well:getColumnX(0.5 * self.well:getColumnCount() - math.ceil(0.5*self.group_size)) 
        local y = self.well:getY()
        for i, block_type in ipairs(group) do
            local new_block = newBlock(block_type, x + i * self.well:getSize(), y)
            self.block_queue[#self.block_queue + 1] = new_block
        end    
    end
    
    local function initialize()
        local size = 32
        local nb_width, nb_height = 12, 15
        local padX = 204
        local padY = 52
        self.well = newWell(padX, padY, nb_width, nb_height, size)
    end
    
    local function initializeGroup()
        self.dropped = 0
        self.current_group = popLastGroup()
    end

    
    
    local function popLastBlock()
        if #self.block_queue < 1 then
            return nil --error("list is empty")
        else
            local last_block = self.block_queue[#self.block_queue]
            self.block_queue[#self.block_queue] = nil
            return last_block
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
         
        if self.current_group ~= nil and not self.dropping then    
            for i, block in ipairs(self.current_group) do
                local col = getColumn(block)
                local next_col = col + dx        
                local on_screen_dx = 0
                local on_screen_dy = 0
                        
                -- check if it is time to move
                if block ~= nil and self.last_move >= self.move_speed then
                    -- boundaries check
                    if next_col < 1 or next_col <= (#self.current_group - i) or 
                    (next_col + i - 1) > self.well:getColumnCount() then
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
            
                    moved = true
                    block:move(on_screen_dx, on_screen_dy)
                end   
            end
            
            if moved then
                self.last_move = 0
            end
        end
    end
    
 
    local function startDroppingCurrentGroup()
        if self.dropped == 0 and not self.dropping then
            
            local droppable = 0
            for i, block in ipairs(self.current_group) do
            
                if not block:isDropped() then
                    local col = getColumn(block)
                    local floor = self.well:getFloorLine(col) 
                    if floor >= self.well:getLimitLine() then
                        droppable = droppable + 1
                    end
                end
            end
            
            -- the entire group can be dropped
            if droppable == self.group_size then
                self.dropping = true
            end
        end
    end

    -- drop the current block until it reaches the bottom of the well or another block
    local function dropCurrentGroup(dt)
       
        if self.dropped < self.group_size and self.dropping then
            local dy = math.floor(self.drop_speed * dt)
            
            for i, block in ipairs(self.current_group) do
                
                if not block:isDropped() then
                    local on_screen_dy = dy
                    local col = getColumn(block)
                    local floor = self.well:getFloorLine(col)     
                    local floor_y = (self.well:getY() + floor * self.well:getSize())
                    
                    if (block:getBottom() + on_screen_dy) >= floor_y then
                        
                        on_screen_dy = floor_y - block:getBottom()
                        
                        self.dropped = self.dropped + 1
                        block:setDropped(true)
                        self.well:setBlock(col, floor, block)
                        
                    end
                    
                    block:move(0, on_screen_dy)
               end           
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
        
        -- check if the current group is completely dropped 
        -- and in that case pop a new one from the queue
        if self.dropped >= self.group_size and self.dropping then
            self.dropping = false
            self.dropped = 0
            self.current_group = popLastGroup()
        end
        
        self.last_move = self.last_move + dt
        
        if self.current_group ~= nil then
            dropCurrentGroup(dt)
        end

    end

    local function draw()

        -- draw the well
        self.well:draw()

        -- draw the current block
        if self.current_group ~= nil then
            for i,block in ipairs(self.current_group) do
                if block ~= nil then
                    block:draw()
                end
            end
        end
        
        love.graphics.print("blocks in queue: " .. #self.block_queue, 0, 30)
    end


    initialize()

    return {
        
        
        initializeGroup = initializeGroup,
        pushLastGroup = pushLastGroup,
        --pushBlock = pushBlock,
        --peekLastBlock = peekLastBlock,

        --moveCurrentBlock = moveCurrentBlock,
        moveCurrentGroup = moveCurrentGroup,
        startDroppingCurrentGroup = startDroppingCurrentGroup,
        
        enableFastDrop = enableFastDrop,
        disableFastDrop = disableFastDrop,

        update = update,
        draw = draw,
    }
end