class GeneralSettingsController
  constructor: (@rootScope, @http) ->
    vm = @

    @http.get('/admin/settings/general').then((response) -> vm.settings = response.data)
    @http.get('/admin/settings/share_banner').then((response) -> vm.banner = response.data )

  save_banner: ->
    vm = @
    vm.http.post('/admin/settings/share_banner', vm.banner).then((response) ->
      vm.banner = response.data
    )

  save: ->
    vm = @

    vm.http.post('/admin/settings/general', vm.settings).then((response) ->
      vm.settings = response.data
    )

@application.controller 'GeneralSettingsController', ['$rootScope', '$http', GeneralSettingsController]
