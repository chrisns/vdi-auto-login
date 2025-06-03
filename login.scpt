on enterPasswordIntoVDI()
	set opPassword to do shell script "/opt/homebrew/bin/op item get \"Okta-emea GDS\" --fields password --reveal"
	
	
	tell application "Omnissa Horizon Client"
		activate
	end tell
	delay 0.2
	
	tell application "System Events"
		tell process "Omnissa Horizon Client"
			set frontmost to true
			repeat until (enabled of menu item "Log Off" of menu "Connection" of menu bar 1)
				delay 0.5 -- half-second pause before checking again
			end repeat
			delay 0.5
			keystroke return
			delay 0.5
			set textLength to length of opPassword
			repeat with i from 1 to textLength
				set currentChar to character i of opPassword
				if currentChar is in "0123456789" then
					if currentChar = "0" then set keyCode to 29
					if currentChar = "1" then set keyCode to 18
					if currentChar = "2" then set keyCode to 19
					if currentChar = "3" then set keyCode to 20
					if currentChar = "4" then set keyCode to 21
					if currentChar = "5" then set keyCode to 23
					if currentChar = "6" then set keyCode to 22
					if currentChar = "7" then set keyCode to 26
					if currentChar = "8" then set keyCode to 28
					if currentChar = "9" then set keyCode to 25
					
					key down keyCode
					delay 0.2
					key up keyCode
					
				else
					keystroke currentChar
				end if
				delay 0.1 -- half-second pause between each keystroke
			end repeat
			
			delay 2
			
			keystroke return
		end tell
	end tell
end enterPasswordIntoVDI


on startBrowserAuth()
	
	tell application "System Events"
		tell process "Omnissa Horizon Client"
			set frontmost to true
			
			repeat until exists button "Sign in via Browser" of window 1
				delay 0.1
			end repeat
			click button "Sign in via Browser" of window 1
		end tell
	end tell
	
	delay 2
	
	set opUsername to do shell script "/opt/homebrew/bin/op item get \"Okta-emea GDS\" --fields username"
	set opOTP to do shell script "/opt/homebrew/bin/op item get \"Okta-emea GDS\" --otp"
	
	tell application "Google Chrome" to tell active tab of window 1
		execute javascript "document.getElementById('loginButton').click()"
		delay 1
		-- if horizon needs a login, do that, but it might already be authed
		if (execute javascript "document.getElementById('launched-title').textContent.includes('Horizon Client Launched')") then
			log "looks like browser already authed"
		else
			execute javascript "document.querySelector('input[name=\"identifier\"]').value = '" & opUsername & "'"
			execute javascript "document.querySelector('input[name=\"identifier\"]').dispatchEvent(new Event('input', { bubbles: true }))"
			execute javascript "document.querySelector('input[value=\"Next\"]').click();"
			
			delay 1
			
			execute javascript "document.querySelector('input[name=\"credentials.passcode\"]').value = '" & opOTP & "'"
			execute javascript "document.querySelector('input[name=\"credentials.passcode\"]').dispatchEvent(new Event('input', { bubbles: true }))"
			execute javascript "document.querySelector('input[value=\"Verify\"]').click();"
		end if
	end tell
	
	my enterPasswordIntoVDI()
end startBrowserAuth

tell application "Omnissa Horizon Client"
	activate
end tell

tell application "System Events"
	tell application process "Omnissa Horizon Client"
		set frontmost to true
		try
			if (enabled of menu item "Log Off" of menu "Connection" of menu bar 1) then
				log "logged in to VDI, just needs a password to unlock"
				my enterPasswordIntoVDI()
				
			else
				log "login started but not ready yet"
			end if
		on error
			log "not logged in, sort that out first"
			my startBrowserAuth()
		end try
	end tell
end tell


