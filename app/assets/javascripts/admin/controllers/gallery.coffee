class UploadModalController
  constructor: (@scope, @uibModalInstance, @http) ->
    console.log 'UploadModalController'
    vm = @
    vm.result = {}
    vm.tags = {holidays: false, iterior: false, cinema: false, wedding: false}
    vm.loading = false

  upload: ->
    vm = @


    console.log vm.tags
    if not @tags_checked()
      return alert('Выберите хотя бы один тег!')

    for file in vm.interface
      return alert('Укажите дату и описание у изображения') if not file.date or not file.description

    packet =
      tags: vm.tags
      files: vm.interface

    vm.loading = true
    vm.http.post('/admin/gallery/upload', packet).then((response) ->
      vm.uibModalInstance.close vm.result
      vm.loading = false
    )

    return

  cancel: ->
    vm = @
    vm.uibModalInstance.dismiss 'cancel'
    return

  tags_checked: ->
    vm = @
    vm.checked = false
    _.forEach(@tags, (key) ->
      vm.checked = true if key

    )
    vm.checked


class GalleryController
  constructor: (@rootScope, @scope, @log, @uibModal, @http) ->
    vm = @
    vm.images = []
    vm.filter =
      all: true
      holidays: false
      iterior: false
      cinema: false
      wedding: false

    @log.info 'GalleryController'

    @fetch()

    _.forEach(vm.filter, (key, value) ->
      vm.scope.$watch("vm.filter.#{value}", (val) ->
        delete vm.filter[value] if !val
      )
    )

  destroy: (image) ->
    vm = @
    vm.http.post('/admin/gallery/destroy', {id: image.id}).then((response) ->
      if response.data.success
        vm.images.splice(vm.images.indexOf(image), 1)
      else
        alert(response.data.error)
    )

  compare: (a, b)->
    if a.id < b.id
      return 1
    if a.id > b.id
      return -1
    return 0

  fetch: ->
    vm = @
    vm.stat =
      holidays: 0
      iterior: 0
      cinema: 0
      wedding: 0

    vm.http.get('/admin/gallery').then((response) ->
      vm.images = response.data

      vm.stat.all = vm.images.length
      for image in vm.images
        vm.stat.holidays += 1 if image.holidays
        vm.stat.iterior += 1 if image.iterior
        vm.stat.cinema += 1 if image.cinema
        vm.stat.wedding += 1 if image.wedding
        arr = image.date.split('-')
        image.date = arr[2]+'-'+arr[1]+'-'+arr[0]

      vm.images.sort(vm.compare)
    )

  send_edit: (value)->
    vm = @
    
    vm.http.put('/admin/gallery', {id: value.id, date: value.date, description: value.description}).then(
      (res) ->
        alert 'Новые реквизиты: '+res.data.image.description+' '+res.data.image.date
      ,(res) ->
        alert 'Ошибка'+res.data
    )
#    todo show error

  upload_modal: ->
    vm = @

    modalInstance = @uibModal.open(
      templateUrl: '/templates/admin/settings/gallery/modals/upload'
      controller: 'UploadModalController'
      controllerAs: 'vm'
      size: 'lg'
    )

    modalInstance.result.then ((result) ->
      vm.fetch()
      return
    ), ->
      vm.log.info 'lamp_price Modal dismissed at: ' + new Date
      return
    return

@application.controller 'GalleryController', ['$rootScope', '$scope','$log', '$uibModal', '$http', GalleryController]
@application.controller 'UploadModalController', ['$scope', '$uibModalInstance', '$http', UploadModalController]
