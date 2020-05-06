-- list keyword pairs used in one record by frequence
local risparser = require "risparser"
local argparse  = require "argparse"()

argparse:name("bigram"):description("Tiskne bigram klíčových slov s jejich frekvencí")
argparse:argument("input"):args("?"):description("Vstupní RIS soubor (použije se standardní vstup při jeho absenci)")
argparse:option "-t" "--threshold":description("Práh pro výpis frekvence")
argparse:flag "-d" "--dot":description("Vypsat graf pro GraphViz")

argparse:option "-i" "--ignore":description("Ignorované klíčové slovo")

local args = argparse:parse()

risparser:parse_file(args.input)
local threshold = tonumber(args.threshold) or 4
local ignored_keyword = args.ignore or ""

local graph_format = "%s\t%s\t%s\t%f"
local start_graph  
local end_graph  
if args.dot then
  start_graph = "graph keywords {"
  end_graph = "}"
  graph_format = '"%s" -- "%s" [label="%s"];'
end

local graph = {}

local records = risparser:get_records()
local number_of_records = #records

-- count keyword pair frequency
for _, rec in ipairs(records) do
  local keywords = rec.KW or {}
  for _, kw in ipairs(keywords) do
    -- get table with related keywords for the current keyword
    local current = graph[kw] or {}
    -- save keywords from the current record
    for _, related in ipairs(keywords) do
      -- skip the current keyword
      -- skip ignored keywords
      if related ~= kw and ignored_keyword ~= related and kw ~= ignored_keyword  then
        -- skip if the related keyword had been already used as main keyword
        local used_keywords = graph[related] or {}
        if not used_keywords[keyword] then
          local count = current[related] or 0
          count = count + 1
          current[related] = count
        end
      end
    end
    graph[kw] = current
  end
end


if start_graph then print(start_graph) end

-- print the frequency
local used = {}
for keyword, pair in pairs(graph) do
  for name, frequency in pairs(pair) do
    if frequency > threshold then
      -- we must disable double printing
      local kn = keyword .. name
      local nk = name .. keyword
      used[nk] = true
      if not used[kn] then
        print(string.format(graph_format, keyword, name, frequency, (frequency/number_of_records)*100))
      end
    end
  end
end

if end_graph then print(end_graph) end
