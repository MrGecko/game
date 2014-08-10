--
-- Created by IntelliJ IDEA.
-- User: Gecko
-- Date: 07/08/2014
-- Time: 20:49
-- To change this template use File | Settings | File Templates.
--

Well = { }

function Well.new(pos_x, pos_y, nb_horizontal_block, nb_vertical_block, manager)
  local self = { }
  
  local image = { }
  
  local x = pos_x
  local y = pos_y
  local width = nb_horizontal_block
  local height = nb_vertical_block
  local size = nil
    
  local padding = {top=2, left=6, bottom=6, right=6 }
  local block_manager = nil
  local grid = { }
  
  function self.getX() return x end
  function self.getY() return y end
  function self.getWidth() return width end
  function self.getHeight() return height end
  function self.getSize() return size end
  
  function self.getColumnX(idx)
      return x + size * (idx - 1)
  end
  
  function self.getBlockLine(block)
      return 1 + math.ceil((block.getTop() - y) / size)
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
  
  -- get the number of the column where is located the current block
  function self.getColumnNumber(pos_x)
      return 1 + (pos_x - x) / size
  end
  
  function self.getBlock(i, j)
      local col = grid[i]
      if col == nil then
        return nil
      else
        return grid[i][j]
      end
  end
  

  function self.setBlock(i, j, block)
    if grid[i][j] then
        error("cannot set block " .. i .. "," .. j .. ": it is not empty")
    else
        grid[i][j] = block
    end
  end


  local function isBlockInChain(chain, block)
    local result = false 
    for i, b in ipairs(chain) do
      if b.x == block.x and b.y == block.y then
        result = true
        break
      end
    end
    return result
  end
  
  local function addToChain(chain, new_blocks)
 
    if new_blocks ~= nil then
      for i,b in ipairs(new_blocks) do
        if b ~= nil then
          --print(b.block.getSymbol())
          if not isBlockInChain(chain, b) then
            if #chain == 0 then
              table.insert(chain, b)
            else
              --table.foreach(chain, function(j, t) print(t.block.getSymbol()) end)
              if chain[1].block.isMatching(b.block) then
              
              table.insert(chain, b)
              end
            end
          end
        end
      end
    end
      
    --table.foreach(chain, function(i, t) table.foreach(t, print) end)
    return chain
  end

  function self.getBlockChain(block, x, y, from)
      local chain = { {block=block, x=x, y=y} }
    
      local left = self.getBlock(x-1, y)
      local right = self.getBlock(x+1, y)
      local down = self.getBlock(x, y+1)
      local up = self.getBlock(x, y-1)
      
      if left and from ~= "right" then
        --print("left")
        --table.foreach(chain, function(i, t) table.foreach(t, print) end)
        chain = addToChain(chain, self.getBlockChain(left, x-1, y, "left"))
        --chain = addToChain(chain, left)
      end
      
      if right and from ~= "left" then
        --print("right")
        --table.foreach(chain, function(i, t) table.foreach(t, print) end)
        chain = addToChain(chain, self.getBlockChain(right, x+1, y), "right")
        --chain = addToChain(chain, right)
      end
      
      if down and from ~= "up" then
        --print("down")
        chain = addToChain(chain, self.getBlockChain(down, x, y+1, "down"))
        --chain = addToChain(chain, down)
      end
      
      if up and from ~= "down" then
        --print("down")
        chain = addToChain(chain, self.getBlockChain(up, x, y+1, "up"))
        --chain = addToChain(chain, down)
      end
      
 
      return chain--addToChain(chain, addToChain(left, addToChain(right), down) )
  end

  function self.draw()  

      for j=1,height do
          for i=1,width do
              --slots
              local slot_x = x + image["empty_slot"]:getWidth() * (i - 1)
              local slot_y = y + image["empty_slot"]:getHeight() * (j - 1)
              
              local slot_img = image["empty_slot"]
              if j <= block_manager.getGroupSize() then
                slot_img = image["limit_slot"]
              end
     
              love.graphics.draw(slot_img, slot_x, slot_y)
              
              --blocks
              if grid[i][j] then
                  grid[i][j].draw()
              end
          end
      end
      
  end

  local function initialize()
    
    image["empty_slot"] = love.graphics.newImage("media/block/empty_slot.png")
    image["limit_slot"] = love.graphics.newImage("media/block/limit_slot.png")
    size = image["empty_slot"]:getWidth()
    
    block_manager = manager
    
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


