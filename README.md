# ``SolidScroll``

A liberated `_ScrollView` and `_PagingView` of **SwiftUI**.

## Overview

**SolidScroll** allows to unlock the potential of the scroll view in SwiftUI.

Unlike the regular SwiftUI `ScrollView` and `ScrollViewProxy`, the hidden SwiftUI `_ScrollView` and `_ScrollViewProxy` types allow to get near-UIScrollView control over the status of scrolling in real time, content insets, animate content offset, and much more.

**SolidScroll** is a set of type aliases to SwiftUI hidden types, and couple of helper initializers for the convinience.

Also, the library contains docc-compatible documentation where each type alias is represented with the hidden interface of the aliased type.

### Advanced scroll view use-cases

SwiftUI has a hidden `_ContainedScrollViewKey` type, which is actually a not-publicly-conformed `PreferenceKey` type.
This preference reports the `_ScrollViewProxy` where all functionality of the `_ScrollView` is unlocked.
In order to get the proxy, simply create `SolidScrollView` in the `body` of your view, then store the proxy in a `@State`, as shown in the following example:

```swift
import SolidScroll

struct ContentView: View {
  var config = ScrollViewConfig()
  @State var scrollViewProxy: SolidScrollViewProxy?

  var body: some View {
    VStack(spacing: 0) {
      SolidScrollView(config) {
        VStack(spacing: 0) {
          Color.red.frame(height: 200)
          Color.green.frame(height: 200)
          Color.blue.frame(height: 200)
          Color.black.frame(height: 200)
        }
      }
      Button("Scroll to 3/4 of the content height via proxy") {
        guard let scrollViewProxy = scrollViewProxy else { return }
        let contentOffset = CGPoint(x: 0, y: min(scrollViewProxy.contentSize.height * 3.0 / 4, scrollViewProxy.maxContentOffset.y))
        scrollViewProxy.setContentOffset(contentOffset, animated: true, completion: { completed in
          print("Scrolled via proxy to \(contentOffset)! Completed: \(completed)")
        })
      }
    }
    .onPreferenceChange(ContainedScrollViewKey.self) {
      scrollViewProxy = $0
    }
  }
}
```

### Advanced scroll view use-cases with paging

For paging, SwiftUI has a different hidden type called `_PagingView`. It's a wrapper on scroll view that supports paging.
The direction of the scrolling and the size of the page in the scrolling direction is controlled by `_PagingViewConfig`.
All pages take the same size. If size is `nil`, page takes the full available width or height on the screen (in correspondance with the scroll direction).
It's useful for implementation of custom tab bar, image carousel or other pagination behavior.
The usage example is shown below.

```swift
import SolidScroll

struct PagingContentView: View {
  @State var currentPage: Int = 0
  let config: PagingViewConfig

  init() {
    var config = PagingViewConfig()
    config.direction = .horizontal
    config.size = 100
    config.margin = 0
    config.spacing = 0
    self.config = config
  }

  var body: some View {
    PagingView(config: config, page: $currentPage, views: Array(0...10).map { page(at: $0) })
  }

  @ViewBuilder
  func page(at index: Int) -> some View {
    Text("Page \(index)")
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(backgroundColor(at: index))
  }

  func backgroundColor(at index: Int) -> Color {
    let indexMod = (index % 3)
    switch indexMod {
    case 0: return Color.red
    case 1: return Color.green
    case 2: return Color.blue
    default: return Color.clear
    }
  }
}
```

## Demo of the library 

[![SolidScroll Demo on YouTube](https://img.youtube.com/vi/pFJ6qUyZ43E/sddefault.jpg)](https://youtu.be/pFJ6qUyZ43E)


## Installation

### Xcode 13

1. Select your project in File Navigator, then select the project again on top of the list of targets. You'll see list of packages.
2. Press ＋ button.
3. In the appeared window, press ＋ button in the bottom left corner.
4. In the appeared menu, select "Add Swift Package Collection"
5. In the appeared dialog, enter package collection URL: [https://swiftpackageindex.com/edudnyk/collection.json](https://swiftpackageindex.com/edudnyk/collection.json)
6. Press "Add Collection"
7. Select **SolidScroll** package from the collection.


If you want to use **SolidScroll** in any other project that uses SwiftPM, add the package as a dependency in `Package.swift`:

```swift
dependencies: [
  .package(name: "SolidScroll", url: "https://github.com/edudnyk/SolidScroll.git", from: "0.0.1"),
]
```

Next, add **SolidScroll** as a dependency of your test target:

```swift
targets: [
  .target(name: "MyApp", dependencies: ["SolidScroll"], path: "Sources"),
]
```

### Carthage

If you use Carthage, you can add the following dependency to your Cartfile:

```
github "edudnyk/SolidScroll" ~> 0.0.1
```

### CocoaPods

If your project uses CocoaPods, add the pod to any applicable targets in your Podfile:

```ruby
target 'MyApp' do
  pod 'SolidScroll', '~> 0.0.1'
end
```

