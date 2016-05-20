class OrdersController
  constructor: (@rootScope, @scope, @log, @Orders) ->
    vm = @

    @log.info 'OrdersController'
    @fetch()

  fetch: ->
    vm = @
    @Orders.query({}).$promise.then((orders) ->
      vm.orders = orders
    )
@application.controller 'OrdersController', ['$rootScope', '$scope', '$log', 'Orders', OrdersController]
