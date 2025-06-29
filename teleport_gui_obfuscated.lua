-- 🔒 Obfuscated By Ari
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
function decode(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i - f%2^(i-1) > 0 and '1' or '0') end
        return r
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c + (x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

loadstring(decode("CmxvY2FsIGZ1bmMgPSBmdW5jdGlvbihmKSwgciwgdix3CnIgPSByIG9yIGZ1bmN0aW9uKCkKdj12IHx8IGZ1bmN0aW9uKCkgcmV0dXJuICIgeyB9IiBlbmQKd2U9dyBvciBmdW5jdGlvbigpIHJldHVybiBmYWxzZSBlbmQKZ2V0Z2VudigpLndyaXRlZmlsZSA9IGZ1bmMoKSB3aXRoIHZhbHVlIGZ1bmN8fFtdIGVuZApnZXRnZW52KCkucmVhZGZpbGUgPSBmKGZ1bmMpIHZhbHVlIHYgZW5kCmdldGdlbnYoKS5pc2ZpbGUgPSBmKHdyaXRlZmlsZSwgcmVhZGZpbGUsIHdlKQpsb2NhbCBKU09OLCAgSFRUUFMsIEJhc2U2NCA9IGdhbWU6R2V0U2VydmljZSgiSHR0cFNlcnZpY2UiKSwgZ2FtZTpHZXRTZXJ2aWNlKCkiOiJCYXNlNjREZWNvZGUiCmxvY2FsIGZpbGUgPSAiZGVsZmlsZS50eHQiIAppZiBpc2ZpbGUoZmlsZSkgdGhlbgogICAgbG9jYWwgc3VjLCBkYXRhID0gcGNhbChmdW5jdGlvbigpIHJldHVybiBKU09OOkpTT05EZWNvZGUocmVhZGZpbGUoZmlsZSkpIGVuZCkKICAgIGlmIHN1YyBhbmQgdHlwZShkYXRhKSA9PSAidGFibGUiIHRoZW4KICAgICAgICByZXR1cm4gZGF0YQogICAgZW5kCmVuZQ=="))()
