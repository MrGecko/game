--
-- Created by IntelliJ IDEA.
-- User: Gecko
-- Date: 07/08/2014
-- Time: 12:13
-- To change this template use File | Settings | File Templates.
--
require "frame/background"
require "block/block_manager"
require "player"





function love.load()
    
    love.window.setMode(800, 600)
    
    love.keyboard.setKeyRepeat(true)

    background = BackgroundFrame.new()

    block_manager = BlockManager.new()
    player = Player.new()
    

    for i=1,20 do
        local a = getRandomBlockType()
        local b = getRandomBlockType()
        local c = getRandomBlockType()
        block_manager.pushLastGroup({a, b, c})
    end
    
    block_manager.initializeGroup()
    
end


function love.update(dt)
    player.keyboard(dt)
    block_manager.update(dt)
end

function love.draw()
    background.draw()
    block_manager.draw()
    player.draw()
end


function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end



