class OrdersController
  constructor: (@rootScope, @scope, @log, @Orders, @http) ->
    vm = @

    @log.info 'OrdersController'
    @fetch()

  save: (order) ->
    alert(order.status)
    order.$save({id: order.id})
  fetch: ->
    vm = @
    vm.http.get('/admin/orders/statuses').then((statuses) ->
      vm.order_statuses = statuses.data
    )

    @Orders.query({}).$promise.then((orders) ->
      vm.orders = orders
    )
@application.controller 'OrdersController', ['$rootScope', '$scope', '$log', 'Orders', '$http', OrdersController]
