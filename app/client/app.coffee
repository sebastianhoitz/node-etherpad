# Client-side Code

# Bind to socket events
SS.socket.on 'disconnect', ->  $('#message').text('SocketStream server is down :-(')
SS.socket.on 'reconnect', ->   $('#message').text('SocketStream server is up :-)')

# This method is called automatically when the websocket connection is established. Do not rename/delete
exports.init = ->

  # Make a call to the server to retrieve a message
  SS.server.app.init (response) ->
		$("textarea").keyup (e) ->
			SS.server.app.sendCurrentText $("textarea").val()


  ### START QUICK CHAT DEMO ####
	
	SS.events.on "sendCurrentText", (text) ->
		console.log(text)
		currentSelection = getSelection($("textarea"))
		$("textarea").val(text)
		setSelection($("textarea"), currentSelection)

  # Listen for new messages and append them to the screen
  SS.events.on 'newMessage', (message) ->
    $("<p>#{message}</p>").hide().appendTo('#chatlog').slideDown()
	
getSelection = (el) ->
	el = el[0]
	if el.selectionStart
		return el.selectionStart

	else if document.selection
		el.focus()

		r = document.selection.createRange()
		if r == null
			return 0

		re = el.createTextRange()
		rc = re.duplicate()
		re.moveToBookmark(r.getBookmark())
		rc.setEndPoint('EndToStart', re)

		return rc.text.length

	return 0

setSelection = (el, position) ->
	el = el[0]
	if (el.setSelectionRange)
    el.focus()
    el.setSelectionRange(position, position)

  else if (el.createTextRange)
    range = el.createTextRange()
    range.collapse(true)
    range.moveEnd('character', position)
    range.moveStart('character', position)
    range.select()
