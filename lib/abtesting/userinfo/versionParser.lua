
local _M = {
    _VERSION = '0.01'
}

_M.get = function()
    local args = ngx.req.get_uri_args()
    local headers = ngx.req.get_headers()
    local u = headers["X-YF-Version"] or args["nf_version"]
    return u
end
return _M
