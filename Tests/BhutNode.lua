function ReceiveMSG(msg)
	print(string.format("Bhut Message: 0x%x  wParam: 0x%x  lParam: 0x%x",
		msg.message, msg.wParam, msg.lParam));
end
