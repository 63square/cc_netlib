local CHANNEL = 65535

local port_table = {}

local function open_port(port)
  if port_table[port] then
    return port_table[port]
  end

  local modem = peripheral.wrap(port)
  if modem == nil then
    return false, nil
  end

  if peripheral.getType(modem) ~= "modem" then
    return false, nil
  end

  if not modem.isOpen(CHANNEL) then
    modem.open(CHANNEL)
  end

  port_table[port] = modem

  return true, port
end

local function close_port(port)
  local modem = peripheral.wrap(port)
  if modem == nil then
    return false
  end

  if peripheral.getType(modem) ~= "modem" then
    return false
  end

  if modem.isOpen(CHANNEL) then
    modem.close(CHANNEL)
  end

  port_table[port] = nil

  return true
end

local function write_data(port, data)
  port_table[port].transmit(CHANNEL, CHANNEL, data)
end

local function read_data()
  while true do
    local _, side, channel, replyChannel, data, _ = os.pullEvent("modem_message")
    if channel == CHANNEL and replyChannel == CHANNEL then
      return side, data
    end
  end
end

return {
  open = open_port,
  close = close_port,
  write = write_data,
  read = read_data
}