local RomValidator = {}

local function toHex(binary)
    return (binary:gsub(".", function(byte)
        return string.format("%02x", string.byte(byte))
    end))
end

local function headerChecksum(reader)
    local checksum = 0
    for offset = 0x134, 0x14C do
        checksum = (checksum - reader:readU8(offset) - 1) % 0x100
    end
    return checksum
end

local function globalChecksum(reader)
    local checksum = 0
    for offset = 0, reader.size - 1 do
        if offset ~= 0x14E and offset ~= 0x14F then
            checksum = (checksum + reader:readU8(offset)) % 0x10000
        end
    end
    return checksum
end

function RomValidator.validate(reader, manifest, hashFunction)
    local errors = {}
    local function expect(actual, expected, field)
        if actual ~= expected then
            errors[#errors + 1] = string.format("%s: esperado %s, recebido %s", field, tostring(expected), tostring(actual))
        end
    end

    expect(reader.size, manifest.size, "tamanho")
    if reader.size >= 0x150 then
        expect(reader:readTitle(), manifest.title, "título")
        expect(reader:readU8(0x147), manifest.cartridgeType, "tipo de cartucho")
        expect(reader:readU8(0x148), manifest.romSizeCode, "código do tamanho da ROM")
        expect(reader:readU8(0x149), manifest.ramSizeCode, "código da RAM")
        expect(reader:readU8(0x14A), manifest.destinationCode, "região")
        expect(reader:readU8(0x14C), manifest.revision, "revisão")
        expect(headerChecksum(reader), reader:readU8(0x14D), "checksum do cabeçalho")
        expect(globalChecksum(reader), reader:readU16BE(0x14E), "checksum global")
    else
        errors[#errors + 1] = "arquivo curto demais para conter um cabeçalho Game Boy"
    end

    local sha1
    if hashFunction then
        sha1 = toHex(hashFunction("sha1", reader.data))
        expect(sha1, manifest.sha1, "SHA-1")
    end

    return {
        ok = #errors == 0,
        errors = errors,
        size = reader.size,
        title = reader.size >= 0x144 and reader:readTitle() or nil,
        mapper = manifest.mapper,
        banks = reader.size % manifest.bankSize == 0 and reader:bankCount(manifest.bankSize) or 0,
        sha1 = sha1,
    }
end

return RomValidator

