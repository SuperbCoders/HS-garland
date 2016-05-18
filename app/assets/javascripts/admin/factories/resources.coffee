@application.factory 'Resources', ['$resource',
  ($resource) -> (url, urlDesc, customActions) ->
    actions =
      save:
        method: 'PUT'
      create:
        method: 'POST'
      remove:
        method: 'DELETE'

    if customActions
      _.forEach customActions, (action) ->
        actions[action.name] =
          method: action.method
          url: [url, action.name].join('/')
          isArray: action.isArray || false

    resources = $resource url, urlDesc, actions


]
