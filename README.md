### Router

A micro routing library written in swift, primarily for deep linking use cases

### Installation

- Coming soon

### Requirements

- iOS 7.0+ / Mac OS X 10.9+
- Xcode 6.3

### Usage

```swift
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

### 
