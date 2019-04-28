/* Rai (Cart12) */

player
	var {tmp/ContinueText = FALSE}
	verb
		Continue(){set hidden = 1; src.ContinueText = 3; return}
	proc
		ShowText(Text,Color/C=new,bold=FALSE)
			set background = 1;
			if(src.ContinueText){return}; winset(src,"Background","is-visible=true"); winset(src,"Screen Text","is-visible=true")
			var Label/X = new(src,"default","Screen Text")
			X.TextColor(C)
			if(bold)
				winset(src,"default.Screen Text",list2params(list("font-style"="bold")))
			else
				winset(src,"default.Screen Text",list2params(list("font-style"="")))
			while(Text)
				var TextCopy = null
				TextCopy = Text ; Text = null
				src.ContinueText = 1; var TextCounter = 1
				while(src.ContinueText <= 2)
					var textSpeed = (src.client.keys["tab"])?((src.client.keys["shift"])?(16):(8)):(4)
					if(src.ContinueText == 1)
						var TextDisplay
						for(var/I = 1, I <= length(TextCopy), I += textSpeed){TextDisplay += copytext(TextCopy, I, I + textSpeed); src << output("[TextDisplay]", "Screen Text"); sleep(1)}
						src.ContinueText = 2; winset(src,"Continue","is-visible=true")
					if(src.ContinueText == 2){TextCounter += 1}
					sleep(2)
			src.ContinueText = 0; src.Interface(0, "Screen Text"); return
		ShowTextInstant(Text,Color/C=new,bold=FALSE)
			set background = 1
			if(src.ContinueText){return}; winset(src,"Background","is-visible=true"); winset(src,"Screen Text","is-visible=true")
			var Label/X = new(src,"default","Screen Text")
			X.TextColor(C)
			if(bold)
				winset(src,"default.Screen Text",list2params(list("font-style"="bold")))
			else
				winset(src,"default.Screen Text",list2params(list("font-style"="")))
			X.Text(Text)
			src.ContinueText = 2
			winset(src,"Continue","is-visible=true")
			while(src.ContinueText == 2)sleep TICK_LAG
			src.ContinueText = 0;src.Interface(0,"Screen Text")