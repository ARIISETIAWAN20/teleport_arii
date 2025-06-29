-- 🔒 Obfuscated Script by Ari
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

loadstring(decode("Ci0tIOKchSBUZWxlcG9ydCBHVUkgZ2FtZTpIdHRwU2VydmljZSgpOkJhc2U2NERlY29kZSgiUVhKcGFRPT0iKSB2ZXJzaSBmaW5hbCArIFByb3Rla3NpIExlbmdrYXAgKyBIV0lEIExvY2sgKyBBa3VuIEFtYW4gKyBNaW5pbWl6ZSBGaXggKyBBbnRpIENsaXAgU2VkZXJoYW5hCgotLSBQcm90ZWtzaSBGdW5nc2kgRmlsZSAodW50dWsgRXhlY3V0b3IgSFAvRGVsdGEpCmlmIG5vdCAod3JpdGVmaWxlIGFuZCByZWFkZmlsZSBhbmQgaXNmaWxlKSB0aGVuCiAgICBnZXRnZW52KCkud3JpdGVmaWxlID0gZnVuY3Rpb24oKSBlbmQKICAgIGdldGdlbnYoKS5yZWFkZmlsZSA9IGZ1bmN0aW9uKCkgcmV0dXJuIGdhbWU6SHR0cFNlcnZpY2UoKTpCYXNlNjREZWNvZGUoImUzMD0iKSBlbmQKICAgIGdldGdlbnYoKS5pc2ZpbGUgPSBmdW5jdGlvbigpIHJldHVybiBmYWxzZSBlbmQKZW5kCgpsb2NhbCBZdnNJckhCVCA9IGdhbWU6R2V0U2VydmljZShnYW1lOkh0dHBTZXJ2aWNlKCk6QmFzZTY0RGVjb2RlKCJXWFp6U1hKSVFsUT0iKSkKbG9jYWwgUWNUeHlOTEsgPSBZdnNJckhCVC5Mb2NhbFBsYXllcgpsb2NhbCBCblVQUXVqSSA9IGdhbWU6R2V0U2VydmljZShnYW1lOkh0dHBTZXJ2aWNlKCk6QmFzZTY0RGVjb2RlKCJRbTVWVUZGMWFraz0iKSkKbG9jYWwgU3lXcGxHWHAgPSBnYW1lOkdldFNlcnZpY2UoZ2FtZTpIdHRwU2VydmljZSgpOkJhc2U2NERlY29kZSgiVTNsWGNHeEhXSEE9IikpCmxvY2FsIGxZRGZMc21xID0gZ2FtZTpHZXRTZXJ2aWNlKGdhbWU6SHR0cFNlcnZpY2UoKTpCYXNlNjREZWNvZGUoImJGbEVaa3h6YlhFPSIpKQpsb2NhbCBtUWt4cmxrWCA9IGdhbWU6SHR0cFNlcnZpY2UoKTpCYXNlNjREZWNvZGUoImRHVnNaWEJ2Y25SZmNHOXBiblJ6TG1wemIyND0iKQpsb2NhbCBVZmZGa2F5aiA9IHtwb2ludDEgPSBuaWwsIHBvaW50MiA9IG5pbH0KbG9jYWwgT1dvVGZhdkEgPSBmYWxzZQpsb2NhbCBnUktkR2thYyA9IDgKCi0tIExvYWQgcG9pbnQgZGFyaSBmaWxlCmZ1bmN0aW9uIGxvYWRQb2ludHMoKQogICAgaWYgaXNmaWxlKG1Ra3hybGtYKSB0aGVuCiAgICAgICAgbG9jYWwgUkxaUHRkSXcsIGRhdGEgPSBwY2FsbChmdW5jdGlvbigpIHJldHVybiBCblVQUXVqSTpKU09ORGVjb2RlKHJlYWRmaWxlKG1Ra3hybGtYKSkgZW5kKQogICAgICAgIGlmIFJMWlB0ZEl3IGFuZCB0eXBlKGRhdGEpID09IGdhbWU6SHR0cFNlcnZpY2UoKTpCYXNlNjREZWNvZGUoImRHRmliR1U9IikgdGhlbiBVZmZGa2F5aiA9IGRhdGEgZW5kCiAgICBlbmQKZW5kCgpsb2FkUG9pbnRzKCkK"))()
