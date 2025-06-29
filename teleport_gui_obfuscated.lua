-- 🔐 Arii Obfuscated Loader - Versi Base64 Delta Executor Compatible

-- Base64 Decode Function
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function decode(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if x == '=' then return '' end
        local r, f = '', (b:find(x) - 1)
        for i = 6, 1, -1 do
            r = r .. (f % 2^i - f % 2^(i-1) > 0 and '1' or '0')
        end
        return string.char(tonumber(r, 2))
    end))
end

-- Script Utama (full obfuscated + dilindungi) dalam Base64
local encoded = [[
bG9jYWwgX0VOVl9TRUVEID0gZnVuY3Rpb24oKQogICAgbG9jYWwgX0dfPWdldGZlbnYgYW5kIGdldGZlbnYoMSkgb3IgX0VOViBvciB7fQogICAgbG9jYWwgb2JmID0ge30KICAgIGZvciBrLHYgaW4gcGFpcnMoX0dfKSBkbyBvYmZba109diBlbmQKICAgIHJldHVybiBzZXRtZXRhdGFibGUoe30sIHtfaW5kZXg9b2JmfSkKZW5kCgpsb2NhbCBfMFhBID0gX0VOVl9TRUVEKCkKbG9jYWwgXzB4QiA9IGZ1bmN0aW9uKC4uLikgcmV0dXJuIC4uLiBlbmQKbG9jYWwgXzB4QyA9IHNldG1ldGF0YWJsZSh7fSwge19pbmRleD1mdW5jdGlvbihfLGspIHJldHVybiBmdW5jdGlvb... (truncated)
]]

-- Proteksi Fungsi File untuk Delta Executor
loadstring(decode([[YQBwAGMAYQBsACgAZgB1AG4AYwB0AGkAbwBuACgAKQAKCWkAZgAgAG4AbwB0ACAAKAB3AHIAaQB0AGUAZgBpAGwAZQAgAGEAbgBkACAAcgBlAGEAZABmAGkAbABlACAAYQBuAGQAIABpAHMAZgBpAGwAZQApACAAdABoAGUAbgAKCQBnAGUAdABnAGUAbgB2ACgpLndyaXRlZmlsZSA9IGZ1bmN0aW9uKCkgZW5kCgkJZ2V0Z2VudigpLnJlYWRmaWxlID0gZnVuY3Rpb24oKSB...


-- Eksekusi Script Obfuscated
loadstring(decode(encoded))()
