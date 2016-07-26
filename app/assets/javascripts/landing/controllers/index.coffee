class IndexController
  constructor: (@rootScope, @scope, @log, @http, @anchorScroll, @location) ->
    vm = @
    vm.garland_added = 0
    vm.image_added = 0
    vm.tags =
      all: true

    vm.order =
      rent: false
      delivery: 'moscow'
      total_price: 0
      garlands: []

    @log.info 'IndexController'
    @add_garland()
    @fetch_gallery_images()

    vm.active_work_tab = 0

    # When delivery method changed, need recalc price
    @scope.$watch('vm.order.days', (d) -> vm.calc_price())
    @scope.$watch('vm.garland_added', (m) -> vm.init_select2() )
    @scope.$watch('vm.image_added', (m) -> vm.init_work_slider())
    @scope.$watch('vm.order.delivery', (method) -> vm.calc_price() if method)
    @scope.$watch('vm.order.rent', (m) ->
      console.log vm.order
      vm.calc_price() if m
    )
    @init_landing()

    @initScriptModal()
    @initWorkSliders2()


    @rootScope.$on '$stateChangeStart', () ->
      $('html').removeClass 'open_menu'

    console.log "Index Selects : "+$('.select2').length

  gotoAnchor: (x) ->
    vm = @
    newHash = x
    if vm.location.hash() != newHash
      # set the $location.hash to `newHash` and
      # $anchorScroll will automatically scroll to it
      vm.location.hash x
    else
      # call $anchorScroll() explicitly,
      # since $location.hash hasn't changed
      vm.anchorScroll()
    return

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

    vm.scope.$apply()
    vm.init_work_slider()
    return false

  open_fancybox: (image_id) ->
    $("##{image_id}").click()
    return

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
      vm.init_work_slider()
    )

  calc_price: ->
    vm = @
    settings = vm.rootScope.settings
    order = vm.order
    order.total_price = 0
    order.guaranty_amount = 0

    console.log 'calc_price start ------------------- '
    # Перечесляем заказанные гирлянды
    for garland in order.garlands
      vm.log.info garland

      garland_total_price = 0


      if order.rent
        # Если это аренда
        # То суммируем ЦЕНА_АРЕНДЫ_ГИРЛЯНЛ + (КОЛИЧЕСТВО_ЛАМП * ЦЕНУ_АРЕНДЫ_ЛАМП)
        # и все это умножаем на количество дней
        garland_total_price += (garland.length.rent_price + (garland.length.lamps * garland.power.rent_price)) * order.days

      else
        # Если это продажа
        # Суммируем ЦЕНА_ПРОДАЖИ_ГИРЛЯНД + (КОЛИЧЕСТВО_ЛАМП * ЦЕНА_ПРОДАЖИ_ЛАМП)
        garland_total_price += (garland.length.buy_price + (garland.length.lamps * garland.power.buy_price))


      # Умножаем получившуюся сумму на количество гирлянд
      # затем суммируем в общую сумму заказа
      order.total_price += garland_total_price * garland.count

      if order.rent
        order.guaranty_amount += (garland.length.buy_price + (garland.length.lamps * garland.power.buy_price)) * garland.count


    # Если доставка по москве И общая_сумма_заказа менье чем в настройках
    if order.delivery is 'moscow' and order.total_price < settings.general.delivery_free_limit
      # То плюсуем сумму доставки по москве
      # которую берем из настроек админки
      order.total_price += settings.general.delivery_moscow

    console.log 'calc_price end ------------------- '
  add_garland: ->
    new_garland =
      count: 1
      length: @rootScope.settings.garland_prices[0]
      power: @rootScope.settings.lamp_prices[0]

    @order.garlands.push new_garland
    @calc_price()
    @garland_added = @order.garlands.length

  incr: (garland) ->
    garland.count = garland.count + 1
    @calc_price()

  decr: (garland) ->
    garland.count = garland.count - 1 if garland.count > 1
    @calc_price()

  make_order: ->
    vm = @

    return if not vm.order.name
    return if not vm.order.email
    return if not vm.order.phone

    if vm.order.rent and not vm.order.start_date and not vm.order.end_date
      return alert('Выберите период аренды')

    if vm.order.rent and vm.order.days < 5
      return alert('Минимальный срок аренды 5 дней')

    vm.http.post('/order', vm.order).then((response) ->
      vm.rootScope.order_id = response.data.order.order_id
      vm.rootScope.g.state.go('thanks')
    )

  init_select2: ->
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

  init_work_slider: ->
    console.log 'init_work_slider()'
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
        slidesPerColumn: 2
        spaceBetween: 23
        pagination: $this.nextAll('.slider_pagination')
        paginationClickable: true
        slidesPerColumnFill: 'row'
        breakpoints:
          1200:
            slidesPerView: 4
            slidesPerGroup: 4
            slidesPerColumn: 2
          1000:
            slidesPerView: 3
            slidesPerGroup: 3
            slidesPerColumn: 2
          840:
            slidesPerView: 2
            slidesPerGroup: 2
            slidesPerColumn: 1
          640:
            slidesPerView: 1
            slidesPerGroup: 1
            slidesPerColumn: 1
        onInit: (swp) ->
          $(swp.slides).find('.fancyboxLink').fancybox
            openEffect: 'none'
            closeEffect: 'none'
            padding: 0
            closeBtn: true
            parent: '.wrapper'
            tpl: wrap: '<div class="fancybox-wrap" tabIndex="-1"><div class="fancybox-skin"><div class="fancybox-outer"><div class="fancybox-counter"></div><div class="fancybox-inner"></div></div></div></div>'
            helpers:
              title: type: 'inside'
              overlay: locked: false
            afterLoad: (e) ->
              counter = $(@wrap).find('.fancybox-counter')
              title = @title
              counter_html = $('<div />').append('<div class="fancybox-counter-title" >' + (@element.attr('data-group-name') or '') + '</div>').append('<div class="fancybox-counter-val">' + @index + 1 + ' ИЗ ' + @group.length + '</div>')
              if title
                @title = '<div class="image_title">' + (title.split('|')[0] or '') + '</div> <div class="image_location">' + (title.split('|')[1] or '') + '</div>'
              counter.html counter_html
              return
          return
      )
      sl.update()
      return

  initScriptModal: ->
    $html = $('html')
    header = $('.header')
    dateRange = $('.dateRange')
    mobMenu = $('.mobMenuBtn')
    doc = $(document)
    browserWindow = $(window)
    browserWindow.on 'scroll', ->
      header.toggleClass 'fixed_header', doc.scrollTop() >= 90
      return
    mobMenu.on 'click', ->
      $html.toggleClass 'open_menu'
      false




    $(window).stellar
      hideDistantElements: false
      responsive: true
      horizontalScrolling: false
      verticalScrolling: true
    $('.validateMe').validationEngine(
      scroll: false
      showPrompts: true
      showArrow: false
      addSuccessCssClassToField: 'success'
      addFailureCssClassToField: 'error'
      parentFormClass: '.orderForm'
      parentFieldClass: '.formCell'
      promptPosition: 'centerRight'
      autoHidePrompt: true
      autoHideDelay: 200000
      autoPositionUpdate: true
      addPromptClass: 'relative_mode'
      showOneMessage: false).find('*[class*=validate]').on 'blur keyup', ->
    form = $(this).closest('.validateMe')
    notDone = false
    form.find('*[class*=validate]').each ->
      if !$(this).hasClass('success')
        notDone = true
      return
    $('#actionBtn').attr 'disabled', notDone or null
    return
    return




  init_landing: ->
    vm = @
    header = $('.header')
    dateRange = $('.dateRange')

    vm.datePickerParam = datePickerParam =
      'parentEl': '.datePicker'
      'opens': 'embed'
      'showDropdowns': true
      'autoUpdateInput': true
      'applyClass': 'inp_hidden'
      'autoApply': true
      'cancelClass': 'inp_hidden'
      'minDate': moment()
      'maxDate': moment().add(2, 'years')
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

    mainSlider = new Swiper('.mainSlider',
      loop: false
      initialSlide: 0
      setWrapperSize: true
      nextButton: '#main_slider_next'
      prevButton: '#main_slider_prev'
      slidesPerView: 1
      spaceBetween: 0
      onInit: (swp) ->
        $(swp.slides).each (ind) ->
          slide = $(this)
          slide.backstretch slide.find('img').hide().attr('src')
          return
        return
    )
    mainSlider.update()

    @init_work_slider()

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

    $(window).stellar
      hideDistantElements: false
      responsive: true
      horizontalScrolling: false
      verticalScrolling: true

    @init_select2()


    $('.monthBtn').on 'click', ->
      console.log 'month click'
      firedEl = $(this).parent()
      dateMonth = $('.dateMonth')
      ind = firedEl.index()
      firstMonthSelect = datePicker.data('daterangepicker').parentEl.find('.calendar.left .month .monthselect')
      secondMonthSelect = datePicker.data('daterangepicker').parentEl.find('.calendar.right .month .monthselect')
      firedEl.siblings().removeClass 'active'
      firstMonthSelect[0].selectedIndex = ind
      if ind == 11
        dateMonth.eq(ind).addClass 'active'
        dateMonth.eq(0).addClass 'active'
      else
        dateMonth.eq(ind).addClass('active').next().addClass 'active'
      firstMonthSelect.trigger 'change'
      false

    vm.datePicker = datePicker = $('input#daterange').daterangepicker(datePickerParam, (start, end, label) ->
      $(this)[0].element.change()
      return
    )

    datePicker.data('daterangepicker').parentEl.find('.calendar.left .month .yearselect option').each (ind) ->
      $('.dateRangeYear').append $('<option>' + @innerHTML + '</option>')
      return

    $('.dateRangeYear').on 'change', ->
      yearSelect = datePicker.data('daterangepicker').parentEl.find('.calendar.left .month .yearselect')
      yearSelect[0].selectedIndex = @selectedIndex
      yearSelect.trigger 'change'
      return

    $('input#daterange').on('apply.daterangepicker',(ev, picker) ->
      vm.log.info "Range selected. From : "+picker.startDate
      console.log picker
      days = picker.endDate.diff(picker.startDate, 'days') + 1

      if days < 5
        alert('Минимальный срок аренды 5 дней')
        picker.setEndDate(null)
      else
        vm.rootScope.$apply( ->
          vm.order.start_date = picker.startDate
          vm.order.end_date = picker.endDate
          vm.order.days = picker.endDate.diff(picker.startDate, 'days') + 1
        )
    )

  initWorkSliders2: ->
    work_tabs = {}

    controller = this

    formatResult = (item) ->
      if !item.id
  # return `text` for optgroup
        return item.text
      # return item template
      #console.log(item);
      '<i>' + item.text + '</i>'

    formatSelection = (item) ->
  # return selection template
      console.log item
      '<b>' + item.text + '</b>'

    tabSelect = $('.tabSelect')
    dateRange = $('.dateRange')
    tabBlock = $('.tabBlock')
    work_tabs = tabBlock.tabs(
      active: 0
      tabContext: tabBlock.data('tab-context')
      activate: (e, ui) ->
        tab = ui.newTab
        tab.parent().attr 'data-active-tab', tab.index()
        initWorkSliders()
        $(window).trigger 'resize'
        #$('.priceSelect').val('#' + ui.newPanel.attr('id')).trigger('change');
        vm.active_work_tab = ui.newPanel.index()
        $('.tabSelect').val('#' + ui.newPanel.attr('id')).trigger 'change'
        return
    )
#    datePicker = $('input#daterange').daterangepicker(datePickerParam)
#    $('.monthBtn').on 'click', ->
#      firedEl = $(this).parent()
#      ind = 1 * firedEl.attr('data-month')
#      dateMonth = $('.dateMonth')
#      firstMonthSelect = datePicker.data('daterangepicker').parentEl.find('.calendar.left .month .monthselect')
#      secondMonthSelect = datePicker.data('daterangepicker').parentEl.find('.calendar.right .month .monthselect')
#      firedEl.siblings().removeClass 'active'
#      firstMonthSelect[0].selectedIndex = ind
#      yearSelect = datePicker.data('daterangepicker').parentEl.find('.calendar.left .month .yearselect')
#      yearSelect[0].selectedIndex = 1 * (moment(datePickerParam.minDate).month() > ind)
#      yearSelect.trigger 'change'
#      if firedEl.index() == 11
#        firedEl.prev().find('.monthBtn').click()
#      else
#        dateMonth.filter((e, r) ->
#          $(r).attr('data-month') == ind
#        ).addClass('active').next().addClass 'active'
#      firstMonthSelect.trigger 'change'
#      false
#    datePicker.data('daterangepicker').parentEl.find('.calendar .daterangepicker_input input').on 'updated.daterangepicker', ->
#      drp = datePicker.data('daterangepicker')
#      if drp.endDate and drp.startDate
#        dateRange.text plural(drp.endDate.diff(drp.startDate, 'days') + 1, 'день', 'дня', 'дней')
#      else if drp.startDate
#        dateRange.text plural(drp.startDate.diff(drp.startDate, 'days') + 1, 'день', 'дня', 'дней')
#      return


    #datePicker.data('daterangepicker').parentEl.find('.calendar.left .month .yearselect option').each(function (ind) {
    #    $('.dateRangeYear').append($('<option>' + this.innerHTML + '</option>'));
    #});
    #$('.dateRangeYear').on ('change', function () {
    #    var yearSelect = datePicker.data('daterangepicker').parentEl.find('.calendar.left .month .yearselect');
    #
    #    yearSelect[0].selectedIndex = this.selectedIndex;
    #
    #    yearSelect.trigger('change');
    #});


#    updateMonths()
    $('.select2').each (ind) ->
      $slct = $(this)
      cls = $slct.attr('data-select-class') or ''
      $slct.select2
        minimumResultsForSearch: Infinity
        width: '100%'
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
    tabSelect.find('option').eq(this.active_work_tab).attr 'selected', 'selected'
    $('body').delegate('.tabSelect', 'change', ->
#      $('a[href=' + $(this).val() + ']').click()
      controller.filter($(this).val())
      controller.scope.$apply()
      return
    ).delegate('.checkDependence', 'change', ->
      firedEl = $(this)
      target = $(firedEl.attr('data-dependence'))
      target.each (ind) ->
        $this = $(this)
        if $this.hasClass('modeInvert')
          $this.toggle !firedEl.prop('checked')
        else
          $this.toggle firedEl.prop('checked')
        return
      return
    ).delegate '.checkDependence2', 'change', ->
      firedEl = $(this)
      target = $(firedEl.attr('data-dependence'))
      target.toggle firedEl.prop('checked')
      return
    return



  $(window).on 'scroll', ->
      $('.header').toggleClass 'fixed_header', $(document).scrollTop() >= 90
      return




@application.controller 'IndexController', ['$rootScope', '$scope', '$log', '$http', '$anchorScroll', '$location', IndexController]
