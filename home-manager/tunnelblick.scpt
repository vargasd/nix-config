set vpnPassword to do shell script "pass otp emarsys-vpn"

tell application "Tunnelblick"
		get configurations
		connect "emarsys-remote-access"
end tell

tell application "System Events"
tell process "Tunnelblick"
		set frontmost to true
		tell window 1
				set value of text field 1 to "svarga"
				set value of text field 3 to vpnPassword
				click button "OK"
		end tell
end tell
end tell
