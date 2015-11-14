local moduleName = ...

local M = {}
_G[moduleName] = M 

local mcp = require ("mcp23008")

local lines = 16
local rows = 2

local backlight = 0

local function sendLcdToI2C(rs, e, data)
	local value = bit.lshift(rs, 1)
    value = value + bit.lshift(e, 2)
    value = value + bit.rshift(data, 1)
    value = value + backlight
	mcp.writeGPIO(value)
end

local function sendLcdRaw(rs, data)
	sendLcdToI2C(rs, 1, data)
	sendLcdToI2C(rs, 0, data)
end

local function sendLcd(rs, data)
	sendLcdRaw(rs, bit.band(data, 0xf0)) -- high nibble
	sendLcdRaw(rs, bit.lshift(bit.band(data, 0x0f), 4))  -- low nibble
end

function M.begin(pinSDA,pinSCL,lcdCols,lcdLines,address)
	address = address or 0
    lines = lcdLines
    cols = lcdCols
    
    mcp.begin(address,pinSDA,pinSCL,i2c.SLOW)
    mcp.writeIODIR(0x00) -- make all GPIO pins as outputs

	-- reset
    sendLcdRaw(0, 0x30)
    tmr.delay(5000)
    sendLcdRaw(0, 0x30)
    tmr.delay(5000)
    sendLcdRaw(0, 0x30)
    tmr.delay(5000)

    -- set to 4-bit mode
    sendLcdRaw(0, 0x20)

    -- set to 2-line mode (TODO read args)
    sendLcd(0, 0x28)

    -- clear display
    sendLcd(0, 0x01)

    -- turn on display
    sendLcd(0, 0x0c)
end

function M.write(ch)
    sendLcd(1, string.byte(ch, 1))
end

function M.print(s)
    for i = 1, #s do
        sendLcd(1, string.byte(s, i))
    end
end

M.ROW_OFFSETS = {0, 0x40, 0x14, 0x54}

function M.setCursor(col, row)
    local val = bit.bor(0x80, col, M.ROW_OFFSETS[row + 1]) 
    print (string.format("cursorcmd: %02x", val))
    sendLcd(0, val)
end

function M.setBacklight(b)
    backlight = bit.lshift(b, 7)
    mcp.writeGPIO(backlight)
end

return M
