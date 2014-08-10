--
-- Created by IntelliJ IDEA.
-- User: Gecko
-- Date: 07/08/2014
-- Time: 16:03
-- To change this template use File | Settings | File Templates.
--

require("helper/table_helpers")
require("well/well")
require("block/block")



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


BlockManager = { }

function BlockManager.new()
 
  local self = { }
  
  local last_move = 0
  local move_speed = 0.03
 
  local drop_speed = 0
  local slow_drop_speed = 500
  local fast_drop_speed = 1000
  
  local dropped = 0
  local dropping = false
 
  local group_size = 3
  local current_group = nil

  local block_queue = { }

  local well = nil
  
  -- return a table with the top 'group_size' x blocks
  function self.peekLastGroup()
    local group = {}
    for i=1,group_size do
        group[i] = block_queue[#block_queue - i + 1]
    end 
    return group
  end
  
  -- return a table with the top 'group_size' x blocks
  -- and remove them from the queue
  function self.popLastGroup()
    if #block_queue < group_size then
        return nil --error("list is empty")
    else
        local group = {}
        for i=1, group_size do
            local last_block = block_queue[#block_queue]
            group[i] = last_block
            block_queue[#block_queue] = nil
        end
        return group
    end
  end
  
  -- push a group of 'group_size' x blocks on the top of the queue
  function self.pushLastGroup(group)
    local y = well.getY()
    local x = well.getColumnX(0.5 * well.getWidth() - math.ceil(0.5*group_size)) 
    for i, block_type in ipairs(group) do
        local new_block = Block.new(block_type, x + i * well.getSize(), y)
        block_queue[#block_queue + 1] = new_block
    end    
 end
 
  function self.initialize()
    local size = 32
    local nb_width, nb_height = 12, 15
    local padX, padY = 204, 52
    well = Well.new(padX, padY, nb_width, nb_height, size)
  end
 
  function self.initializeGroup()
    dropped = 0
    current_group = self.popLastGroup()
  end
    
  -- get the idx of the column where is located the current block
  function self.getColumn(block)
      local col = nil
      if block ~= nil then
          col = well.getColumnNumber(block.getLeft())
      end
      return col
  end
  
  function self.moveCurrentGroup(dx, dy)   
       
    if current_group ~= nil and not dropping then    
        for i, block in ipairs(current_group) do
            local col = self.getColumn(block)
            local next_col = col + dx        
            local on_screen_dx = 0
            local on_screen_dy = 0
                    
            -- check if it is time to move
            if block ~= nil and last_move >= move_speed then
                -- boundaries check
                if next_col < 1 or next_col <= (#current_group - i) or 
                (next_col + i - 1) > well.getWidth() then
                    on_screen_dx = 0
                else
                    -- check in order to not pass through higher columns
                    local current_floor = well.getBlockLine(block) 
                    local next_floor = well.getFloorLine(next_col)
                    
                    if next_floor > current_floor then
                        -- calculate the horizontal delta for the block movement
                        on_screen_dx = well.getColumnX(next_col) - block.getLeft()
                    else
                        on_screen_dx = 0
                    end
                end
        
                moved = true
                block.move(on_screen_dx, on_screen_dy)
            end   
        end
   
        if moved then
            last_move = 0
        end
    end
    
  end
  
  
  function self.startDroppingCurrentGroup()
    if dropped == 0 and not dropping then
        
        local droppable = 0
        for i, block in ipairs(current_group) do
        
            if not block.isDropped() then
                local col = self.getColumn(block)
                local floor = well.getFloorLine(col) 
                if floor >= well.getLimitLine() then
                    droppable = droppable + 1
                end
            end
        end
        
        -- the entire group can be dropped
        dropping = droppable == group_size
    end
  end

  -- drop the current block until it reaches the bottom of the well or another block
  function self.dropCurrentGroup(dt)
   
    if dropped < group_size and dropping then
        local dy = math.floor(drop_speed * dt)
        
        for i, block in ipairs(current_group) do
            if not block.isDropped() then
                local on_screen_dy = dy
                local col = self.getColumn(block)
                local floor = well.getFloorLine(col)     
                local floor_y = (well.getY() + floor * well.getSize())
                
                if (block.getBottom() + on_screen_dy) >= floor_y then
                    
                    on_screen_dy = floor_y - block.getBottom()
                    
                    dropped = dropped + 1
                    block.setDropped(true)
                    well.setBlock(col, floor, block)     
                end
               
                block.move(0, on_screen_dy)
           end           
        end
    end
    
  end 
  
  function self.enableFastDrop()
      drop_speed = fast_drop_speed
  end
  
  function self.disableFastDrop()
      drop_speed = slow_drop_speed
  end

  function self.update(dt)
      
      -- check if the current group is completely dropped 
      -- and in that case pop a new one from the queue
      if dropped >= group_size and dropping then
          dropping = false
          dropped = 0
          current_group = self.popLastGroup()
      end
      
      last_move = last_move + dt
      
      if current_group ~= nil then
          self.dropCurrentGroup(dt)
      end

  end

  function self.draw()

      -- draw the well
      well.draw()

      -- draw the current block
      if current_group ~= nil then
          for i,block in ipairs(current_group) do
              if block ~= nil then
                  block.draw()
              end
          end
      end
      
      love.graphics.print("blocks in queue: " .. #block_queue, 0, 30)
  end


  self.initialize()
    
  return self
end

