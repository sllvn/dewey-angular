class ResultsController
  constructor: ($scope, $timeout, BookmarkService) ->
    QUERY_REGEX = /(#\w*)/g
    @searcher = new Searcher(QUERY_REGEX)
    @query ||= ''
    @bookmarks = []
    @filteredBookmarks = []

    BookmarkService.getBookmarks().then (bookmarks) =>
      @bookmarks = _.map bookmarks, (bookmark) ->
        bookmark.searchable = bookmark.description.toLowerCase()
        bookmark.tagsArray = bookmark.tags.split(' ')
        bookmark
      @filteredBookmarks = @bookmarks.reverse()

    debounced = null
    $scope.$watch 'results.query', (newVal) =>
      $timeout.cancel(debounced)
      debounced = $timeout =>
        parsedSearchQuery = @searcher.parse(newVal)
        @filteredBookmarks = @searcher.search(@bookmarks, parsedSearchQuery) if @bookmarks
      , 200

  tagClick: (tag) ->
    @query = [@query, "##{tag}"].join(' ').trim()

  openBookmark: (bookmark) ->
    if chrome
      chrome.tabs.update null, { url: bookmark.href }
      window.close()
    else
      window.location.href = bookmark.href
