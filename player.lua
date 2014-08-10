--
-- Created by IntelliJ IDEA.
-- User: Gecko
-- Date: 07/08/2014
-- Time: 17:25
-- To change this template use File | Settings | File Templates.
--

require "block/block_manager"


Player = {}

function Player.new()
  local self = { }
  
  local direction = "idle"
  
  function self.keyboard( dt)
     direction = "idle"

     if love.keyboard.isDown("right", "d") then
        block_manager.moveCurrentGroup(1, 0)
        direction = "right"
     end

     if love.keyboard.isDown("left", "q") then
        block_manager.moveCurrentGroup(-1, 0)
        direction = "left"
     end

     if love.keyboard.isDown("down", "s") then
        block_manager.startDropping()
     end
     
     if love.keyboard.isDown("up", "z", "a") then
        block_manager.rotate()
     end
     
     if love.keyboard.isDown("lshift") then
        block_manager.enableFastDrop()
     else
        block_manager.disableFastDrop()
     end

  end

  function self.draw()
     love.graphics.print(direction, 4, love.window.getHeight() - 16)
  end


  return self
end


