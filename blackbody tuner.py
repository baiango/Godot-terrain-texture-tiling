# https://tannerhelland.com/2012/09/18/convert-temperature-rgb-algorithm-code.html
temperature = 4000

from math import log
temperature = min(max(temperature, 1000), 40000)
temperature /= 100.0
if temperature <= 66:
	red = 255
	green = 99.4708025861 * log(temperature) - 161.1195681661
	blue = 0 if temperature <= 19 else 138.5177312231 * log(temperature - 10) - 305.0447927307
else:
	red = (temperature - 60) ** -0.1332047592 * 329.698727446
	green = (temperature - 60) ** -0.0755148492 * 288.1221695283
	blue = 255
red, green, blue = min(max(red, 0), 255), min(max(green, 0), 255), min(max(blue, 0), 255)
red, green, blue = round(red), round(green), round(blue)

print(hex(red)[2:] + hex(green)[2:] + hex(blue)[2:])
