local CHANNEL = 65535

local port_table = {}

local function open_port(name)
  local modem = peripheral.wrap(name)
  if modem == nil then
    return false, nil
  end

  if peripheral.getType(modem) ~= "modem" then
    return false, nil
  end

  if not modem.isOpen(CHANNEL) then
    modem.open(CHANNEL)
  end

  port_table[name] = modem

  return true, modem
end

local function close_port(name)
  local modem = peripheral.wrap(name)
  if modem == nil then
    return false
  end

  if peripheral.getType(modem) ~= "modem" then
    return false
  end

  if modem.isOpen(CHANNEL) then
    modem.close(CHANNEL)
  end

  port_table[name] = nil

  return true
end

local function write_data(port, data)
  port.transmit(CHANNEL, CHANNEL, string.char(table.unpack(data)))
end

local function read_data()
  while true do
    local _, side, channel, replyChannel, data, _ = os.pullEvent("modem_message")
    if channel == CHANNEL and replyChannel == CHANNEL then
      return port_table[side], data
    end
  end
end

return {
  open = open_port,
  close = close_port,
  write = write_data,
  read = read_data
}