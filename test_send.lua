local PORT_NAME = "left"
local DST_ADDR = "FF:FF:FF:FF:FF:FF"
local SRC_ADDR = "AA:BB:CC:DD:EE:FF"

local physical = require("physical")
local ethernet = require("ethernet")

local ok, port = physical.open(PORT_NAME)
assert(ok, "port is not a modem")

local function string_to_byte(str)
  local data = {}
  for i=1, #str do
    data[i] = string.byte(string.sub(str, i, i+1))
  end
  return data
end

local frame = ethernet.new_frame(ethernet.parse_address(DST_ADDR), ethernet.parse_address(SRC_ADDR), {6,3}, string_to_byte("Hello, World!"))

physical.write(port, frame)