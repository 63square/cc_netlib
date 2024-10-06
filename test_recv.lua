local physical = require("physical")
local link = require("link")

local _, port = physical.open("right")

local source_port, dst, src, type, data = link.recv_frame()

print("--- START FRAME - "..peripheral.getName(source_port).." ---")
print("Destination Mac: "..link.format_address(dst))
print("Source Mac: "..link.format_address(src))
print("Type: "..string.format("%02X%02X", type[1], type[2]))
print("-- Data --")
print(string.char(table.unpack(data)))
print("--- END FRAME ---")