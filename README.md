# SessionSwizzler

SessionSwizzler is an exercise to demonstrate HTTP network call logging inside an application using an external framework.

SessionSwizzler uses [RSSwizzle](https://github.com/datatheorem/RSSwizzle) for safe method swizzling.

`URLSessionTaskMetrics` was not allowed to be used for the exercise.

`SwizzlerObjc` does the actual swizzling of `NSURLSession` while `Swizzler` does the parsing

## Requirements

`pod install`

## Usage

Build swizzle.framework and drag the framework into your application. Ensure the framework is both linked and embeded in your application.

When swizzle.framework is loaded the necessary `NSURLSession` functions will be swizzled.

You should then see an output file in your App's container directory with content similar to below:
```
https://en.wikipedia.org/api/rest_v1/feed/featured/2019/06/24, 224, https://en.wikipedia.org/api/rest_v1/feed/featured/2019/06/24, SUCCESS
https://en.wikipedia.org/api/rest_v1/feed/onthisday/events/6/24, 191, https://en.wikipedia.org/api/rest_v1/feed/onthisday/events/6/24, SUCCESS
https://en.wikipedia.org/w/api.php?action=query&exchars=525&exintro=1&exlimit=8&explaintext=&format=json&generator=random&grnfilterredir=nonredirects&grnlimit=8&grnnamespace=0&pilimit=8&piprop=thumbnail&pithumbsize=640&prop=extracts%7Cpageterms%7Cpageimages%7Cpageprops%7Crevisions&rrvlimit=1&rvprop=ids&wbptterms=description, 325, https://en.wikipedia.org/w/api.php?action=query&exchars=525&exintro=1&exlimit=8&explaintext=&format=json&generator=random&grnfilterredir=nonredirects&grnlimit=8&grnnamespace=0&pilimit=8&piprop=thumbnail&pithumbsize=640&prop=extracts%7Cpageterms%7Cpageimages%7Cpageprops%7Crevisions&rrvlimit=1&rvprop=ids&wbptterms=description, SUCCESS
https://gate.hockeyapp.net/v2/track, 159, https://gate.hockeyapp.net/v2/track, SUCCESS
```
Each line contains the URL that the task was initialized with, the time it took for the session task to complete in ms, the final URL the task was redirected to (if any), and whether the connection was successful or not.

If you are testing in the simulator, the file path will look something like `~/Library/Developer/CoreSimulator/Devices/B9DD1EA7-76A8-4BD5-8E14-749AF22A6C0A/data/Containers/Bundle/Application/B907A4B7-60AB-407F-9E92-B6E7B4794E46/Wikipedia.app/tmp`

You can see examples inside this repository with example.app or [Wikipedia.app](https://github.com/twodayslate/wikipedia-ios/tree/coding-exercise-with-swizzle)

Although this framework is supposed to be a drag-and-forget type of framework, if you have debugging capabilties you can turn off `NSURLSession` recordings using `[[SwizzlerObjc shared] stopRecording];`. Please note that this only turns of recordings, it currently does not undo the swizzling. You can start it again with `[[SwizzlerObjc shared] startRecording];`
