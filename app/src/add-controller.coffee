class AddController
  constructor: (@$scope, @$state, @$timeout, @BookmarkService, @TagService) ->
    @loadCurrentTab()
    @loadTags()

  loadCurrentTab: ->
    # TODO: move into service
    #chrome = { tabs:  { query: (q, c) -> c([{ url: 'http://google.com', title: 'google!' }]) } }

    query = { active: true, currentWindow: true }
    chrome.tabs.query query, (tabs) =>
      tab = tabs[0] || {}
      @bookmark = {
        href: tab.url
        description: tab.title
      }
      @$scope.$digest() unless @$scope.$$phase

  saveBookmark: (bookmark) ->
    @BookmarkService.save(bookmark).then =>
      @$state.go 'results' # TODO: dismiss popup

  checkIfExists: (href) ->
    @BookmarkService.loadIfExists(href).then (bookmark) =>
      @bookmark = bookmark if bookmark

  loadTags: ->
    @TagService.getTags().then (tags) =>
      @tags = tags
      $('#tags-input').select2()
