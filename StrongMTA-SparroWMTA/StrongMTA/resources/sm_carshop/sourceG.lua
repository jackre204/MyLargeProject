vehiclesTable = {
	{model = 402, price = 74165, limit = 12, premium = 0}, --charger
	{model = 467, price = 44165, limit = 20, premium = 0}, --charger 2013
	{model = 541, price = 49990, limit = 25, premium = 0}, --supra a90
	{model = 587, price = 43900, limit = 12, premium = 0}, --corvette
	{model = 526, price = 69900, limit = 70, premium = 0}, --Porsche 718 Cayman S
	{model = 502, price = 48900, limit = 24, premium = 0}, --Chevrolet Camaro SS
	{model = 411, price = 241200, limit = 5, premium = 0}, --Lamborghini Gallardo LP570-4
	{model = 477, price = 22300, limit = 120, premium = 0}, --Mazda RX-7
	{model = 547, price = 98500, limit = 20, premium = 0}, --Mercedes-Benz CLS S 63 AMG
	{model = 421, price = 59200, limit = 50, premium = 0}, --Lincoln Continental
	{model = 550, price = 59570, limit = 34, premium = 0}, --Dodge Challenger SRT Hellcat
	{model = 516, price = 21200, limit = -1, premium = 0}, --Toyota Camry XSE
	{model = 405, price = 23500, limit = -1, premium = 0}, --Ford Taurus
	{model = 579, price = 49750, limit = 60, premium = 0}, --Ford Explorer ST
	{model = 490, price = 36200, limit = 40, premium = 0}, --Chevrolet Suburban LTZ
	{model = 603, price = 11200, limit = -1, premium = 0}, --Ford Gran Torino 76
	{model = 566, price = 6200, limit = -1, premium = 0}, --Ford Crown Victoria LTD 87
	{model = 549, price = 97500, limit = 3, premium = 0}, --Ford Sierra RS-500
	{model = 458, price = 41200, limit = 8, premium = 0}, --Audi RS2 Avant
	{model = 442, price = 91190, limit = 15, premium = 0}, --Tesla Model X
	{model = 492, price = 76200, limit = 15, premium = 0}, --Tesla Model S
	{model = 503, price = 1050000, limit = 5, premium = 0}, --McLaren Senna
	{model = 429, price = 449000, limit = 5, premium = 0}, --Ford GT
	{model = 401, price = 2080000, limit = 1, premium = 0}, --Porsche 959 Sport
	{model = 496, price = 77200, limit = 15, premium = 0}, --Jaguar F-Type R
	{model = 400, price = 52400, limit = 35, premium = 0}, --Jeep Grand Cherokee SRT
	{model = 436, price = 23640, limit = 13, premium = 0}, --Nissan Datsun 240z
	{model = 600, price = 12300, limit = 50, premium = 0}, --Chevrolet El Camino
	{model = 426, price = 2300, limit = -1, premium = 0}, --Ford Crown Victoria
	{model = 506, price = 164150, limit = 10, premium = 0}, --Audi R8 V10
	{model = 466, price = 74900, limit = 42, premium = 0}, --BMW X7
	{model = 439, price = 27181, limit = 28, premium = 0}, --Delorean DMC-12
	{model = 551, price = 7319, limit = 105, premium = 0}, --Lincoln Town Car
	
	
}

function getCarPrice(modelId)
	for i = 1, #vehiclesTable do
		if vehiclesTable[i].model == modelId then
			return vehiclesTable[i].price
		end
	end
	return 8000
end