--
-- Created by IntelliJ IDEA.
-- User: Gecko
-- Date: 07/08/2014
-- Time: 20:49
-- To change this template use File | Settings | File Templates.
--

Well = { }

function Well.new(pos_x, pos_y, nb_horizontal_block, nb_vertical_block)
  local self = { }
  
  local image = { }
  
  local x = pos_x
  local y = pos_y
  local width = nb_horizontal_block
  local height = nb_vertical_block
  local size = 1
  
  local limit_line = 3
  
  local padding = {top=2, left=6, bottom=6, right=6 }
  
  local grid = { }
  
  function self.getX() return x end
  function self.getY() return y end
  function self.getWidth() return width end
  function self.getHeight() return height end
  function self.getSize() return size end
    
  function self.getLimitLine() return limit_line end
  
  function self.getColumnX(idx)
      return x + size * (idx - 1)
  end
  
  function self.getBlockLine(block)
      return 1 + math.ceil((block.getTop() - y) / size)
  end

  -- get the number of the column where is located the current block
  function self.getColumnNumber(pos_x)
      return 1 + (pos_x - x) / size
  end
  
  function self.setBlock(i, j, block)
    if grid[i][j] then
        error("cannot set block " .. i .. "," .. j .. ": it is not empty")
    else
        grid[i][j] = block
    end
  end

  function self.getBlock(i, j)
      return grid[i][j]
  end
  
  function self.getFloorLine(col)
     local floor = height
     for y=1,height do
         if grid[col][y] then  
             floor = y - 1
             break
         end
     end 
     return floor
  end
  
  function self.draw()  

      for j=1,height do
          for i=1,width do
              --slots
              local slot_x = x + image["empty_slot"]:getWidth() * (i - 1)
              local slot_y = y + image["empty_slot"]:getHeight() * (j - 1)
              love.graphics.draw(image["empty_slot"], slot_x, slot_y)
              --blocks
              if grid[i][j] then
                  grid[i][j].draw()
              end
          end
      end
      
  end

  local function initialize()
    
    image["empty_slot"] = love.graphics.newImage("media/block/empty_slot.png")
    size = image["empty_slot"]:getWidth()
    
    --initialize
    for i=1,width do
        grid[i] = {}
        for j=1,height do
            grid[i][j] = false
        end
    end
  end
  
  initialize()
  
  return self
    
end


