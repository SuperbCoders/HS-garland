@application.filter 'statusFilter', ['$filter', '$rootScope', ($filter, $rootScope) ->
  (input) ->
    result = ''
    switch input
      when 'new'
        result = 'новый'
      when 'confirmed'
        result = 'обработан'
      when 'declined'
        result = 'отменен'
    result
]
