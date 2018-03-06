-- read  ris files
--

local risparser = {}
risparser.__index = risparser

-- parse lines from a string
local function parse_lines(str)
  return coroutine.wrap(function()
    for line in str:gmatch("([^\r^\n]*)") do
      coroutine.yield(line)
    end
  end)
end

-- parse a file or standard input
local function io_lines(file)
  return coroutine.wrap(function()
    for line in io.lines(file) do
      coroutine.yield(line)
    end
  end)
end

function risparser:parse_file(file)
  local iterator = io_lines(file)
  return self:parse(iterator)
end

function risparser:parse_string(str)
  local iterator = parse_lines(str)
  return self:parse(iterator)
end

function risparser:read_line()
  local iterator = self.iterator
  if iterator then
    return iterator()
  end
end



function risparser:parse(iterator)
  self.records = {}
  self.current = {}

  self.iterator = iterator
  local line = self:read_line()
  while line do
    self:process_line(line)
    line = self:read_line()
  end
  self:process_record()
end

function risparser:process_line(line)
  if line:match("^%s*$") then
    self:process_record()
    return nil
  end
  local current = self.current
  local tag, value = line:match("^%s*([^%s]+)%s*%-%s*(.+)")
  if tag then
    local tagtable = current[tag] or {}
    table.insert(tagtable, value)
    current[tag] = tagtable
  end
end

function risparser:process_record()
  table.insert(self.records, self.current)
  self.current = {}
end

function risparser.new()
  local t = setmetatable({}, risparser)
  return t
end

local test = risparser.new()
test:parse_file()

local keywords = {}
for k, v in ipairs(test.records) do
  for _, kw in ipairs(v.KW or {}) do
    local current = keywords[kw] or {}
    table.insert(current, k)
    keywords[kw] = current
    print(kw)
  end
end

for kw, records in pairs(keywords) do
end

