--
-- Created by IntelliJ IDEA.
-- User: Gecko
-- Date: 07/08/2014
-- Time: 16:03
-- To change this template use File | Settings | File Templates.
--

require("block")
require("well")
--require("player")


function newBlockManager()

    local self = {
        last_move = 0,
        move_speed = 0.15,

        last_drop = 0,
        drop_speed = 0.1,
        dropping = false,

        block_queue = {
            count = 0
        },

        well = nil

    }

    local function initialize()
        local size = 32
        local padX = 20
        local padY = love.window.getHeight() - size * 16 - 20
        self.well = newWell(padX,padY,10,16,size)--{x=10, y=y, nb_width=10, nb_height=16, size=size}
    end

    -- push a new block to the queue and place it in the middle column
    local function pushBlock(caller, block_type)
        local x = self.well:getColumnX(0.5 * self.well:getColumnCount())
        local y = self.well:getY()

        local new_block = newBlock(block_type, x , y)
        self.block_queue[self.block_queue.count + 1] = new_block
        self.block_queue.count = self.block_queue.count + 1
    end

    -- get a preview of the last block of the queue
    local function peekLastBlock()
        if self.block_queue.count < 0 then
            error("list is empty")
        else
            return self.block_queue[self.block_queue.count - 1]
        end
    end

    -- get the number of the column where is located the current block
    local function getCurrentColumn()
        local col = 0
        local cb = peekLastBlock()
        if cb ~= nil then
            col = self.well:getColumnNumber(cb:getLeft())
        end
        return col
    end


    --move the current block on the horizontal starting line
    local function moveCurrentBlock(caller, dx, dy)
        local cb = peekLastBlock()

        if cb ~= nil and self.last_move >= self.move_speed then
            local next_col = getCurrentColumn() + dx

            if next_col < 0 or next_col > (self.well:getColumnCount() - 1) then
                dx = 0
            else
                dx = self.well:getColumnX(next_col) - cb.getLeft()
            end

            self.last_move = 0

            cb:move(dx, dy)
        end
    end

    local function dropCurrentBlock()
        local cb = peekLastBlock()

        if cb ~= nil then
            self.dropping = true
            self.last_drop = 0
        end
    end

    local function update(caller, dt)
        self.last_move = self.last_move + dt
    end

    local function draw()

        self.well:draw()

        local cb = peekLastBlock()
        if cb ~= nil then
            cb:draw()
            love.graphics.print("column: " .. getCurrentColumn())

        end

    end


    initialize()

    return {

        pushBlock = pushBlock,
        peekLastBlock = peekLastBlock,

        moveCurrentBlock = moveCurrentBlock,

        update = update,
        draw = draw,
    }
end