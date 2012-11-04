$ ->
  #this attaches to all pjax container
  $('select').chosen()
  $('.pjax a').pjax('[data-pjax-container]')
  #$('p a').pjax('[data-pjax-content]')
  $('.test a').pjax('[data-pjax-container]')


  $('html').on
    click: ->
      console.log $(this).parent().next()
      console.log $(this).parent().next().attr('class')
      if $(this).parent().next().attr('class') == "toggle"
        $(this).parent().next().toggle()
  , ".triangle"

  # $("html").pjax(".test a").on "pjax:success", (data, xhr, response) ->
  #   $.pjax
  #     url: $('.test a').val
  #     container: 'data-pjax-flash'

