class CustomersController
  constructor: (@rootScope, @Customers) ->
    vm = @
    @fetch()

  fetch: ->
    vm = @
    vm.Customers.query({}).$promise.then((customers) ->
      vm.customers = customers
    )

@application.controller 'CustomersController', ['$rootScope', 'Customers', CustomersController]
