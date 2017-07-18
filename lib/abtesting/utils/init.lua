local modulename = "abtestingInit"
local _M = {}

_M._VERSION = '0.0.1'

_M.redisConf = {
    ["uds"]      = nil,
    ["host"]     = "127.0.0.1",
    ["port"]     = 6379,
    ["poolsize"] = 1000,
    ["idletime"] = 90 * 1000, 
    ["timeout"]  = 5 * 1000,
    ["dbid"]     = 0,
}

_M.divtypes = {
    ["iprange"]     = 'ipParser',  
    ["uidrange"]    = 'uidParser',
    ["uidsuffix"]   = 'uidParser',
    ["uidappoint"]  = 'uidParser',
    ["arg_city"]    = 'cityParser',
    ["version"]    = 'versionParser',
    ["url"]         = 'urlParser'
}   

_M.prefixConf = {
    ["policyLibPrefix"]     = 'ab:policies',
    ["policyGroupPrefix"]   = 'ab:policygroups',
    ["runtimeInfoPrefix"]   = 'ab:runtimeInfo',
    ["domainname"]          = ngx.var.domain_name,
}

_M.divConf = {
    ["default_backend"]     = ngx.var.default_backend,
    ["shdict_expire"]       = 60,   -- in s
--    ["shdict_expire"]       = ngx.var.shdict_expire,
}

_M.cacheConf = {
    ['timeout']             = ngx.var.lock_expire,
    ['runtimeInfoLock']     = ngx.var.rt_cache_lock,
    ['upstreamLock']        = ngx.var.up_cache_lock,
}

_M.indices = {
    'first', 'second', 'third',
    'forth', 'fifth', 'sixth', 
    'seventh', 'eighth', 'ninth'
}

_M.fields = {
    ['divModulename']       = 'divModulename',           
    ['divDataKey']          = 'divDataKey',
    ['userInfoModulename']  = 'userInfoModulename',
    ['divtype']             = 'divtype',
    ['divdata']             = 'divdata',
    ['idCount']             = 'idCount',
    ['divsteps']            = 'divsteps'
}

_M.loglv = {
    ['err']					= ngx.ERR, 
	['info']				= ngx.INFO,           
    ['warn']				= ngx.WARN,      
    ['debug']				= ngx.DEBUG,           
}

local function init_from_ext_config()
    local confutil = require("abtesting.utils.config_util")
    return confutil.init_from_ext_config(_M)
end

local ok, exp = pcall(init_from_ext_config)
if not ok then
    if ngx then
        ngx.log(ngx.ERR, "call init_from_ext_config() failed! err:", exp)
    end
end

return _M
