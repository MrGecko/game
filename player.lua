--
-- Created by IntelliJ IDEA.
-- User: Gecko
-- Date: 07/08/2014
-- Time: 17:25
-- To change this template use File | Settings | File Templates.
--

require "block_manager"


function newPlayer()

   local self = {
       direction = "idle"
   }

   local function keyboard(caller, dt)
       local moved = false
       if love.keyboard.isDown("right", "d") then
           block_manager:moveCurrentBlock(1, 0)
           self.direction = "right"
           move = true
       end

       if love.keyboard.isDown("left", "q", "a") then
           block_manager:moveCurrentBlock(-1, 0)
           self.direction = "left"
           moved = true
       end

       if not moved then
           self.direction = "idle"
       end
   end


   local function getDirection() return self.direction end

   local function draw()
       love.graphics.print(self.direction, 4, love.window.getHeight() - 16)
   end

   return {
       getDirection = getDirection,

       keyboard = keyboard,

       draw = draw
   }

end



