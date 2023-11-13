if vim.fn.has("windows") then
    require("config.os.windows")
end

if vim.fn.has("unix") then
    require("config.os.linux")
end
