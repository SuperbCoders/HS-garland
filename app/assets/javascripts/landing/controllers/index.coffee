class IndexController
  constructor: (@rootScope, @scope, @log) ->
    vm = @
    vm.order =
      rent: false
      garlands: []


    @log.info 'IndexController'
    @init_landing()
    @add_garland()



  init_landing: ->
    datePickerParam =
      'parentEl': '.datePicker'
      'opens': 'embed'
      'showDropdowns': true
      autoUpdateInput: true
      'applyClass': 'inp_hidden'
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
      console.log start, end, label
      $(this)[0].element.change()
      return
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

  add_garland: -> @order.garlands.push {count: 1, need_installation: false, rain_protection: false}
  incr: (garland) -> garland.count = garland.count + 1
  decr: (garland) -> garland.count = garland.count - 1 if garland.count > 1

@application.controller 'IndexController', ['$rootScope', '$scope', '$log', IndexController]
