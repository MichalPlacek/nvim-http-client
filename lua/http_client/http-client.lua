local M = {}

local function invoke_request(request)
  local return_value = {}
  if request["url"] then
    local result = vim.fn.systemlist("curl "..request["url"])
    for k,v in pairs(result) do
      table.insert(return_value,result[k])
    end
  end
  return return_value;
end

local function clean_line(line)
  return line:gsub("^%s+", "")
end

local function is_empty_line(line)
  local cleaned_line = clean_line(line)
  return string.len(cleaned_line) ==0
end

local function find_configs(lines, current_line)
  local found_config = false
  local skip_adding_lines = false
  local config ={}
  local size = table.getn(lines)
  for i = 1, size, 1 do
    local line = lines[i]
    if(is_empty_line(line)) then
      if(found_config) then
        skip_adding_lines = true
      else
        config ={}
      end
    else
      if(not(skip_adding_lines)) then
        table.insert(config,line)
        if(line==current_line) then
          found_config = true
        end
      end
    end
  end
  if(found_config) then
    return config
  else
    return {}
  end
end

local function parse_lines(lines)
  local result = {}
  local size = table.getn(lines)
  for i = 1, size, 1 do
    local line = lines[i]
    local lineElements = {}
    for word in clean_line(line):gmatch("%S+") do table.insert(lineElements, word) end
    if(table.getn(lineElements) == 1 and string.match(string.lower(lineElements[1]),"^http*")) then
      local text = lineElements[1]
      result["url"] = lineElements[1]
    end
  end
  return result
end

local function show_window(lines)
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")
  if(width > 5 and height > 5) then
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    local opts = {
      style = "minimal",
      relative = "editor",
      row = 2,
      col = 2,
      width = width -4,
      height = height -4,
    }
    vim.api.nvim_open_win(buf, true, opts)
  end
end

function M.invoke()
  print(vim.bo.filetype)
      --  print('Hello world!!')
      local i ={};
      local b = vim.api.nvim_get_current_buf()
      local c = vim.api.nvim_get_current_line()
      i.a= vim.bo.filetype
        print()
--  print(i.a)
 -- print(b)
 -- print(c)
  --local lines = vim.api.nvim_buf_get_lines(0,0,vim.api.nvim_buf_line_count(0),1)

local lines = vim.api.nvim_buf_get_lines(0,0,vim.api.nvim_buf_line_count(0),1)
  local current_line = vim.api.nvim_get_current_line()

  local lines = find_configs(lines,current_line)
  local request = parse_lines(lines)
  print("Url:")
  print(request["url"])
  local result = invoke_request(request)
  show_window(result);
  --for l = 1, size, 1 do
  --       print(lines[l])
  --end
 -- ivnokeRequest()
end

return M
