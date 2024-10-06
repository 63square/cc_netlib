local physical = require("physical")
local link = require("link")

local _, port = physical.open("left")

local data = {}
local message = "Hello, world!"
for i=1, #message do
  data[i] = string.byte(string.sub(message, i, i+1))
end

link.send_frame(port, link.parse_address("FF:FF:FF:FF:FF:FF"), link.parse_address("AA:BB:CC:DD:EE:FF"), {6,3}, data)