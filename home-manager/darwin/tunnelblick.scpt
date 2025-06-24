try
	set ykPasswordDialog to display dialog "Yubikey OATH password" default answer "" buttons {"Cancel", "OK"} default button "OK" with hidden answer
	set vpnPassword to do shell script "ykman oath accounts code -s emarsys-vpn -p " & (text returned of the ykPasswordDialog)

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

on error errStr number errorNumber
	display notification errStr with title "Error connecting"
end try
