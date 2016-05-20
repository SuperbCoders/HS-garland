class UploadModalController
  constructor: (@scope, @uibModalInstance, @http) ->
    console.log 'UploadModalController'
    vm = @
    vm.result = {}
    vm.tags = {holidays: false, iterior: false, cinema: false, wedding: false}

  upload: ->
    vm = @

    console.log vm.tags
    if not @tags_checked()
      return alert('Выберите хотя бы один тег!')

    packet =
      tags: vm.tags
      files: vm.interface

    vm.http.post('/admin/gallery/upload', packet).then((response) ->
      vm.uibModalInstance.close vm.result
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
  fetch: ->
    vm = @
    vm.http.get('/admin/gallery').then((response) ->
      vm.images = response.data
    )

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
