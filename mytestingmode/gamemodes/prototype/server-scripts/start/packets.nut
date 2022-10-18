enum PacketId
{
	CALL = 127
}

local serverReceivers = {}

function registerServerFunc(funcId, func)
{
	serverReceivers[funcId] <- func
}

function callClientFunc(pid, funcName, ...)
{
	print("Send packet")
	print(PacketId.CALL)
	
	local packet = Packet()
	
	packet.writeUInt8(PacketId.CALL)
	packet.writeString(funcName)
	packet.writeUInt8(vargv.len())

	foreach(val in vargv)
	{
		switch (typeof(val))
		{
		case "null":
			packet.writeInt8('n')
			break

		case "bool":
			packet.writeInt8('b')
			packet.writeBool(val)
			break

		case "integer":
			packet.writeInt8('i')
			packet.writeInt32(val)
			break

		case "float":
			packet.writeInt8('f')
			packet.writeFloat(val)
			break

		case "string":
			packet.writeInt8('s')
			packet.writeString(val)
			break
		}
	}

	packet.send(pid, RELIABLE_ORDERED)
}

addEventHandler("onPacket", function(pid, packet)
{
	local id = packet.readUInt8()
	
	if (id == PacketId.CALL)
	{
		print("callServerFunc reveiver")
	
		local funcId = packet.readString()
		local len = packet.readUInt8()

		local func = serverReceivers[funcId]
		local args = [this]

		if (!(funcId in serverReceivers))
			return

		for (local i = 0; i < len; ++i)
		{
			switch (packet.readInt8())
			{
			case 'n':
				args.push(null)
				break

			case 'b':
				args.push(packet.readBool())
				break

			case 'i':
				args.push(packet.readInt32())
				break

			case 'f':
				args.push(packet.readFloat())
				break

			case 's':
				args.push(packet.readString())
				break
			}
		}

		func.acall(args)
	}
})
