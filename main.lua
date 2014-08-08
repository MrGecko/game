--
-- Created by IntelliJ IDEA.
-- User: Gecko
-- Date: 07/08/2014
-- Time: 12:13
-- To change this template use File | Settings | File Templates.
--
require "frame"
require "block_manager"
require "player"





function love.load()
    --image = love.graphics.newImage("media/frame/right_box.png")
    love.keyboard.setKeyRepeat(true)

    game_frame = newGameFrame()

    block_manager = newBlockManager()
    player = newPlayer()

    for i=1,50 do
        block_manager:pushBlock("basalt")
    end

end


function love.update(dt)
    player.keyboard(dt)
    block_manager:update(dt)
end

function love.draw()
    game_frame:draw()

    block_manager:draw()

    player:draw()
end


function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

end



