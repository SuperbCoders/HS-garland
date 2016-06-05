class PricesController
  constructor: (@rootScope, @scope, @LampPrices, @GarlandPrices, @uibModal, @log) ->
    vm = @

    @fetch()

  fetch: ->
    vm = @
    @GarlandPrices.query({}).$promise.then((garland_prices) -> vm.garland_prices = garland_prices)
    @LampPrices.query({}).$promise.then((lamp_prices) -> vm.lamp_prices = lamp_prices)


  destroy: (type, price) ->
    vm = @
    switch type
      when 'lamp_price'
        vm.LampPrices.remove({id: price.id}).$promise.then((res) ->
          vm.fetch()
        )

      when 'garland_price'
        vm.GarlandPrices.remove({id: price.id}).$promise.then((res) ->
          vm.fetch()
        )

  edit_lamp_price: (price) ->
    vm = @
    new_scope = vm.rootScope.$new()
    new_scope.price = price
    modalInstance = @uibModal.open(
      templateUrl: '/templates/admin/settings/prices/modals/add_lamp_price'
      controller: 'PriceModalController'
      controllerAs: 'vm'
      scope: new_scope
    )

    modalInstance.result.then ((price) ->
      price.$save({id: price.id}).$promise.then((response) ->
        vm.fetch()
      )

      return
    ), ->
      vm.log.info 'edit_lamp_price Modal dismissed at: ' + new Date
      return
    return

  edit_garland_price: (price) ->
    vm = @
    new_scope = vm.rootScope.$new()
    new_scope.price = price
    modalInstance = @uibModal.open(
      templateUrl: '/templates/admin/settings/prices/modals/add_garland_price'
      controller: 'PriceModalController'
      controllerAs: 'vm'
      scope: new_scope
    )

    modalInstance.result.then ((price) ->
      price.$save({id: price.id}).$promise.then((response) ->
        vm.fetch()
      )

      return
    ), ->
      vm.log.info 'edit_lamp_price Modal dismissed at: ' + new Date
      return
    return

  add_lamp_price: ->
    vm = @
    modalInstance = @uibModal.open(
      templateUrl: '/templates/admin/settings/prices/modals/add_lamp_price'
      controller: 'PriceModalController'
      controllerAs: 'vm'
    )

    modalInstance.result.then ((lamp_price) ->
      vm.log.info "add_lamp_price Modal closed"
      vm.log.info lamp_price

      if lamp_price and lamp_price.buy_price and lamp_price.rent_price and lamp_price.power
        vm.LampPrices.create(lamp_price).$promise.then((response) ->
          vm.fetch()
        )
      else
        alert('Заполните все поля')

      return
    ), ->
      vm.log.info 'lamp_price Modal dismissed at: ' + new Date
      return
    return

  add_garland_price: ->
    vm = @
    modalInstance = @uibModal.open(
      templateUrl: '/templates/admin/settings/prices/modals/add_garland_price'
      controller: 'PriceModalController'
      controllerAs: 'vm'
    )

    modalInstance.result.then ((garland_price) ->
      vm.log.info "add_garland_price Modal closed"
      vm.log.info garland_price

      if garland_price and garland_price.buy_price and garland_price.rent_price and garland_price.lamps and garland_price.length
        vm.GarlandPrices.create(garland_price).$promise.then((response) ->
          vm.fetch()
        )
      else
        alert('Заполните все поля')

      return
    ), ->
      vm.log.info 'garland_price Modal dismissed at: ' + new Date
      return
    return

@application.controller 'PricesController', ['$rootScope', '$scope', 'LampPrices', 'GarlandPrices', '$uibModal', '$log', PricesController]
