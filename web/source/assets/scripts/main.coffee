randomInt = (min, max) ->
  Math.floor(Math.random() * (max - min + 1)) + min

socket = io.connect('http://localhost:8000');

socket.on 'scarceMineralCollected', (data) -> 
  console.log("SCARCE");
  $('span.scarce-mineral').html(JSON.stringify(data))

socket.on 'commonMineralCollected', (data) -> 
  console.log("COMMON");
  $('span.common-mineral').html(JSON.stringify(data))

socket.on 'updateGame', (data) ->
  json = data
  console.log("===> ", json)
  # $('h1').css({ top: data["player1"].y, left: data["player1"].x })
  $('span.game').html(
    "isOver: " + JSON.stringify(json["isOver"]) +
    ", didWin: " + JSON.stringify(json["didWin"])
  )

  $('span.asteroid').html(JSON.stringify(json["asteroid"]))

  $('span.player1').html(JSON.stringify(json["players"]["player1"]))
  $('span.player2').html(JSON.stringify(json["players"]["player2"]))
  $('span.player3').html(JSON.stringify(json["players"]["player3"]))
  $('span.player4').html(JSON.stringify(json["players"]["player4"]))

$('button.click-me').on 'click', ->
  socket.emit('drill', {
    'playerID': ("player" + randomInt(1, 4)),
    'drillPower': randomInt(0, 1000)
  })

$('button.start').on 'click', ->
  socket.emit('start')

$('button.time-up').on 'click', -> 
  socket.emit('timeUp')

window.socket = socket

jQuery ($) ->
  $screens = $('.screen')
  len = $screens.length
  delay = 2000
  x = 0
  callback = () ->
    x = x + 1
    roll()
  roll = () ->
    delay = $screens.eq(x).data('delay') or delay
    $screens.css( opacity: 0 ).delay(1000).eq(x).css( opacity: 1 )
    if((x + 1)  >= len)
      return
    setTimeout(callback, delay)
  roll()
