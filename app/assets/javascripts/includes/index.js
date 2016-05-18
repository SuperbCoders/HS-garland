var mainSlider, work_tabs, datePicker,
    datePickerParam = {
        "parentEl": ".datePicker",
        "opens": "embed",
        "showDropdowns": true,
        autoUpdateInput: true,
        //"startDate": moment(),
        //"endDate": moment().add(15, 'day'),
        //ranges: {
        //    'Today': [moment(), moment()],
        //    'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
        //    'Last 7 Days': [moment().subtract(6, 'days'), moment()],
        //    'Last 30 Days': [moment().subtract(29, 'days'), moment()],
        //    'This Month': [moment().startOf('month'), moment().endOf('month')],
        //    'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
        //},
        "applyClass": "inp_hidden",
        "cancelClass": "inp_hidden",
        "minDate": moment(),
        //"maxDate": moment().add(150, 'd').format('DD/MM/YYYY'),
        //"alwaysShowCalendars": true,

        locale: {
            format: 'DD/MM/YYYY',
            firstDay: 1,
            "daysOfWeek": [
                "Вс",
                "Пн",
                "Вт",
                "Ср",
                "Чт",
                "Пт",
                "Сб"
            ]
        }
    };

$(function ($) {

    var mainSlider = new Swiper('.mainSlider', {
        // Optional parameters
        loop: false,
        initialSlide: 0,
        setWrapperSize: true,
        // Navigation arrows
        nextButton: '#main_slider_next',
        prevButton: '#main_slider_prev',
        slidesPerView: 1,
        spaceBetween: 0
    });

    $('.workSlider').each(function () {
        var $this = $(this);

        var sl = new Swiper(this, {
            // Optional parameters
            loop: false,
            initialSlide: 0,
            setWrapperSize: true,
            // Navigation arrows
            nextButton: $this.nextAll('.slider_next'),
            prevButton: $this.nextAll('.slider_prev'),
            slidesPerView: 5,
            slidesPerGroup: 5,
            spaceBetween: 23,
            pagination: $this.nextAll('.slider_pagination'),
            paginationClickable: true,
            // Responsive breakpoints
            breakpoints: {
                // when window width is <= 320px
                320: {
                    slidesPerView: 1,
                    slidesPerGroup: 1,
                    //spaceBetweenSlides: 10
                },
                // when window width is <= 640px
                640: {
                    slidesPerView: 2,
                    slidesPerGroup: 2,
                    //spaceBetweenSlides: 15
                },
                // when window width is <= 840px
                840: {
                    slidesPerView: 3,
                    slidesPerGroup: 3,
                    //spaceBetweenSlides: 20
                },
                // when window width is <= 960px
                960: {
                    slidesPerView: 4,
                    slidesPerGroup: 4,
                    //spaceBetweenSlides: 23
                }
            }
        });
    });

    var dateRange = $('.dateRange');

    var tabBlock = $('.tabBlock'),
        work_tabs = tabBlock.tabs({
            active: 0,
            tabContext: tabBlock.data('tab-context'),
            activate: function (e, ui) {
                var tab = ui.newTab;

                tab.parent().attr('data-active-tab', tab.index());

                //$('.priceSelect').val('#' + ui.newPanel.attr('id')).trigger('change');

            }
        });

    datePicker = $('input#daterange').daterangepicker(datePickerParam, function (start, end, label) {
        console.log(start, end, label);
        $(this)[0].element.change();
    });

    $('.monthBtn').on ('click', function () {
        var firedEl = $(this).parent(), dateMonth = $('.dateMonth'), ind = firedEl.index();

        var firstMonthSelect = datePicker.data('daterangepicker').parentEl.find('.calendar.left .month .monthselect'),
            secondMonthSelect = datePicker.data('daterangepicker').parentEl.find('.calendar.right .month .monthselect');

        firedEl.siblings().removeClass('active');

        firstMonthSelect[0].selectedIndex = ind;

        if (ind == 11) {
            dateMonth.eq(ind).addClass('active');
            dateMonth.eq(0).addClass('active');
        } else {
            dateMonth.eq(ind).addClass('active').next().addClass('active');
        }

        firstMonthSelect.trigger('change');

        return false;
    });

    datePicker.data('daterangepicker').parentEl.find('.calendar .daterangepicker_input input').on ('updated.daterangepicker', function () {
        var drp = datePicker.data('daterangepicker');

        if (drp.endDate && drp.startDate) {
            dateRange.text(plural(drp.endDate.diff(drp.startDate, 'days') + 1, 'день', 'дня', 'дней'));
        } else if (drp.startDate) {
            dateRange.text(plural(drp.startDate.diff(drp.startDate, 'days') + 1, 'день', 'дня', 'дней'));
        }

    });

    datePicker.data('daterangepicker').parentEl.find('.calendar.left .month .yearselect option').each(function (ind) {
        $('.dateRangeYear').append($('<option>' + this.innerHTML + '</option>'));
    });

    $('.dateRangeYear').on ('change', function () {
        var yearSelect = datePicker.data('daterangepicker').parentEl.find('.calendar.left .month .yearselect');

        yearSelect[0].selectedIndex = this.selectedIndex;

        yearSelect.trigger('change');
    });

    function formatResult(item) {
        if (!item.id) {
            // return `text` for optgroup
            return item.text;
        }
        // return item template
        console.log(item);

        return '<i>' + item.text + '</i>';
    }

    function formatSelection(item) {
        // return selection template
        console.log(item);

        return '<b>' + item.text + '</b>';
    }

    $('.validateMe').validationEngine({
        scroll: false,
        showPrompts: true,
        showArrow: false,
        addSuccessCssClassToField: 'success',
        addFailureCssClassToField: 'error',
        parentFieldClass: '.formCell',
        promptPosition: "centerRight",
        autoHidePrompt: true,
        autoHideDelay: 2000,
        autoPositionUpdate: true,
        addPromptClass: 'relative_mode',
        showOneMessage: false
    });

    $('.select2').each(function (ind) {
        var $slct = $(this), cls = $slct.attr('data-select-class') || '';

        $slct.select2({
            minimumResultsForSearch: Infinity,
            width: '100%',
            containerCssClass: cls,
            adaptDropdownCssClass: function (c) {
                return cls;
            },
            templateResult: function (d, c) {
                //console.log(d, c);
                var extraInfo = $(d.element).attr('data-nowaterproof') || false,
                    noWaterproof = $('.checkDependence2').prop('checked'),
                    ret = $('<div>' + $(d.element).text() + '</div>');

                if (extraInfo && noWaterproof) {
                    $(c).addClass('no_rain_defence');
                    ret.append($('<div class="extra_info">' + extraInfo + '</div>'));
                }

                return ret;
            },
            //templateSelection: function (d) {
            //    console.log(d);
            //    return $(d.element).text();
            //}
        });
    });

    $('body')
        .delegate('.checkDependence', 'change', function () {
            var firedEl = $(this), target = $(firedEl.attr('data-dependence'));

            target.each(function (ind) {
                var $this = $(this);

                if ($this.hasClass('modeInvert')) {
                    $this.toggle(!firedEl.prop('checked'));
                } else {
                    $this.toggle(firedEl.prop('checked'));
                }
            });

        })
        .delegate('.checkDependence2', 'change', function () {
            var firedEl = $(this), target = $(firedEl.attr('data-dependence'));
            target.toggle(firedEl.prop('checked'));
        });

});

function plural(n, str1, str2, str5) {
    return n + ' ' + ((((n % 10) == 1) && ((n % 100) != 11)) ? (str1) : (((((n % 10) >= 2) && ((n % 10) <= 4)) && (((n % 100) < 10) || ((n % 100) >= 20))) ? (str2) : (str5)))
}
