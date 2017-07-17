
local _M = {
    _VERSION = '0.01'
}

_M.get = function()
    local headers = ngx.req.get_headers()
	local u = headers["X-YF-Uid"] or headers["X-Uid"]
	return u
end
return _M
