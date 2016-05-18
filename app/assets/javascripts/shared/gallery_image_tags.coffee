@application.filter 'tagFilter', ['$filter', '$rootScope', ($filter, $rootScope) ->
  (input) ->
    result = ''
    switch input
      when 'holidays'
        result = 'праздники'
      when 'iterior'
        result = 'ярмарки и интерьеры'
      when 'cinema'
        result = 'реклама и кино'
      when 'wedding'
        result = 'свадьбы'

    result
]
