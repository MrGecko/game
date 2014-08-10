--
-- Created by IntelliJ IDEA.
-- User: Gecko
-- Date: 07/08/2014
-- Time: 13:42
-- To change this template use File | Settings | File Templates.
--


BackgroundFrame = { }

function BackgroundFrame.new(...)
  local self = {}
  
  local background_image = nil
  
  function self.initialize(...)
    --self.background_image = love.graphics.newImage("media/frame/background.png")
    love.graphics.setBackgroundColor(47, 47, 47, 255)
    print("Game Frame initialized")
  end

  function self.draw()
      
      love.graphics.print("Darwin", 0, 14)
      --love.graphics.draw(background_image)
      --love.graphics.draw(self.right_frame, self.right_frame:getWidth(), self.right_frame:getHeight())
  end

  --call the initialization method
  self.initialize(unpack(arg))
    
  return self
end


