#= require jquery
#= require jquery_ujs
#= require simplemde.min
#= require turbolinks
#= require jquery_ufujs
#= require _analytics

Turbolinks.enableProgressBar()
Turbolinks.enableTransitionCache()

$(document).on 'page:change', ->
  simplemde = new SimpleMDE({ element: document.getElementById('simplemde') })
