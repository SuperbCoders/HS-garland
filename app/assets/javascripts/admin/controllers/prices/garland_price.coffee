class PriceModalController
  constructor: (@scope, @uibModalInstance) ->
    console.log 'PriceModalController'
    vm = @
    vm.price = {}

  save: ->
    vm = @
    vm.uibModalInstance.close vm.price
    return

  cancel: ->
    vm = @
    vm.uibModalInstance.dismiss 'cancel'
    return


@application.controller 'PriceModalController', ['$scope', '$uibModalInstance', PriceModalController]
