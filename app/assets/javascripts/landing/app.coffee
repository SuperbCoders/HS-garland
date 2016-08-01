@application = angular.module('garland.landing',
  [ 'ui.router',
    'angularUtils.directives.dirPagination',
    'ui.mask',
    'colorbox'
  ])

@application.config ['$httpProvider', '$stateProvider', '$urlRouterProvider', ($httpProvider, $stateProvider, $urlRouterProvider) ->
  $httpProvider.defaults.useXDomain = true
  $httpProvider.defaults.headers.post['Content-Type']= 'application/json'
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')

  delete $httpProvider.defaults.headers.common['X-Requested-With']

  $stateProvider
  .state 'index',
    url: '/'
    templateUrl: '/templates/landing/index'
    controller: 'IndexController'
    controllerAs: 'vm'

  .state 'conditions',
    url: '/conditions'
    controller: 'OtherController'
    templateUrl: '/templates/landing/conditions'

  .state 'thanks',
    url: '/thanks'
    templateUrl: '/templates/landing/thanks'

  .state 'benefits',
    url: '/benefits'
    controller: 'OtherController'
    templateUrl: '/templates/landing/benefits'

  $urlRouterProvider.otherwise '/'
]


@application.run ['$rootScope', '$state', ($rootScope, $state) ->
  $rootScope.settings = JSON.parse($("meta[name='settings']").attr('content'))
  $rootScope.settings.contract = if $rootScope.settings.contract then $rootScope.settings.contract else 'HS_Rent_05.pdf'
  $rootScope.settings.contract_extension = $rootScope.settings.contract.split('.').pop()

  $rootScope.g =
    state: $state

  console.log 'app run'
]
