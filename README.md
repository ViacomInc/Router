### Router

A micro routing library written in swift, primarily for deep linking use cases

## Installation

> **Embedded frameworks require a minimum deployment target of iOS 8.**
>
> Integration can be done either Manually or through Cocoapods **eventually** 
> 

### Cocoapods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

CocoaPods 0.36 adds supports for Swift and embedded frameworks. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Router into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/R3dTeam/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'Router', '~> 0.1'
```

Then, run the following command:

```bash
$ pod install
```

### Requirements

- iOS 7.0+
- Xcode 6.3
- Swift 1.2
- Cocoapods 0.36+ (Optional)

### Simple Usage

```swift
import Router

// create your router
let router: Router = Router()

// bind your routes with a callback
router.bind("/route/:id") { (req) -> Void in
    println(req.param("id")!)
}

// match a route
let url = NSURL(string: "routerapp://route/abc123")!
var route = router.match(url)
```

### Route binding

Bind a closure to a route definition

```swift
router.bind("/route/:id") { (req) -> Void in
    println(req.param("id")!)
}
```

### Route Matching

Matches an incoming url to a route in the Router. If a match is made, the closure is executed and the matched route is returned

```swift
let url = NSURL(string: "routerapp://route/abc123")!
var route = router.match(url)
```


### Request Object

A request object is accessible in the closure arg. Access url params in the closure (ie. id from /route/:id) by using ```.param()``` function

```swift
router.bind("/route/:id") { (req) -> Void in
	let id = req.param("id")!
}
```

Access query string params from the callback (ie. /route/123?foo=bar) by using ```.query()``` function

```swift
router.bind("/route/:id") { (req) -> Void in
	let foo = req.query("foo")! 
}
```

### Deeplinking to the Sample app

- Install the RouterExample app
- Close the app
- Open safari
- Type routerapp://route/one into the address bar to access View One
- Exit out of the app
- Type routerapp://route/one/abc123 into the address bar to access View Two

### Found a bug?

- Open up an issue
- Write test(s) that reproduce the issue
- Fix the issue
- Send a Pull Request

### Want a feature request?

- Open up an Issue
- Write test(s) around the new feature
- Implement the feature
- Send a Pull Request

## License

Licensed under the Apache License, Version 2.0. See LICENSE for details.
