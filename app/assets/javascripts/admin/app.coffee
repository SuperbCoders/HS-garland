@application = angular.module('garland.admin',
  [
    'ui.router',
    'ui.bootstrap',
    'angularUtils.directives.dirPagination',
    'ngResource',
    'naif.base64',
    'angular-loading-bar'
  ])

@application.run ['$rootScope', '$state', '$stateParams', ($rootScope, $state, $stateParams) ->
  $rootScope.state = $state;
  $rootScope.stateParams = $stateParams;
]

@application.config ['$httpProvider', '$stateProvider', '$urlRouterProvider', ($httpProvider, $stateProvider, $urlRouterProvider) ->
  $httpProvider.defaults.useXDomain = true
  $httpProvider.defaults.headers.post['Content-Type']= 'application/json'
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
  delete $httpProvider.defaults.headers.common['X-Requested-With']

  # Users
  $stateProvider
  .state 'orders',
    url: '/orders'
    templateUrl: '/templates/admin/orders/index'
    controller: 'OrdersController'
    controllerAs: 'vm'

  .state 'customers',
    url: '/customers'
    templateUrl: '/templates/admin/customers/index'
    controller: 'CustomersController'
    controllerAs: 'vm'

  .state 'settings',
    url: '/settings'
    templateUrl: '/templates/admin/settings/index'

  .state 'settings.general',
    url: '/general'
    templateUrl: '/templates/admin/settings/general'
    controller: 'GeneralSettingsController'
    controllerAs: 'vm'

  .state 'settings.share_banner',
    url: '/share_banner'
    templateUrl: '/templates/admin/settings/share_banner'
    controller: 'GeneralSettingsController'
    controllerAs: 'vm'

  .state 'settings.gallery',
    url: '/gallery'
    templateUrl: '/templates/admin/settings/gallery'
    controller: 'GalleryController'
    controllerAs: 'vm'

  .state 'settings.slider',
    url: '/slider'
    templateUrl: '/templates/admin/settings/slider'
    controller: 'SliderController'
    controllerAs: 'vm'

  .state 'settings.prices',
    url: '/prices'
    templateUrl: '/templates/admin/settings/prices/index'
    controller: 'PricesController'
    controllerAs: 'vm'

  .state 'settings.prices.garland',
    url: '/garland'
    templateUrl: '/templates/admin/settings/prices/garland'

  .state 'settings.prices.lamp',
    url: '/lamp'
    templateUrl: '/templates/admin/settings/prices/lamp'



  $urlRouterProvider.otherwise '/orders'
  return
]
