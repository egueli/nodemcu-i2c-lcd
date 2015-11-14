# `nodemcu-i2clcd`: a NodeMCU module for Adafruit's LCD backpack


This small library allows you to connect an ESP8266 running NodeMCU to a character LCD display based on the HD44780 chip.

To use as little GPIOs as possible, this library assumes that the display is connected to the ESP8266 through an I2C expander, specifically the Microchip MCP23008 in Adafruit's [i2c / SPI character LCD backpack](https://www.adafruit.com/products/292). 

The code is a mix between Adafruit's [LiquidCrystal library](https://github.com/adafruit/LiquidCrystal) for Arduino and the code from [this forum post](http://www.esp8266.com/viewtopic.php?p=11075#p11075).

## Usage
```lua
local lcd = require("i2clcd")

-- use GPIO pin 7 and 6 for SDA and SCL respectively,
-- and tell the library the display is 16x2 characters big.
lcd.begin(7, 6, 16, 2)
lcd.setBacklight(1)      -- will turn on backlight if available
lcd.print("Hello world!")
```

## Prerequisites

### Hardware
* An ESP8266 module
* Adafruit's i2c / SPI character LCD backpack
* A level shifter like [this](http://www.adafruit.com/products/757), because ESP8266 works with 3.3V TTL, but the backpack works at 5V levels

### Software
* NodeMCU with the following modules built: node, GPIO, file, i2c, tmr, bit 
* The [mcp23008 module for NodeMCU](https://github.com/CHERTS/esp8266-devkit/tree/master/Espressif/examples/nodemcu-firmware/lua_modules/mcp23008)


