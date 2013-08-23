MPMoviePlayerController-CurrentPlybackTimeMonitor
=================================================

MPMoviePlayer category to monitor current play back time.

#How To:

Import the category in your .m file:

```objc
#import "MPMoviePlayerController+CurrentPlaybackTimeMonitor.h"
```


Simply call the currentTimeMonitor method:

```objc
[self.moviePlayerController currentTimeMonitor:^{
  NSLog(@"Current time %i",[moviePlayerController.lastRecordedPlaybackTime intValue]);            
}];
```

To stop monitoring:

```objc
[self.moviePlayerController endPlayerPolling];
```
