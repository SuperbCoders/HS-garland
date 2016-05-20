class SliderUploadModalController
  constructor: (@scope, @uibModalInstance, @http) ->
    console.log 'SliderUploadModalController'
    vm = @
    vm.result = {}

  upload: ->
    vm = @
    packet =
      files: vm.interface

    vm.http.post('/admin/slider/upload', packet).then((response) ->
      vm.uibModalInstance.close vm.result
    )

    return

  cancel: ->
    vm = @
    vm.uibModalInstance.dismiss 'cancel'
    return

class SliderController
  constructor: (@rootScope, @scope, @log, @uibModal, @http) ->
    vm = @
    vm.images = []
    @log.info 'SliderController'
    @fetch()


  destroy: (image) ->
    vm = @
    vm.http.post('/admin/slider/destroy', {id: image.id}).then((response) ->
      if response.data.success
        vm.images.splice(vm.images.indexOf(image), 1)
      else
        alert(response.data.error)
    )

  fetch: ->
    vm = @
    vm.http.get('/admin/slider').then((response) ->
      vm.images = response.data
    )

  upload_modal: ->
    vm = @

    modalInstance = @uibModal.open(
      templateUrl: '/templates/admin/settings/slider/modals/upload'
      controller: 'SliderUploadModalController'
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

@application.controller 'SliderController', ['$rootScope', '$scope','$log', '$uibModal', '$http', SliderController]
@application.controller 'SliderUploadModalController', ['$scope', '$uibModalInstance', '$http', SliderUploadModalController]
