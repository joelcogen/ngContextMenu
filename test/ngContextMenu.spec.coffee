# @todo add document click && offset position
describe('ngContextMenu', () ->
  $compile = null
  $rootScope = null
  element = null
  currentItem = {}

  lists = [
    {
      name: 'list1'
      value: 1
    }
    {
      name: 'list2'
      value: 2
    }
  ]

  clickMenu = (item) ->
    currentItem = item

  beforeEach(() ->
    module('ngContextMenu')
    inject(($injector) ->
      $compile = $injector.get('$compile')
      $rootScope = $injector.get('$rootScope')
    )
  )

  describe('render', () ->
    beforeEach(() ->
      $rootScope.lists = lists
      element = $($compile('<div contextmenu="{{lists}}"></div>')($rootScope))
      $rootScope.$digest()
    )

    it 'should create dropdown-menu', () ->
      expect(element.find('.ng-context-menu').length).toEqual(1)

    it 'should create two item', () ->
      expect(element.find('.dropdown-menu > li').length).toEqual(2)
  )

  describe('render with no list', () ->
    beforeEach(() ->
      element = $($compile('<div contextmenu></div>')($rootScope))
      $rootScope.$digest()
    )
    
    it 'should no list', () ->
      expect(element.find('.dropdown-menu > li').length).toEqual(0)
  )

  describe('rightClick', () ->
    beforeEach(() ->
      $rootScope.lists = lists
      $rootScope.rightClick = jasmine.createSpy('rightClick')
      element = $($compile('<div contextmenu="{{lists}}" right-click="rightClick($event)"></div>')($rootScope))
      $rootScope.$digest()
    )

    it 'should show drop-menu with element right click', () ->
      element.contextmenu()

      expect(element.find('.ng-context-menu').hasClass('open')).toBe(true)

    it 'should call right click', () ->
      element.contextmenu()
      console.log $rootScope.rightClick.calls
      expect($rootScope.rightClick).toHaveBeenCalled()
  )

  describe('clickItem', () ->
    beforeEach(() ->
      $rootScope.lists = lists
      $rootScope.clickMenu = clickMenu
      element = $($compile('<div contextmenu="{{lists}}" click-menu="clickMenu(item)"></div>')($rootScope))
      $rootScope.$digest()
    )

    it 'should hide dropmenu with item click', () ->
      element.contextmenu()
      element.find('.dropdown-menu li').eq(1).click()

      expect(currentItem.value).toEqual(2)
      currentItem = {}
  )

  describe('position', () ->
    beforeEach(() ->
      $rootScope.lists = lists
      element = $compile('<div contextmenu></div>')($rootScope)
      element.css({
        top: 0
        left: 0
      })
      $rootScope.$digest()
    )

    it 'should show fixed position', () ->
      element.find('.ng-context-menu').trigger({
        type: 'contextmenu'
        clientX: 100
        clientY: 200
      })

      expect(element.find('.ng-context-menu').css('top')).toEqual('200px')
      expect(element.find('.ng-context-menu').css('left')).toEqual('100px')
  )
)
