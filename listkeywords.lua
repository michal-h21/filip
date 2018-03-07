local risparser = require "risparser"
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

