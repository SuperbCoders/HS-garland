class OtherController
  constructor: (@rootScope, @scope) ->
    vm1 = @


#    @log.info 'OtherController'

    $html = $('html')
    mobMenu = $('.mobMenuBtn')

    mobMenu.on 'click', ->
      $html.toggleClass 'open_menu'
      false


    @rootScope.$on '$stateChangeStart', () ->
      $('html').removeClass 'open_menu'

@application.controller 'OtherController', ['$rootScope', '$scope', OtherController]