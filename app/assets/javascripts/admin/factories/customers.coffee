@application.factory 'Customers', (Resources) ->
  Resources '/admin/customers/:id', {id: @id}, [
    {method: 'GET', isArray: false},
    {remove: {method: 'DELETE'}},
  ]
