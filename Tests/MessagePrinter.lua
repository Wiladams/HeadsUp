require "BanateCore"

class.MessagePrinter()

function MessagePrinter:_init()
end

function MessagePrinter:Receive(msg)
	print(string.format("Message: 0x%x  wParam: 0x%x  lParam: 0x%x",
		msg.message, msg.wParam, msg.lParam));
end

