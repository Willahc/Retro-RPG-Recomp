local TileDecoder = {}

function TileDecoder.decode2Bpp(tileData)
    assert(type(tileData) == "string" and #tileData == 16, "a Game Boy tile must contain 16 bytes")
    local pixels = {}
    for y = 0, 7 do
        local low = tileData:byte(y * 2 + 1)
        local high = tileData:byte(y * 2 + 2)
        for x = 0, 7 do
            local bit = 7 - x
            local lowBit = math.floor(low / 2 ^ bit) % 2
            local highBit = math.floor(high / 2 ^ bit) % 2
            pixels[y * 8 + x + 1] = highBit * 2 + lowBit
        end
    end
    return pixels
end

return TileDecoder

