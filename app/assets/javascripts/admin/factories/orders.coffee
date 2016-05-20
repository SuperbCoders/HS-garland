@application.factory 'Orders', (Resources) ->
  Resources '/admin/orders/:id', {id: @id}, [
    {method: 'GET', isArray: false},
    {remove: {method: 'DELETE'}},
  ]
