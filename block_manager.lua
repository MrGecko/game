--
-- Created by IntelliJ IDEA.
-- User: Gecko
-- Date: 07/08/2014
-- Time: 16:03
-- To change this template use File | Settings | File Templates.
--

require("block")

--require("player")


function newBlockManager()

    local self = {
        last_move = 0,
        move_speed = 0.15,

        block_queue = {
            count = 0
        },

        well = {
            x = 10,
            y = 10,
            width = 10,
            height = 16,
            COLUMN_WIDTH = 32
        }
    }

    local function initialize()
        self.well.x = 10
        self.well.y = love.window.getHeight() - self.well.COLUMN_WIDTH * self.well.height - 10
    end


    -- get a preview of the last block of the queue
    local function peekLastBlock()
        if self.block_queue.count < 0 then
            error("list is empty")
        else
            return self.block_queue[self.block_queue.count - 1]
        end
    end


    -- get the count of columns
    local function getColumnCount()
        return self.well.width
    end

    -- get the number of the column where is located the current block
    local function getCurrentColumn()
        local col = 0
        local cb = peekLastBlock()
        if cb ~= nil then
            col = (cb:getLeft() - self.well.x) / self.well.COLUMN_WIDTH
        end
        return col
    end


    -- push a new block to the queue and place it in the middle column
    local function pushBlock(caller, block_type)

        local x = self.well.x + 0.5 * getColumnCount() * self.well.COLUMN_WIDTH
        local y = self.well.y

        local new_block = newBlock(block_type, x , y)
        self.block_queue[self.block_queue.count + 1] = new_block
        self.block_queue.count = self.block_queue.count + 1
    end

    --move the current block on the horizontal starting line
    local function moveCurrentBlock(caller, dx, dy)
        local cb = peekLastBlock()

        if cb ~= nil and self.last_move >= self.move_speed then
            local next_col = getCurrentColumn() + dx

            if next_col < 0 or next_col > (getColumnCount() - 1) then
                dx = 0
            else
                dx = dx * self.well.COLUMN_WIDTH
            end

            self.last_move = 0

            cb:move(dx, dy)
        end
    end

    local function update(caller, dt)
        self.last_move = self.last_move + dt
    end

    local function draw()
        local cb = peekLastBlock()
        if cb ~= nil then
            cb:draw()
            love.graphics.print("column: " .. getCurrentColumn())

        end
    end


    initialize()

    return {

        initialize = initialize,

        pushBlock = pushBlock,
        peekLastBlock = peekLastBlock,

        moveCurrentBlock = moveCurrentBlock,

        update = update,
        draw = draw,
    }
end