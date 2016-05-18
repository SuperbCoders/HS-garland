class PricesController
  constructor: (@rootScope, @scope) ->
    vm = @

  modal: (name, action) ->
    # Close all modals
    $('.modal').modal('hide')

    # Open modal
    $('#'+name).modal(action, {backdrop: 'static'})
    return

@application.controller 'PricesController', ['$rootScope', '$scope', PricesController]
