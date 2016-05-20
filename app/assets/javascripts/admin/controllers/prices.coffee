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
        vm.LampPrices.remove({id: price.id})
        vm.fetch()
      when 'garland_price'
        vm.GarlandPrices.remove({id: price.id})
        vm.fetch()

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

      vm.LampPrices.create(lamp_price)
      vm.fetch()
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

      vm.GarlandPrices.create(garland_price)
      vm.fetch()
      return
    ), ->
      vm.log.info 'garland_price Modal dismissed at: ' + new Date
      return
    return

@application.controller 'PricesController', ['$rootScope', '$scope', 'LampPrices', 'GarlandPrices', '$uibModal', '$log', PricesController]
