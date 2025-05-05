debugMode = false

dialogs = {
  sell = {
    dialogName = "cargoSell",
    cameraData = {startCoords = false, endCoords = false},
    sentences = {
      {
        sentence = "A fuvarlevélen másik cél szerepel.",
        standbyTime = 1000,
        isMinigame = false
      }
    }
  }
}

truckData = {

    freight = {
        {"Használt csomagolás", 4 * 0.5},
        {"Kecskesajt", 4 * 1.2},
        {"Kémény rendszer", 4 * 1.8},
        {"Játékok", 4 * 1.4},
        {"Csomagolt élelmiszer", 4 * 1.4},
        {"Mozgódaru alkatrészek", 4 * 2.1},
        {"Faforgács", 4 * 0.4},
        {"Faáru", 4 * 1.1},
        {"Forró vegyszerek", 4 * 2.5, true}
    },

    depo = {
        {
            name = "WABERERS",
            blip = {2247.0791015625, -2674.0671386719, 13.551832199097, 45},

            trailerPosition = {
                {-2070.3999023438, -2260.8000488281, 32.5, 135},
                {-2074.8000488281, -2257, 32.5, 136},
                {-2079.6000976563, -2252.6000976563, 32.299999237061, 136},
                {-2084.8000488281, -2247.6000976563, 32.299999237061, 136},
                {-2090.1000976563, -2242.6999511719, 32.299999237061, 136},
                {-2095.8999023438, -2237.1999511719, 32.299999237061, 136}
            },
            parkingPosition = {-2108.8447265625, -2296.8837890625, 29.77031288147, 320}
        },

        {
            name = "UPS",
            blip = {2252.1616210938, -2633.2092285156, 13.573989868164, 245},

            trailerPosition = {
                {1390.3000488281, 266.39999389648, 20.200000762939, 336},
                {1383, 269.79998779297, 20.200000762939, 336},
                {1375, 273.79998779297, 20.200000762939, 336}
            },

            parkingPosition = {1325.8608398438, 262.91494750977, 18.6703125, 337}
        },

        {
            name = "DPD",
            blip = {2183.7724609375, -2650.7951660156, 13.546875, 90},

            trailerPosition = {
                {-2114.7998046875, -32.154296875, 36, 0},
                {-2120.888671875, -32.798828125, 36, 0},
                {-2103.982421875, -31.2646484375, 36, 0}
            },

            parkingPosition = {-2115.8095703125, 7.41015625, 34.470311737061, 180}
        },
        
        --[[{
            name = "AMAZON",
            blip = {-1981.2220458984, 1388.3681640625, 6.4328123092651,0},

            trailerPosition = {
                {-2007.9000244141, 1336.4000244141, 7.2528123855591, 270},
                {-2007.5999755859, 1342.4000244141, 7.8, 270},
                {-1998.0999755859, 1351.6999511719, 7.8, 270},
                {-1998.1999511719, 1356.6999511719, 7.8, 270},
                {-1998.1999511719, 1363, 7.8, 270},
                {-1998, 1370, 7.8, 270},
                {-1997.8000488281, 1377, 7.8, 270}
            },

            parkingPosition = {-1955.5107421875, 1380.8896484375, 6.3703123092651, 90}
        },

        {
            name = "TNT",
            blip = {2350.4970703125, -2291.9931640625, 13.6328125, 220},

            trailerPosition = {
                {2355.1000976563, -2240.8000488281, 14.199999809265, 135},
                {2360.3999023438, -2246.1999511719, 14.199999809265, 135},
                {2366.1999511719, -2252, 14.199999809265, 135},
                {2372.6999511719, -2258.5, 14.199999809265, 135}
            },

            parkingPosition = {2325.1025390625, -2306.0478515625, 12.6703125, 315}
        },

        {
            name = "GLS",
            blip = {-2270.5, 2286.1025390625, 4.9082851409912, 0},

            trailerPosition = {
                {-2264.91015625, 2357.0517578125, 5.8211221694946, 153},
                {-2261.505859375, 2354.697265625, 5.8076243400574, 153},
                {-2258.013671875, 2351.390625, 5.8222751617432, 153}
            },

            parkingPosition = {-2261, 2312.2607421875, 3.85, 0}
        }]]
    }
}

convert = {}

function convertToLevel(exp)
    return math.floor(math.sqrt(0.04 * exp + 1))
end

function convertToXP(level)
    return level ^ 2 / 0.04 - 25
end

function getLevel(player)
    return convertToLevel(getElementData(player, "char.jobExperience") or 0)
end

function rotateAround(angle, offsetX, offsetY, baseX, baseY)
	angle = math.rad(angle)

	offsetX = offsetX or 0
	offsetY = offsetY or 0

	baseX = baseX or 0
	baseY = baseY or 0

	return baseX + offsetX * math.cos(angle) - offsetY * math.sin(angle),
          baseY + offsetX * math.sin(angle) + offsetY * math.cos(angle)
end

function getPositionFromElementOffset(element, offsetX, offsetY, offsetZ)
	local m = getElementMatrix(element)
	return offsetX * m[1][1] + offsetY * m[2][1] + offsetZ * m[3][1] + m[4][1],
          offsetX * m[1][2] + offsetY * m[2][2] + offsetZ * m[3][2] + m[4][2],
          offsetX * m[1][3] + offsetY * m[2][3] + offsetZ * m[3][3] + m[4][3]
end

function getPositionFromOffset(m, offsetX, offsetY, offsetZ)
	return offsetX * m[1][1] + offsetY * m[2][1] + offsetZ * m[3][1] + m[4][1],
          offsetX * m[1][2] + offsetY * m[2][2] + offsetZ * m[3][2] + m[4][2],
          offsetX * m[1][3] + offsetY * m[2][3] + offsetZ * m[3][3] + m[4][3]
end

function checkPlayerTrailer(playerElement)
    for k, v in ipairs(getElementsByType("vehicle", resourceRoot)) do
        local trailerOwner = getElementData(v, "trailer.owner") or 0
        
        if trailerOwner then
            local charID = getElementData(playerElement, "char.ID") or 0

            if charID then
                if trailerOwner == charID then
                    return v
                end
            end
        end
    end
end