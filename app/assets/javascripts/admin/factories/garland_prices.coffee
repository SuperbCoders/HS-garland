@application.factory 'GarlandPrices', (Resources) ->
  Resources '/admin/garland_prices/:id', {id: @id}, [
    {method: 'GET', isArray: false},
    {remove: {method: 'DELETE'}},
  ]
