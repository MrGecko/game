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
       self.direction = "idle"

       if love.keyboard.isDown("right", "d") then
           block_manager:moveCurrentGroup(1, 0)
           self.direction = "right"
       end

       if love.keyboard.isDown("left", "q", "a") then
           block_manager:moveCurrentGroup(-1, 0)
           self.direction = "left"
       end

       if love.keyboard.isDown(" ") then
            block_manager:startDroppingCurrentGroup()
       end
       
       if love.keyboard.isDown("lshift") then
           block_manager:enableFastDrop()
       else
           block_manager:disableFastDrop()
       end

   end

   local function draw()
       love.graphics.print(self.direction, 4, love.window.getHeight() - 16)
   end

   return {
       keyboard = keyboard,
       draw = draw
   }

end



