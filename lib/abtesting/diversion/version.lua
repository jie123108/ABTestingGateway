local modulename = "abtestingDiversionVersion"

local _M    = {}
local mt    = { __index = _M }
_M._VERSION = "0.0.1"

local ERRORINFO	= require('abtesting.error.errcode').info
local utils = require("abtesting.utils.utils")

local k_version      = 'version'
local k_upstream    = 'upstream'

-- version a.b.c 段数必须小于等于3
local function version_check(version)
    if type(version) == 'string' then 
        local arr = utils.split(version, ".")
        return #arr <= 3
    else
        return false
    end
end

-- version input: 1.2.3
-- return {"1.2.3", "1.2", "1"}
local function extract_version(version)
    if version_check(version) then 
        local arr = utils.split(version, ".")
        if #arr == 3 then 
            return {version, arr[1] .. "." .. arr[2], arr[1]}
        elseif #arr == 2 then 
            return {version, arr[1]}
        end
    end

    return {version}
end

_M.new = function(self, database, policyLib)
    if not database then
        error{ERRORINFO.PARAMETER_NONE, 'need avaliable redis db'}
    end if not policyLib then
        error{ERRORINFO.PARAMETER_NONE, 'need avaliable policy lib'}
    end

    self.database = database
    self.policyLib = policyLib
    return setmetatable(self, mt)
end

--	policy is in format as {{version = '1.0', upstream = '192.132.23.125'}}
_M.check = function(self, policy)
    for _, v in pairs(policy) do
        local version      = v[k_version]
        local upstream  = v[k_upstream]

        if not version or not upstream then
            local info = ERRORINFO.POLICY_INVALID_ERROR 
            local desc = ' need '..k_version..' and '..k_upstream
            return {false, info, desc}
        end
        if not version_check(version) then 
            local info = ERRORINFO.POLICY_INVALID_ERROR 
            local desc = ' version '.. tostring(version)..' is invalid! ok: 1.2.3'
            return {false, info, desc}
        end
    end

    return {true}
end

_M.set = function(self, policy)
    local database  = self.database 
    local policyLib = self.policyLib

    database:init_pipeline()
    for _, v in pairs(policy) do
        local version = v[k_version]
        if not version_check(version) then 
            local err = ' version '..tostring(version)..' is invalid! ok: 1.2.3'
            error{ERRORINFO.POLICY_INVALID_ERROR, err} 
        end

        database:hset(policyLib, version, v[k_upstream])
    end
    local ok, err = database:commit_pipeline()
    if not ok then 
        error{ERRORINFO.REDIS_ERROR, err} 
    end

end

_M.get = function(self)
    local database  = self.database 
    local policyLib = self.policyLib

    local data, err = database:hgetall(policyLib)
    if not data then 
        error{ERRORINFO.REDIS_ERROR, err} 
    end

    return data
end

_M.getUpstream = function(self, version)
    local database	= self.database
    local policyLib = self.policyLib
    
    local versions = extract_version(version)
    for _, version in ipairs(versions) do 
        local upstream, err = database:hget(policyLib , version)
        if not upstream then error{ERRORINFO.REDIS_ERROR, err} end
        
        if upstream ~= ngx.null then
            return upstream
        end
    end
    return nil
end


return _M
