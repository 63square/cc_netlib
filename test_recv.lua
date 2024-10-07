local PORT_NAME = "right"

local physical = require("physical")
local ethernet = require("ethernet")

local MAC_ADDRESS = ethernet.address_from_id()
print("Address: "..ethernet.format_address(MAC_ADDRESS))

local ok, port = physical.open(PORT_NAME)
assert(ok, "port is not a modem")

local function array_eq(a, b)
  if #a ~= #b then
    return false
  end

  for i=1, #a do
    if a[i] ~= b[i] then
      return false
    end
  end

  return true
end

while true do
  local recv_port, data = physical.read()

  if recv_port == port then
    local ok, dst, src, type, data = ethernet.parse_frame(data)

    if ok then
      if array_eq(dst, MAC_ADDRESS) or array_eq(dst, {0xFF,0xFF,0xFF,0xFF,0xFF,0xFF}) then
        print("--- START FRAME - "..port.." ---")
        print("Destination Mac: "..ethernet.format_address(dst))
        print("Source Mac: "..ethernet.format_address(src))
        print("Type: "..string.format("%02X%02X", type[1], type[2]))
        print("-- Data --")
        print(string.char(table.unpack(data)))
        print("--- END FRAME ---")
      else
        print("====FRAME TO DIFFERENT HOST====")
      end
    else
      print("====INVAID FRAME : " .. dst .. "====")
    end
  end
end