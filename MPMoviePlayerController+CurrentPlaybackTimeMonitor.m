//
//  MPMoviePlayerController+CurrentPlaybackTimeMonitor.m
//  
//
//  Created by alban perli on 11/10/12.
//  Copyright (c) 2012 ALBAN. All rights reserved.
//

#import "MPMoviePlayerController+CurrentPlaybackTimeMonitor.h"


@interface UIView (MonitorCurrentTimeBlocks_Private)

- (void)runBlockForKey:(void *)blockKey;
- (void)setBlock:(MonitorCurrentTimeBlock)block forKey:(void *)blockKey;

@end

@implementation MPMoviePlayerController (CurrentPlaybackTimeMonitor)


// @ synthesise

@dynamic pollPlayerTimer,lastRecordedPlaybackTime;

static char kLastRecordedPlaybackTime;
static char kPollPlayerTimer;

- (void)setLastRecordedPlaybackTime:(NSNumber *)lastRecordedtime
{
	objc_setAssociatedObject(self, &kLastRecordedPlaybackTime, lastRecordedtime, OBJC_ASSOCIATION_COPY);
}

- (NSNumber*)lastRecordedPlaybackTime
{
	return objc_getAssociatedObject(self, &kLastRecordedPlaybackTime);
}

- (void)setPollPlayerTimer:(NSTimer *)newTimer
{
	objc_setAssociatedObject(self, &kPollPlayerTimer, newTimer, OBJC_ASSOCIATION_ASSIGN);
}

- (NSTimer*)pollPlayerTimer
{
	return objc_getAssociatedObject(self, &kPollPlayerTimer);
}



//----------------------------

static char kCurrentTimeMonitorBlockKey;

- (void)runBlockForKey:(void *)blockKey {
    MonitorCurrentTimeBlock block = objc_getAssociatedObject(self, blockKey);
    if (block) block();
}

- (void)setBlock:(MonitorCurrentTimeBlock)block forKey:(void *)blockKey {
    objc_setAssociatedObject(self, blockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}



-(void)currentTimeMonitor:(MonitorCurrentTimeBlock)block{
    [self beginPlayerPolling];

    [self setBlock:block forKey:&kCurrentTimeMonitorBlockKey];    
}



- (void) beginPlayerPolling {
    
    NSTimer *tmpTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                         target:self
                                                       selector:@selector(pollPlayerTimer_tick:)
                                                       userInfo:nil
                                                        repeats:YES];
    
    self.pollPlayerTimer = tmpTimer;
    
}

- (void) pollPlayerTimer_tick:(NSObject *)sender {
    // Store current playback position
    if (self.playbackState == MPMoviePlaybackStatePlaying){
        self.lastRecordedPlaybackTime = [NSNumber numberWithFloat:self.currentPlaybackTime];
        [self runBlockForKey:&kCurrentTimeMonitorBlockKey];
    }
}

- (void) endPlayerPolling {
    if (self.pollPlayerTimer != nil)
    {
        [self.pollPlayerTimer invalidate];
        self.pollPlayerTimer = nil;
    }
}

@end
