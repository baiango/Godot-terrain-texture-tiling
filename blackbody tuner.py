# https://tannerhelland.com/2012/09/18/convert-temperature-rgb-algorithm-code.html
temperature = 40000

from math import log
temperature = min(max(temperature, 1000), 40000)
temperature /= 100.0
if temperature <= 66:
	red = blue = 255
	green = 99.4708025861 * log(temperature) - 161.1195681661
else:
	red = green = temperature - 60
	red = red ** -0.1332047592 * 329.698727446
	green = green ** -0.0755148492 * 288.1221695283
	blue = 0
	if not temperature <= 19:
		blue = temperature - 10
		blue = 138.5177312231 * log(blue) - 305.0447927307
red, green, blue = min(max(red, 0), 255), min(max(green, 0), 255), min(max(blue, 0), 255)
red, green, blue = round(red), round(green), round(blue)

print(hex(red)[2:] + hex(green)[2:] + hex(blue)[2:])
