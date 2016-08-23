class GeneralSettingsController
  constructor: (@rootScope, @http) ->
    vm = @

    @http.get('/admin/settings/general').then((response) -> vm.settings = response.data)
    @http.get('/admin/settings/share_banner').then((response) -> vm.banner = response.data )
    @http.get('/admin/settings/cost_garland').then((response) -> vm.cost_garland = response.data )
    @http.get('/admin/settings/rent_garland').then((response) -> vm.rent_garland = response.data )

  save_banner: ->
    vm = @
    vm.http.post('/admin/settings/share_banner', vm.banner).then((response) ->
      vm.banner = response.data
    )

  save_rent_garland: ->
    vm = @
    vm.http.post('/admin/settings/rent_garland', vm.rent_garland).then((response) ->
      vm.rent_garland = response.data
    )

  save_cost_garland: ->
    vm = @
    vm.http.post('/admin/settings/cost_garland', vm.cost_garland).then((response) ->
      vm.cost_garland = response.data
    )

  save: ->
    vm = @

    vm.http.post('/admin/settings/general', vm.settings).then((response) ->
      vm.settings = response.data
    )

@application.controller 'GeneralSettingsController', ['$rootScope', '$http', GeneralSettingsController]
