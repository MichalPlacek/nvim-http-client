local M = {}

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
  for _,line in ipairs(lines) do
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
  for _,line in ipairs(lines) do
    local lineElements = {}
    for word in clean_line(line):gmatch("%S+") do table.insert(lineElements, word) end
    if(table.getn(lineElements) == 1 and string.match(string.lower(lineElements[1]),"^http*")) then
      result["url"] = lineElements[1]
    end
  end
  return result
end

function M.generate_request(lines,current_line)
  return parse_lines(find_configs(lines,current_line))
end


return M
