//
//  MPMoviePlayerController+CurrentPlaybackTimeMonitor.h
//  
//
//  Created by alban perli on 11/10/12.
//  Copyright (c) 2012 ALBAN. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

typedef void (^MonitorCurrentTimeBlock)();

@interface MPMoviePlayerController (CurrentPlaybackTimeMonitor)

/**
 *    Timer
 */
@property (nonatomic) NSTimer *pollPlayerTimer;

/**
 *    The current play back time
 */
@property (nonatomic) NSNumber *lastRecordedPlaybackTime;


- (void)currentTimeMonitor:(MonitorCurrentTimeBlock)block;

- (void)endPlayerPolling;

- (void) beginPlayerPolling;

@end
