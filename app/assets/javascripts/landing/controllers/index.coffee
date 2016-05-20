class IndexController
  constructor: (@rootScope, @scope, @log, @http, @Lightbox) ->
    vm = @
    vm.tags =
      all: true

    vm.order =
      rent: false
      delivery: 'moscow'
      total_price: 0
      garlands: []

    @log.info 'IndexController'
    @init_landing()
    @add_garland()
    @fetch_gallery_images()


    # When delivery method changed, need recalc price
    @scope.$watch('vm.order.delivery', (method) ->
      if method
        vm.calc_price()
    )

  openLightboxModal: (index) ->
    vm = @
    vm.Lightbox.openModal(vm.images, index)

  filter: (type) ->
    vm = @
    switch type
      when 'all'
        vm.tags = {all: true}

      when 'holidays'
        vm.tags = {holidays: true}

      when 'iterior'
        vm.tags = {iterior: true}

      when 'cinema'
        vm.tags = {cinema: true}

      when 'wedding'
        vm.tags = {wedding: true}

  fetch_gallery_images: ->
    vm = @
    vm.gallery =
      all: 0
      holidays: 0
      iterior: 0
      cinema: 0
      wedding: 0

    vm.http.get('/gallery').then((response) ->
      vm.images = response.data
      for image in vm.images
        vm.gallery['all'] += 1
        vm.gallery['holidays'] += 1 if image.tags.holidays
        vm.gallery['iterior'] += 1 if image.tags.iterior
        vm.gallery['cinema'] += 1 if image.tags.cinema
        vm.gallery['wedding'] += 1 if image.tags.wedding

    )

  calc_price: ->
    vm = @
    settings = vm.rootScope.settings
    order = vm.order

    vm.log.info order

    order.total_price = 0

    for garland in order.garlands
      garland_total_price = 0
      vm.log.info garland
      if order.rent
        vm.log.info 'Calc for rent'
        garland_total_price += garland.length.rent_price + (garland.length.lamps * garland.power.rent_price)
      else
        vm.log.info 'Calc for buy'
        garland_total_price += (garland.length.buy_price + (garland.length.lamps * garland.power.buy_price))

      order.total_price += garland_total_price * garland.count


    if order.delivery is 'moscow' and order.total_price < settings.general.delivery_free_limit
      order.total_price += settings.general.delivery_moscow

  add_garland: ->
    new_garland =
      count: 1
      length: @rootScope.settings.garland_prices[0]
      power: @rootScope.settings.lamp_prices[0]

    @order.garlands.push new_garland
    @calc_price()

  incr: (garland) ->
    garland.count = garland.count + 1
    @calc_price()

  decr: (garland) ->
    garland.count = garland.count - 1 if garland.count > 1
    @calc_price()

  make_order: ->
    vm = @

    return alert('Укажите Имя') if not vm.order.name
    return alert('Укажите Email') if not vm.order.email
    return alert('Укажите номер телефона') if not vm.order.phone

    if vm.order.rent and not vm.order.start_date and not vm.order.end_date
      return alert('Выберите период аренды')

    vm.http.post('/order', vm.order).then((response) ->
      console.log response
    )

  init_landing: ->
    vm = @

    datePickerParam =
      'parentEl': '.datePicker'
      'opens': 'embed'
      'showDropdowns': true
      autoUpdateInput: true
      'applyClass': 'inp_hidden'
      'autoApply': true
      'cancelClass': 'inp_hidden'
      'minDate': moment()
      locale:
        format: 'DD/MM/YYYY'
        firstDay: 1
        'daysOfWeek': [
          'Вс'
          'Пн'
          'Вт'
          'Ср'
          'Чт'
          'Пт'
          'Сб'
        ]

    header = $('.header')
    dateRange = $('.dateRange')
    doc = $(document)
    browserWindow = $(window)

    browserWindow.on 'scroll', ->
      header.toggleClass 'fixed_header', doc.scrollTop() >= 90
      return

    $(window).stellar
      hideDistantElements: false
      responsive: true
      horizontalScrolling: false
      verticalScrolling: true

    $('.validateMe').validationEngine
      scroll: false
      showPrompts: true
      showArrow: false
      addSuccessCssClassToField: 'success'
      addFailureCssClassToField: 'error'
      parentFieldClass: '.formCell'
      promptPosition: 'centerRight'
      autoHidePrompt: true
      autoHideDelay: 2000
      autoPositionUpdate: true
      addPromptClass: 'relative_mode'
      showOneMessage: false

    mainSlider = new Swiper('.mainSlider',
      loop: false
      initialSlide: 0
      setWrapperSize: true
      nextButton: '#main_slider_next'
      prevButton: '#main_slider_prev'
      slidesPerView: 1
      spaceBetween: 0)

    $('.workSlider').each ->
      $this = $(this)
      sl = new Swiper(this,
        loop: false
        initialSlide: 0
        setWrapperSize: true
        nextButton: $this.nextAll('.slider_next')
        prevButton: $this.nextAll('.slider_prev')
        slidesPerView: 5
        slidesPerGroup: 5
        spaceBetween: 23
        pagination: $this.nextAll('.slider_pagination')
        paginationClickable: true
        breakpoints:
          320:
            slidesPerView: 1
            slidesPerGroup: 1
          640:
            slidesPerView: 2
            slidesPerGroup: 2
          840:
            slidesPerView: 3
            slidesPerGroup: 3
          960:
            slidesPerView: 4
            slidesPerGroup: 4)
      return

    datePicker = $('input#daterange').daterangepicker(datePickerParam, (start, end, label) ->
      $(this)[0].element.change()
      return
    )

    $('input#daterange').on('apply.daterangepicker',(ev, picker) ->
      vm.log.info "Range selected. From : "+picker.startDate
      console.log picker
      vm.rootScope.$apply( ->
        vm.order.start_date = picker.startDate
        vm.order.end_date = picker.endDate
        vm.order.days = picker.endDate.diff(picker.startDate, 'days') + 1
      )

    )


    $('.validateMe').validationEngine
      scroll: false
      showPrompts: true
      showArrow: false
      addSuccessCssClassToField: 'success'
      addFailureCssClassToField: 'error'
      parentFieldClass: '.formCell'
      promptPosition: 'centerRight'
      autoHidePrompt: true
      autoHideDelay: 2000
      autoPositionUpdate: true
      addPromptClass: 'relative_mode'
      showOneMessage: false

    $('.select2').each (ind) ->
      $slct = $(this)
      cls = $slct.attr('data-select-class') or ''
      $slct.select2
        minimumResultsForSearch: Infinity
        width: '100%'
        containerCssClass: cls
        adaptDropdownCssClass: (c) ->
          cls
        templateResult: (d, c) ->
          #console.log(d, c);
          extraInfo = $(d.element).attr('data-nowaterproof') or false
          noWaterproof = $('.checkDependence2').prop('checked')
          ret = $('<div>' + $(d.element).text() + '</div>')
          if extraInfo and noWaterproof
            $(c).addClass 'no_rain_defence'
            ret.append $('<div class="extra_info">' + extraInfo + '</div>')
          ret
      return


@application.controller 'IndexController', ['$rootScope', '$scope', '$log', '$http', 'Lightbox', IndexController]
