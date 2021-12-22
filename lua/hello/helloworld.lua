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
  local lines = vim.api.nvim_buf_get_lines(0,0,vim.api.nvim_buf_line_count(0),1)
  print(lines);
  local size = table.getn(lines)
  print(size);
  for l = 1, size, 1 do
 --        print(lines[l])
  end
  getCurrentLine()
  ivnokeRequest()
end

return M
