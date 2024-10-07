local PORT_NAME = "left"

local physical = require("physical")
local ethernet = require("ethernet")

local MAC_ADDRESS = ethernet.address_from_id()
print("Address: "..ethernet.format_address(MAC_ADDRESS))

local ok, port = physical.open(PORT_NAME)
assert(ok, "port is not a modem")

local function string_to_byte(str)
  local data = {}
  for i=1, #str do
    data[i] = string.byte(string.sub(str, i, i+1))
  end
  return data
end

write("Destination Address: ")
local destination = read()

write("Message: ")
local message = read()

local frame = ethernet.new_frame(ethernet.parse_address(destination), MAC_ADDRESS, {6,3}, string_to_byte(message))

physical.write(port, frame)