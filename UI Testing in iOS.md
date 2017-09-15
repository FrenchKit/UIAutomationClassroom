# UI Testing in iOS

## Basics

UI testing with XCUITest allows you to cover your app with UI tests that mimic user behavior on Simulator or a real device.

You write UI tests using XCTest library. Main classes that you will be using are the following.

### XCUIApplication 
proxy for your app under test

    launch() - launches the app
    
    let app = XCUIApplication()
    app.launch()
    
### XCUIElement
proxy for a visible element on the screen.

    // exists - whether it exists
    // isHittable - whether it can be tapped
    // tap() - taps the element
    
    let button = app.buttons["myButton"]
    if button.exists && button.isHittable {
        button.tap()
    }
    
    // swipeUp|Down|Left|Right() - swipes on the element
    // label - accessibility label
    // identifier - accessibility identifier
    // value - accessibility value
    
    app.swipeUp()
    let colorLabel = app.staticTexts["color"]
    XCTAssertEqual(colorLabel.value as? String, "red")
    
    let buyButton = app.buttons["buyButton"]
    XCTAssertEqual(buyButton.label "Buy")

### XCUIElementQuery
encapsulates a query to find elements on the screen

    // element - returns the element
    
    let navBar = app.navigationBars.element
    
    // element(boundBy: <index>) - element at index
    
    let firstCell = app.tableViews.element.cells.element(boundBy: 0)
    
    // [<identifier|label>] - returns element by identifier or label, 
    //    like buttons["close"] returns button with "close" label or identifier.
    //    Raises exception if multiple elements found with the same value.
        
    let button = app.buttons["myButton"]
    let label = app.staticTexts["Help"]

### Common UI elements
    
    .buttons 
    .staticTexts
    .images
    .tableViews
    .collectionViews
    .cells

### Making your app UI-testable
* Adding identifier to buttons, images, and other elements
* Localization - use identifiers

* accessibilityIdentifier
* accessibilityLabel
* accessibilityElements

## Writing your test
* Using XCTAssert* assertions
* Arrange, Act, Assert
* One test does one (logical) thing
* Handy assertion to wait until exists instead of sleep
* Using screen objects
* Organizing your test code and reusing some pieces.
* Utility methods for tests.

## App launch arguments
* You can pass arguments to your app on XCUIApplication.launch() and parse them from ProcessArguments object accessible in your app.
* This is a way to turn on / turn off some functionality for UI testing, like mock servers or A/B testing.

## Table views and Collection views
* Cells are opaque to UI test system by default, you have to implement accessiblity container protocol for cells.
* Only cells that are visible on screen exist. If you have 100 items in a table, 4 items fitting on the screen, when you scroll and query tableView for cells it will always return 4 visible cells. 
* Add index/indexPath to accessibility identifier of cell. 
* You have to scroll until some element is visible or hittable.
* When working with XCUIElement cells, convert them to Cell objects for better code.
* allElementsBoundByIndex

## Screen sizes
* Different screen size may have different behavior, hence your UI test for one screen size may fail for another. 
* Screen objects are useful to encapsulate the difference on the screen. If your objects for the same screen will have same interface, you can use the same test for different screen sizes.

## Localizations
* Using buttons' or static text's labels might be a bad idea if you are testing for multiple localizations. Either you need to include localized strings bundle in your tests and use localization keys or use accessiblity identifiers to locate screen elements in any locale.

## Working with network
* If your app works with network, mocking the network communication might be beneficial for tests stability - same input will have same output. One might create a mock server (Sinatra app) and use it during UI testing in the app instead of real servers. 
* Another approach - override URLSessionProtocol to return mock responses.

## Cloud testing
In case you want to test your app on different devices, you can use TestDroid, Xamarin Test Cloud or Amazon Device Cloud

* [http://testcloud.xamarin.com](http://testcloud.xamarin.com)
* [https://bitbar.com](https://bitbar.com)

## Online resources
[https://github.com/joemasilotti/UI-Testing-Cheat-Sheet](https://github.com/joemasilotti/UI-Testing-Cheat-Sheet)

