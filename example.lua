local lcd = require("i2clcd")

lcd.begin(7, 6, 16, 2)
lcd.print("Hello world!")

tmr.alarm(0, 1000, 1, function()
	lcd.setCursor(0, 1)
	lcd.print(tostring(tmr.now() / 1000000))
	lcd.setBacklight(1)
    tmr.alarm(1, 500, 1, function()
        lcd.setBacklight(0)
    end)
end)
