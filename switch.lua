local physical = require("physical")
local ethernet = require("ethernet")

local arp_table = {}

print("---- SWITCH STARTED ----")

local ports = {}
for _, port in ipairs({"bottom", "top", "left", "right", "front", "back"}) do
  local ok, p = physical.open(port)
  if ok then
    ports[p] = port
    print("# Opened port "..p)
  end
end

local function update_arp_tbl(port, address)
  if not arp_table[address] then
    arp_table[address] = { port }
    return
  end

  for _, p in ipairs(arp_table[address]) do
    if p == port then
      return
    end
  end

  table.insert(arp_table[address], port)
end

while true do
  local recv_port, data = physical.read()

  local ok, dst, src, _, _ = ethernet.parse_frame(data)

  if ok then
    local dst_int = ethernet.address_to_int(dst)
    local src_int = ethernet.address_to_int(src)

    update_arp_tbl(recv_port, src_int)

    if dst_int == 0xFFFFFFFFFFFF then
      for port, _ in pairs(ports) do
        if port ~= recv_port then
          physical.write(port, data)
        end
      end
      print("[BRDC] Broadcasted frame from port "..recv_port)
    else
      if arp_table[dst_int] then
        for _, port in ipairs(arp_table[dst_int]) do
          if port ~= recv_port then
            physical.write(port, data)
          end
        end
        print("[FWRD] Forwarded frame from "..recv_port)
      else
        for port, _ in pairs(ports) do
          if port ~= recv_port then
            physical.write(port, data)
          end
        end
        print("[FLOOD] Flooded frame from "..recv_port)
      end
    end
  else
    print("[DROP] Invalid frame from port "..recv_port)
  end
end