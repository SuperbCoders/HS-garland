@application.factory 'LampPrices', (Resources) ->
  Resources '/admin/lamp_prices/:id', {id: @id}, [
    {method: 'GET', isArray: false},
    {remove: {method: 'DELETE'}},
  ]
