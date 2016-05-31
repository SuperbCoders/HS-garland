class OrderModalController
  constructor: (@scope, @uibModalInstance, @http) ->
    console.log 'OrderModalController'
    vm = @
    vm.order = @scope.order
    vm.order_statuses = @scope.order_statuses

    vm.http.get('/admin/garland_prices').then((response) -> vm.garland_prices = response.data)
    vm.http.get('/admin/lamp_prices').then((response) -> vm.lamp_prices = response.data)

  save: ->
    vm = @
    vm.uibModalInstance.close vm.order
    return

  cancel: ->
    vm = @
    vm.uibModalInstance.dismiss 'cancel'
    return

@application.controller 'OrderModalController', ['$scope', '$uibModalInstance', '$http', OrderModalController]


class OrdersController
  constructor: (@rootScope, @scope, @log, @Orders, @http, @filter, @uibModal) ->
    vm = @
    vm.filters =
      rent: 'undefined'
    vm.date_filter =
      date_from_opened: false
      date_to_opened: false
      date_from: null
      date_to: null
    vm.statistic =
      rent_amount: 0
      buy_amount: 0
      total_orders: 0

    @fetch()

  open: (order) ->
    vm = @
    new_scope = vm.rootScope.$new()
    new_scope.order = order
    new_scope.order_statuses = vm.order_statuses
    modalInstance = @uibModal.open(
      templateUrl: '/templates/admin/orders/order'
      controller: 'OrderModalController'
      controllerAs: 'vm'
      size: 'lg'
      scope: new_scope
    )

    modalInstance.result.then ((order) ->
      order.$save({id: order.id})
      vm.fetch()
      return
    ), ->
      vm.log.info 'open_order Modal dismissed at: ' + new Date
      return
    return

  open_datepicker: (key) -> @date_filter[key] = true

  save: (order) ->
    order.$save({id: order.id})

  calc_stat: (orders) ->
    console.log orders
    orders

  fetch: ->
    vm = @
    vm.http.get('/admin/orders/statuses').then((statuses) ->
      vm.order_statuses = statuses.data
    )

    t_date = {}
    t_date['date_from'] = moment(vm.date_filter.date_from, 'DDMMYYYY').format() if vm.date_filter.date_from
    t_date['date_to'] = moment(vm.date_filter.date_to, 'DDMMYYYY').format() if vm.date_filter.date_to

    if t_date['date_from'] and t_date['date_from'] is 'Invalid date'
      return alert('Указана неверная дата: от')

    if t_date['date_to'] and t_date['date_to'] is 'Invalid date'
      return alert('Указана неверная дата: до')

    @Orders.query(t_date).$promise.then((orders) ->
      vm.log.info vm.filters

      if vm.filters.rent and vm.filters.rent is 'undefined'
        t_filter = angular.copy vm.filters
        delete t_filter['rent']
        vm.orders = vm.filter('filter')(orders, t_filter)
      else
        vm.orders = vm.filter('filter')(orders, vm.filters)


      vm.statistic =
        rent_amount: 0
        buy_amount: 0
        total_orders: 0
      for order in vm.orders
        if order.rent
          vm.statistic.rent_amount += order.total_price
        else
          vm.statistic.buy_amount += order.total_price
        vm.statistic.total_orders += 1
    )
@application.controller 'OrdersController', ['$rootScope', '$scope', '$log', 'Orders', '$http', '$filter', '$uibModal', OrdersController]
