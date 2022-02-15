local M = {}

local request_factory = require('http_client.request')

local function invoke_request(request)
  local return_value = {}
  if request["url"] then
    local result = vim.fn.systemlist("curl "..request["url"])
    for _,result_line in ipairs(result) do
      table.insert(return_value,result_line)
    end
  end
  return return_value;
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
  local request = request_factory.generate_request(lines,current_line)
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
