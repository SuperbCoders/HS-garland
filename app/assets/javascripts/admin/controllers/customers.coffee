class CustomersController
  constructor: (@rootScope, @Customers) ->
    vm = @
    @fetch()

  fetch: ->
    vm = @
    vm.Customers.query({}).$promise.then((customers) ->
      vm.customers = customers
    )

  destroy: (customer) ->
    vm = @
    customer.$remove({id: customer.id}).then((response) -> vm.fetch() )
    
@application.controller 'CustomersController', ['$rootScope', 'Customers', CustomersController]
