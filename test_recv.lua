local PORT_NAME = "right"

local physical = require("physical")
local ethernet = require("ethernet")

local ok, port = physical.open(PORT_NAME)
assert(ok, "port is not a modem")

while true do
  local recv_port, data = physical.read()

  if recv_port == port then
    local ok, dst, src, type, data = ethernet.parse_frame(data)

    if ok then
      print("--- START FRAME - "..port.." ---")
      print("Destination Mac: "..ethernet.format_address(dst))
      print("Source Mac: "..ethernet.format_address(src))
      print("Type: "..string.format("%02X%02X", type[1], type[2]))
      print("-- Data --")
      print(string.char(table.unpack(data)))
      print("--- END FRAME ---")
    else
      print("====INVAID FRAME : " .. dst .. "====")
    end
  end
end