local RomManifest = require("src.games.lacroan.RomManifest")
local RomReader = require("src.core.RomReader")
local RomValidator = require("src.import.RomValidator")

local state = {
    status = "Arraste a ROM canônica .gb para esta janela.",
    details = {},
    valid = false,
}

local function setResult(result)
    state.valid = result.ok
    state.status = result.ok and "ROM CANÔNICA VALIDADA" or "ROM REJEITADA"
    state.details = {
        "Arquivo: " .. (result.filename or "desconhecido"),
        "Tamanho: " .. tostring(result.size or 0) .. " bytes",
        "Título: " .. (result.title or "indisponível"),
        "Mapper: " .. (result.mapper or "desconhecido"),
        "Bancos: " .. tostring(result.banks or 0),
        "SHA-1: " .. (result.sha1 or "indisponível"),
    }
    for _, err in ipairs(result.errors or {}) do
        state.details[#state.details + 1] = "Erro: " .. err
    end
end

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setBackgroundColor(0.06, 0.07, 0.09)
end

function love.filedropped(file)
    local ok, openError = file:open("r")
    if not ok then
        setResult({ok = false, filename = file:getFilename(), errors = {openError or "não foi possível abrir"}})
        return
    end

    local data, readError = file:read()
    file:close()
    if not data then
        setResult({ok = false, filename = file:getFilename(), errors = {readError or "não foi possível ler"}})
        return
    end

    local reader = RomReader.new(data)
    local result = RomValidator.validate(reader, RomManifest, love.data.hash)
    result.filename = file:getFilename()
    setResult(result)
end

function love.draw()
    local width = love.graphics.getWidth()
    love.graphics.setColor(state.valid and {0.25, 0.9, 0.5} or {0.95, 0.82, 0.3})
    love.graphics.printf("RETRO RPG RECOMP", 24, 30, width - 48, "center")
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(state.status, 24, 78, width - 48, "center")
    local y = 130
    for _, line in ipairs(state.details) do
        love.graphics.print(line, 36, y)
        y = y + 24
    end
    love.graphics.setColor(0.6, 0.65, 0.72)
    love.graphics.printf("A ROM é lida somente em memória e não é copiada para o projeto.", 24, love.graphics.getHeight() - 52, width - 48, "center")
end

