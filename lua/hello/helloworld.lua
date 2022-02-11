local M = {}

local function getCurrentLine()
      local dirtyLine = vim.api.nvim_get_current_line()
      local cleanLine = dirtyLine:gsub("^%s+", "")

      local lineElements = {}
      for word in cleanLine:gmatch("%S+") do table.insert(lineElements, word) end
      print(lineElements)
end

local function ivnokeRequest()
 local result = vim.fn.systemlist('curl onet.pl')

  -- with small indentation results will look better
  for k,v in pairs(result) do
          print(result[k])
  end
end

local function clean_line(line)
  return line:gsub("^%s+", "")
end

local function is_empty_line(line)
  local clean_line = clean_line(line)
  return string.len(clean_line) ==0
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
    if(table.getn(lineElements) == 1) then
      result["url"] = lineElements[1]
    end
  end
  return result
end

function M.sayHelloWorld()
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
  local size = table.getn(lines)
  print(size);
  for l = 1, size, 1 do
         print(lines[l])
  end
  -- getCurrentLine()
 -- ivnokeRequest()
end

return M
