--
-- Created by IntelliJ IDEA.
-- User: Gecko
-- Date: 07/08/2014
-- Time: 15:22
-- To change this template use File | Settings | File Templates.
--



Block = { }

function Block.new(block_type, pos_x, pos_y) 
  
  local self =  { }
  
  -- private fields
  local x = pos_x
  local y = pos_y
  --local last_move = 0
  local dropped = false
  local image = nil
  local symbol = block_type
  
  
  local function initialize(block_type, pos_x, pos_y)
        image = love.graphics.newImage(BLOCK_TYPE[block_type].img)
  end
  
  function self.getHeight() return image:getHeight() end
  function self.getWidth()  return image:getWidth() end

  function self.getRight() return x + self.getWidth() end
  function self.getBottom() return y + self.getHeight() end
  function self.getLeft() return x end
  function self.getTop() return y end
  
  function self.getSymbol() return symbol end

  function self.setDropped(t) 
    dropped = t
  end
 
  function self.isDropped() 
      return dropped
  end

  function self.move(dx, dy)  
    x = x + dx
    y = y + dy
  end
  
  function self.isMatching(block)
    if block == nil then
      return false
    else
      return symbol == block.getSymbol()
    end
  end

  function self.draw()
    love.graphics.draw(image, x, y)
  end
    
  initialize(block_type, pos_x, pos_y)

  return self

end





