@application = angular.module('garland.landing',
  [ 'ui.router',
    'angularUtils.directives.dirPagination',
    'ui.mask',
    'bootstrapLightbox'
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

  .state 'thanks',
    url: '/thanks'
    templateUrl: '/templates/landing/thanks'

  .state 'benefits',
    url: '/benefits'
    templateUrl: '/templates/landing/benefits'
    controller: 'IndexController'
    controllerAs: 'vm'
  $urlRouterProvider.otherwise '/'
]


@application.run ['$rootScope', '$state', ($rootScope, $state) ->
  $rootScope.settings = JSON.parse($("meta[name='settings']").attr('content'))
  $rootScope.g =
    state: $state
]
