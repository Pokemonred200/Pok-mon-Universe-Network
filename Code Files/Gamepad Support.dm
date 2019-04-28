/*

	How to use:
		1) Listen on GamepadConnected(gamepadId) or GamepadDisconnected(gamepadId) for gamepad availability updates, or access the client.gamepads list
		2) Select the desired gamepad and pass it through client.SetDefaultGamepad()
	Known Concerns:
		Chrome has the WORST support for x-input-based controllers, so use Firefox as an alternative.
		Press a button on the controller to activate it.

*/

#ifndef GAMEPAD_ID
#define GAMEPAD_ID "gamepad_window"
#endif

client

	var gamepads[0]
	var buttons[0]
	var abuttons[0]
	var axes[0]
	var autosetGamepad = FALSE

	Topic(href, href_list[], gamepadUpdate/hsrc)

		switch(href_list["action"])

			if("gamepad")

				var id = url_decode(href_list["id"])

				if(id)

					if(text2num(href_list["state"])||(href_list["state"]=="true"))

						src.gamepads += id
						src.GamepadConnected(id)

					else

						src.gamepads -= id
						src.GamepadDisconnected(id)

			if("update_gamepads")

				if(href_list.len >= 2)

					var newGamepads = href_list.Copy(2)

					for(var/foo in newGamepads)
						foo = url_decode(foo)

					src.gamepads		= newGamepads
					var difference[]	= newGamepads ^ src.gamepads

					for(var/bar in difference)

						if(bar in src.gamepads)	src.GamepadConnected(bar)
						else					src.GamepadDisconnected(bar)

			else
				return ..()

	proc

		// Events:
		GamepadConnected(gamepadId)
			if(autosetGamepad)
				SetDefaultGamepad(gamepadId)
		GamepadDisconnected(/* gamepadId */)

		DownedButton(button)
		ReleasedButton(button)

		// Omit gamepadId to turn it off.
		SetDefaultGamepad(gamepadId)
			src << output(list("SetDefaultGamepad", "[gamepadId]"), "gamepad_window")

		// Call this for Chrome please.
		UpdateGamepads()
			src << output(list("UpdateGamepads"), "gamepad_window")

	verb

		UpdateAxis(axis as num,value as num)
			set hidden = 1
			set instant = 1
			src.axes["[axis]"] = value
		UpdateAnaButton(button as num,value as num)
			set hidden = 1
			set instant = 1
			src.abuttons["[button]"] = value

		UpdateButton(button as num, state as num)

			set hidden	= 1
			set instant	= 1

			if(state)
				src.buttons["[button]"] = 1
				src.DownedButton(button)
			else
				src.buttons["[button]"] = 0
				src.ReleasedButton(button)