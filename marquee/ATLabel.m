//
//  ATLabel.m
//
// Created by Karthikeya Udupa on 7/14/13.
// Copyright (c) 2012 Karthikeya Udupa K M All rights reserved.

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "ATLabel.h"

typedef void(^dispatch_cancelable_block_t)(BOOL cancel);

@interface ATLabel()
{
    dispatch_cancelable_block_t block;
    dispatch_cancelable_block_t block2;
}
@end

@implementation ATLabel

@synthesize wordList = _wordList;
@synthesize duration = _duration;

dispatch_cancelable_block_t dispatch_after_delay(CGFloat delay, dispatch_block_t block)
{
    if (block == nil) {
        return nil;
    }
    
    dispatch_queue_t q_background                       = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    __block dispatch_cancelable_block_t cancelableBlock = nil;
    __block dispatch_block_t originalBlock              = [block copy];
    
    dispatch_cancelable_block_t delayBlock = ^(BOOL cancel){
        if (cancel == NO && originalBlock) {
            dispatch_async(q_background, originalBlock);
        }
        originalBlock   = nil;
        cancelableBlock = nil;
    };
    
    cancelableBlock = [delayBlock copy];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), q_background, ^{
        if (cancelableBlock) {
            cancelableBlock(NO);
        }
    });
    
    return cancelableBlock;
}

void cancel_block(dispatch_cancelable_block_t block)
{
    if (block == nil) {
        return;
    }
    
    block(YES);
}

- (void)animateWithWords:(NSArray *)words forDuration:(double)time
{
    [self animateWithWords:words
               forDuration:time
             withAnimation:ATAnimationTypeFadeInOut];
}

- (void)animateWithWords:(NSArray *)words
             forDuration:(double)time
           withAnimation:(ATAnimationType)animation
{
    self.duration       = time;
    self.animationType  = animation;
    self.wordList       = [[NSArray alloc] initWithArray:words];
    self.text           = self.wordList[0];
    
    [self startAnimation];
}

- (void)startAnimation
{
    block = dispatch_after_delay(self.duration, ^(void){
        [self performSelectorOnMainThread:@selector(animate) withObject:nil waitUntilDone:YES];
        block2 = dispatch_after_delay(self.duration, ^(void){
            [self startAnimation];
        });
    });
}

- (void)animate
{
    int idx = [self.wordList indexOfObject:self.text];
    idx++;
    if (idx == self.wordList.count) {
        idx = 0;
    }
    //NSLog(@"%@", self.wordList[idx]);
    
    CGRect __block originalSize;
    if (self.animationType == ATAnimationTypeFadeInOut) {
        [UIView animateWithDuration:self.duration / 2
                         animations:^{ self.alpha = 0.0; }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:self.duration / 2
                                              animations:^{
                                                  self.alpha    = 1.0;
                                                  
                                                  if (idx >= self.wordList.count) {
                                                      self.text     = @"";
                                                  } else {
                                                      self.text     = self.wordList[idx];
                                                  }
                                              }
                                              completion:nil];
                         }];
        
    } else {
        [UIView animateWithDuration:self.duration / 2
                         animations:^{
                             self.alpha         = 0.0;
                             CGRect fullSize    = self.frame;
                             originalSize       = self.frame;
                             
                             switch (self.animationType) {
                                 case ATAnimationTypeSlideTopInTopOut:
                                     fullSize.origin.y -= fullSize.size.height/4;
                                     break;
                                 case ATAnimationTypeSlideBottomtInBottomOut:
                                     fullSize.origin.y += fullSize.size.height/4;
                                     break;
                                 case ATAnimationTypeSlideTopInBottomOut:
                                     fullSize.origin.y += originalSize.size.width/4;
                                     break;
                                 case ATAnimationTypeSlideBottomInTopOut:
                                     fullSize.origin.y -= originalSize.size.width/4;
                                     break;
                                 case ATAnimationTypeSlideRightInRightOut:
                                 case ATAnimationTypeSlideLeftInRightOut:
                                     fullSize.origin.x += originalSize.size.width/2;
                                     break;
                                 case ATAnimationTypeSlideLeftInLeftOut:
                                 case ATAnimationTypeSlideRightInLeftOut:
                                     fullSize.origin.x -= originalSize.size.width/2;
                                     break;
                                 default:
                                     break;
                             }
                             
                             self.frame = fullSize;
                         }
                         completion:^(BOOL finished) {
                             CGRect fullSize = self.frame;
                             switch (self.animationType) {
                                 case ATAnimationTypeSlideTopInBottomOut:
                                     fullSize.origin.y = originalSize.origin.y;
                                     fullSize.origin.y -= originalSize.size.height/4;
                                     break;
                                 case ATAnimationTypeSlideBottomInTopOut:
                                     fullSize.origin.y = originalSize.origin.y;
                                     fullSize.origin.y += originalSize.size.height/4;
                                     break;
                                 case ATAnimationTypeSlideLeftInRightOut:
                                     fullSize.origin.x -= 2 * originalSize.size.width/4;
                                     break;
                                 case ATAnimationTypeSlideRightInLeftOut:
                                     fullSize.origin.x += 2 * originalSize.size.width/4;
                                     break;
                                 default:
                                     break;
                             }
                             self.frame = fullSize;
                             
                             [UIView animateWithDuration:self.duration / 2
                                              animations:^{
                                                  self.alpha        = 1.0;
                                                  CGRect fullSize   = self.frame;
                                                  fullSize          = originalSize;
                                                  self.frame        = fullSize;
                                                  
                                                  if (idx >= self.wordList.count) {
                                                      self.text     = @"";
                                                  } else {
                                                      self.text     = self.wordList[idx];
                                                  }
                                              }
                                              completion:nil];
                         }];
    }
}

- (void)stopAnimation
{
    cancel_block(block);
    cancel_block(block2);
}

@end