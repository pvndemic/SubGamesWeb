'use strict'

angular.module 'subgamesApp', [
  'ngResource'
  'ngSanitize'
  'ngCookies'
  'ui.router'
  'ui.bootstrap'
  'ui.select'
]
.config ($stateProvider, $urlRouterProvider, $locationProvider, $httpProvider, uiSelectConfig) ->
  uiSelectConfig.theme = 'selectize'

  $urlRouterProvider
  .otherwise '/l'

  $locationProvider.html5Mode true
  $httpProvider.interceptors.push 'authInterceptor'

.factory 'authInterceptor', ($rootScope, $q, $location) ->
  # Add authorization token to headers
  request: (config) ->
    config.headers = config.headers or {}
    config

  # Intercept 401s and redirect you to login
  responseError: (response) ->
    if response.status is 401
      $location.path '/l'
    $q.reject response

.run ($rootScope, $location, Auth) ->
  # Redirect to login if route requires auth and you're not logged in
  $rootScope.$on '$stateChangeStart', (event, next) ->
    Auth.getLoginStatus (user, token) ->
      loggedIn = user? && user.steam? && !_.isEmpty(user.steam) && user.twitchtv? && !_.isEmpty(user.twitchtv)
      $location.path "/authreturn" if next.authenticate and not loggedIn
  $rootScope.GameMode =
    NONE: 0
    AP: 1
    CM: 2
    RD: 3
    SD: 4
    AR: 5
    INTRO: 6
    HW: 7
    REVERSE_CM: 8
    XMAS: 9
    TUTORIAL: 10
    MO: 11
    LP: 12
    POOL1: 13
    FH: 14
    CUSTOM: 15
    CD: 16
    BD: 17
    ABILITY_DRAFT: 18
    EVENT: 19
    ARDM: 20
    SOLOMID: 21
  $rootScope.GameModeK = _.invert $rootScope.GameMode
  $rootScope.GameModeN =
    #0: "None"
    1: "All Pick"
    2: "Captains Mode"
    3: "Ranked Draft"
    4: "Single Draft"
    5: "All Random"
    #6: "Intro"
    #7: "Halloween"
    8: "Reverse Captains"
    #9: "Xmas"
    #10: "Tutorial"
    11: "Mid Only"
    #12: "Low Priority"
    #13: "Pool1"
    #14: "FH"
    #15: "Custom Games"
    16: "Captains Draft"
    #17: "Balanced Draft"
    18: "Ability Draft"
    20: "Deathmatch"
    #21: "Solo Mid"
  $rootScope.GameModeNA = []
  for id, name of $rootScope.GameModeN
    $rootScope.GameModeNA.push
      id: id
      name: name
  $rootScope.GameModeNK = _.invert $rootScope.MatchTypeN
  $rootScope.MatchType =
    STARTGAME: 0
    CAPTAINS: 1
  $rootScope.MatchTypeK = _.invert $rootScope.MatchType
  $rootScope.GameType =
    DOTA: 0
  $rootScope.GameTypeK = _.invert $rootScope.GameType
  $rootScope.GameTypeN =
    0: "Dota 2"
  $rootScope.GameTypeNA = _.values $rootScope.GameTypeN
  $rootScope.GameTypeNK = _.invert $rootScope.GameTypeN
  $rootScope.GameTypeSel = [
    {name: "Dota 2", id: 0}
  ]
  $rootScope.RegionSel = [
    {name: "Auto Region", id: 0}
    {name: "US West", id: 1}
    {name: "US East", id: 2}
    {name: "Europe", id: 3}
    {name: "Korea", id: 4}
    {name: "Singapore", id: 5}
    {name: "Australia", id: 7}
    {name: "Stockholm", id: 8}
    {name: "Austria", id: 9}
    {name: "Brazil", id: 10}
    {name: "South Africa", id: 11}
  ]
  $rootScope.GameTypeL =
    0: "http://i.imgur.com/rlx1Kb2.png"
  $rootScope.PartyStatusN =
    0: "Waiting for a party bot..."
    1: "Waiting for a bot host..."
    2: "Bot is setting up the party..."
    3: "Bot is waiting for the host to accept..."
    4: "Waiting for queue start..."
  $rootScope.LobbyStatusN =
    0: "Waiting for a lobby bot..."
    1: "Waiting for a bot host..."
    2: "Bot is setting up the lobby..."
    3: "Waiting for the host to join lobby & team..."
    4: "Waiting for game start..."
