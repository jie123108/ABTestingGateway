--[[
供config.lua使用的代码，不能包含任何其它lua文件中的代码。
]]

local _M = {}

local function filter(k, v)
    if k == 'password' then 
        return k, "***"
    else 
        return k, v 
    end
end

local function table_to_string(t, seq)
    if seq == nil then
        seq = ","
    end
    if type(t) ~= 'table' then
        return tostring(t)
    end
    local l = {}
    for k,v in pairs(t) do
        k, v = filter(k, v)
        if type(v) == 'table' then
            v = "{" .. table_to_string(v) .. "}"
        elseif type(v) == 'string' then
            v = "'" .. v .. "'"
        end
        if type(k) == 'number' then
            table.insert(l, v)
        else
            table.insert(l, k .. "=" .. tostring(v))
        end
    end
    return "{" .. table.concat(l, seq) .. "}"
end

local ignores = {aes_key=true, aes_iv=true, AWSAccessKeyId=true, AWSSecretAccessKey=true}
function _M.config_to_string(config)
    local configlist = {}
    for k, v in pairs(config) do 
        if type(v) == "table" then
            v = table_to_string(v, ",")
        elseif type(v) == 'string' then
            v = "'" .. v .. "'"
        end
        if type(v) ~= "function" and not ignores[k] then
            table.insert(configlist, "config." .. k .. "=" .. tostring(v))
        end
    end
    return table.concat(configlist, "\n")
end

-- 递归合并两个table
function _M.table_marge_recursive(to, from)
    for field, from_value in pairs(from) do 
        local v_type = type(from_value)
        local to_value = to[field]
        local tv_type = type(to_value)
        if v_type == 'table' and v_type == tv_type then 
            from_value = _M.table_marge_recursive(to_value, from_value)
        end
        if from_value == 'nil' then 
            from_value = nil
        end
        to[field] = from_value
        if type(from_value) == 'table' then
            from_value = table_to_string(from_value, ',')
        end
        ngx.log(ngx.WARN, "config.",field, " set to [",tostring(from_value), "]") 
    end
    return to
end

local function init_from_ext_config(config, ext_config_file)
    ngx.log(ngx.WARN, "--- ext_config_file:", tostring(ext_config_file))
    local ok, ext_config = pcall(require, ext_config_file)
    if not ok then
        ngx.log(ngx.WARN, "# require 'ext_config failed! ", ext_config)
        return
    end
    if ext_config then       
        local NIL = 'nil'
        if type(ext_config) == 'table' then
            _M.table_marge_recursive(config, ext_config)            
        end 
    end -- if ext_config then
end


function _M.init_from_ext_config(config)
    package.path = '/opt/lua_cfg/?.lua;' .. package.path

    local ext_config = config.ext_config or 'abtesting_ext'
    if type(ext_config) == 'string' then 
        ext_config = {ext_config}
    end
    
    if type(ext_config) == 'table' then
        for _, ext_config_file in ipairs(ext_config) do 
            init_from_ext_config(config, ext_config_file)
        end
    end
end

return _M