-- Base64 Decode Function
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function decode(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    local bits = ''
    for i = 1, #data do
        local c = data:sub(i,i)
        if c ~= '=' then
            local f = b:find(c) - 1
            for j = 6, 1, -1 do
                bits = bits .. (f % 2^j - f % 2^(j-1) > 0 and '1' or '0')
            end
        end
    end
    local decoded = ''
    for i = 1, #bits-7, 8 do
        local byte = bits:sub(i, i+7)
        decoded = decoded .. string.char(tonumber(byte, 2))
    end
    return decoded
end

-- Script Arii versi Base64 (Delta Mobile Safe)
local encoded = [[{{BASE64_SCRIPT}}]]

-- Proteksi Fungsi File untuk Delta Executor
pcall(function()
    if not (writefile and readfile and isfile) then
        getgenv().writefile = function() end
        getgenv().readfile = function() return "{}" end
        getgenv().isfile = function() return false end
    end
end)

-- Eksekusi Script
loadstring(decode(encoded))()
