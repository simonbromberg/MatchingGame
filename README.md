# MatchingGame

You can try this package out by using [Swift Playgrounds](https://apps.apple.com/ca/app/swift-playgrounds/id908519492) on an iPad.

1. Create a new project in Swift Playgrounds
2. [Add a Swift Package](https://developer.apple.com/documentation/swift-playgrounds/add-a-swift-package) using the URL of this repository
3. In `MyApp.swift` add `import MatchingGame` at the top and replace `ContentView` with `MatchingContentView(matchables: <your array of matchables>, squareSize: <desired square size>)`

You can use any type as a `Matchable`. The library includes extensioins for `Character` and `UIImage`. For example, you can use the built-in array of emojis:

```swift
MatchingContentView(matchables: Character.emojis, squareSize: 100)
```
