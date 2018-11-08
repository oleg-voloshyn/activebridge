#= require _analytics
#= require _smartlook

if navigator.appVersion.toUpperCase().indexOf('MSIE') != -1 or
    navigator.appVersion.toUpperCase().indexOf('TRIDENT') != -1 or
      navigator.appVersion.toUpperCase().indexOf('EDGE') != -1

  document.querySelector('html').classList.add('ie')

ajax = (method, href, async = true) ->
  xhr = new XMLHttpRequest()
  xhr.open(method, href, async)
  xhr.setRequestHeader('Accept', 'text/javascript')
  return xhr

currentEl = 0
prevEl = 0
header = document.getElementById('header')
hire_us_container = document.getElementById('hire_us_container')
transformTetris = (first, second, third, fourth, fifth, lower) ->
  first.style.transform = 'rotate(90deg)'
  second.style.transform = 'translate(56.6%, 167%)'
  second.style.MozTransform = 'translate(55.5%, 159%)'
  third.style.transform = 'rotate(180deg) translate(-56.5%, 77.5%)'
  fourth.style.transform = 'rotate(90deg) translate(17.5%, -81%)'
  fourth.style.MozTransform = 'rotate(90deg) translate(17.5%, -78%)'
  fifth.style.transform = 'rotate(90deg) translate(32%, 217.5%)'
  fifth.style.MozTransform = 'rotate(90deg) translate(32%, 201%)'
  lower.style.visibility = 'visible'
  lower.style.transform = 'translateY(150%) translateX(-7%)'
    

toggleHeader = () ->
  prevEl = currentEl
  currentEl = window.pageYOffset
  if ( currentEl > prevEl )
    header.style.cssText = 'opacity: 1; z-index: 4'
    hire_us_container.style.cssText = 'opacity: 1; z-index: 3'
  else
    header.style.cssText = 'opacity: 0'
    hire_us_container.style.cssText = 'opacity: 0'
  if ((currentEl/document.documentElement.clientHeight * 100) > 160 )
    first = document.getElementById('first_lower')
    second = document.getElementById('second_lower')
    third = document.getElementById('third_lower')
    fourth = document.getElementById('fourth_lower')
    fifth = document.getElementById('fifth_lower')
    lower = document.getElementById('lower')
    transformTetris(first, second, third, fourth, fifth, lower)

window.submit = (form) ->
  document.getElementById('submit').disabled = true
  xhr = ajax('POST', form.action)
  xhr.onreadystatechange = ->
    return if xhr.readyState != 4
    if xhr.status == 200
      form = document.getElementById('contact_form')
      form.reset()
    else
      document.getElementById('submit').disabled = false

  data = new FormData(document.querySelector('form'))
  xhr.send(data)
  dataLayer.push({'event':'formSubmitted', 'formName':'ContactUs'})
  document.getElementById('toggle-envelop-checkbox').checked = false
  document.getElementById('envelop_success_message').style.opacity = '0.8'
  setTimeout ->
    closeWindow()
  , 3500
  return false

window.animate = -> document.getElementById('ab').checked = true
window.onload = -> openEnvelope(this.location.pathname)

closeWindow = ->
  document.querySelector('#lazy_overlay').className = ''
  document.body.className = 'index'
  history.pushState({}, null, '/')

openPage = (event) ->
  document.getElementById('lazy_overlay').className = 'active'
  document.getElementById('lazybox').className = 'hidden'
  href = this.href.baseVal || this.href
  xhr = ajax('GET', href)
  xhr.onload = ->
    if (xhr.readyState == 4 && xhr.status == 200)
      document.body.className = href
      eval(xhr.responseText)
      focus()
      initTeamScroll()
      openEnvelope(href)
  xhr.send()
  dataLayer.push({
    'event':'VirtualPageview',
    'virtualPageURL': href,
    'virtualPageTitle' : href
  })

  event.preventDefault()

openEnvelope = (href) ->
  return unless href.indexOf('contact') != -1
  setTimeout "document.querySelector('#toggle-envelop-checkbox').checked = true", 2500

initTeamScroll = ->
  if document.querySelector('.members')
    document.querySelector('.members').addEventListener('mousewheel', scrollTeam, false)
    document.querySelector('.members').addEventListener('DOMMouseScroll', scrollTeam, false)

scrollTeam = (event) ->
  event = window.event || event
  delta = Math.max(-1, Math.min(1, (event.wheelDelta || -event.detail)))
  rotateTeam(delta)

rotateTeam = (direction) ->
  currentRotate = document.querySelector('#rotate-shape').style.transform.split('(')[1]
  angle = parseInt(currentRotate) + 2*direction
  document.querySelector('#rotate-shape').style.transform = 'rotateY(' + angle + 'deg)'


browseTeam = (keyCode) ->
  switch keyCode
    when 37 then direction = -1
    when 39 then direction = 1
    when 27 then document.getElementById('lazy_close').click()
    else return
  rotateTeam(direction)

browseData = (event) ->
  if spinShape = document.querySelector('.members')
    browseTeam(event.keyCode)
  else if event.keyCode == 27
    document.getElementById('lazy_close').click()

isRootPage = ->
  location.pathname == '/'

startLazyBodyTransition = ->
  if isRootPage()
    document.getElementById('lazybox').className = ''
    document.getElementById('lazy_body').style.opacity = 0

clearLazyBodyContent = ->
  document.getElementById('lazy_body').innerHTML = '' if isRootPage()

document.body.onscroll = (toggleHeader)
document.addEventListener('keydown', browseData, false)
initTeamScroll()

window.onpopstate = ->
  closeWindow() if isRootPage()

focus = ->
  controls = document.querySelectorAll("input[type='radio']")
  return unless controls[0]
  input.addEventListener('keydown', (e) ->
    @.focus()
    e.preventDefault() if (e.which == 9)) for input in controls
focus()

@keepFocus = (input) ->
  setTimeout ->
    return if document.querySelector('input[type="radio"]:checked') != input
    input.focus()
  , 10
