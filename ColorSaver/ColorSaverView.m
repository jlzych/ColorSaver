//
//  ColorSaverView.m
//  ColorSaver
//
//  Created by Jeff Zych on 1/24/16.
//  Copyright © 2016 Chaos Theory Studios. All rights reserved.
//

#import "ColorSaverView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ColorSaverView

float animationTimeInterval = 1.0;

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:animationTimeInterval];
        
        // Set up the layer so we can transition the color change
        self.layer = [CALayer layer];
        self.layer.delegate = self;
        self.layer.needsDisplayOnBoundsChange = YES;
        self.layer.frame = NSRectToCGRect(self.bounds);
        self.wantsLayer = YES;
        
        // Need this so that the background color is set when the
        // screen saver starts, rather than being transparent
        [self.layer setNeedsDisplay];
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    // Get the hour, minute, and second time components
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:now];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger seconds = [components second];
    
    // Get the color we're transitioning to
    NSColor *toColor = [NSColor colorWithDeviceRed:hour/23.0 green:minute/59.0 blue:seconds/59.0 alpha:1.0];
    
    // Set up the animation
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    fadeAnim.toValue = toColor;
    fadeAnim.duration = animationTimeInterval;
    [self.layer addAnimation:fadeAnim forKey:@"backgroundColor"];
    
    [self.layer setBackgroundColor: toColor.CGColor];
}

- (void)animateOneFrame
{
    [self.layer setNeedsDisplay];
}

- (BOOL)isOpaque
{
    return YES;
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
