local RomReader = {}
RomReader.__index = RomReader

function RomReader.new(data)
    assert(type(data) == "string", "ROM data must be a binary string")
    return setmetatable({data = data, size = #data}, RomReader)
end

function RomReader:readU8(offset)
    assert(offset >= 0 and offset < self.size, "ROM offset out of bounds")
    return self.data:byte(offset + 1)
end

function RomReader:readU16BE(offset)
    return self:readU8(offset) * 0x100 + self:readU8(offset + 1)
end

function RomReader:readBytes(offset, length)
    assert(length >= 0 and offset >= 0 and offset + length <= self.size, "ROM range out of bounds")
    return self.data:sub(offset + 1, offset + length)
end

function RomReader:readTitle()
    local raw = self:readBytes(0x134, 16)
    return raw:gsub("%z.*$", "")
end

function RomReader:bankCount(bankSize)
    bankSize = bankSize or 0x4000
    assert(self.size % bankSize == 0, "ROM size is not bank aligned")
    return self.size / bankSize
end

function RomReader:readBank(index, bankSize)
    bankSize = bankSize or 0x4000
    assert(index >= 0 and index < self:bankCount(bankSize), "bank index out of bounds")
    return self:readBytes(index * bankSize, bankSize)
end

return RomReader

