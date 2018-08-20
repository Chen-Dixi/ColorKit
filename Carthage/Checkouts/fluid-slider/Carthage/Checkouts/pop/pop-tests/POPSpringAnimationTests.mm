/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <OCMock/OCMock.h>

#import <QuartzCore/QuartzCore.h>

#import <XCTest/XCTest.h>

#import <pop/POPAnimation.h>
#import <pop/POPAnimationPrivate.h>
#import <pop/POPAnimator.h>
#import <pop/POPAnimatorPrivate.h>
#import <pop/POPAnimationExtras.h>

#import "POPAnimatable.h"
#import "POPAnimationInternal.h"
#import "POPAnimationTestsExtras.h"
#import "POPBaseAnimationTests.h"
#import "POPCGUtils.h"

@interface POPSpringAnimationTests : POPBaseAnimationTests
@end

@implementation POPSpringAnimationTests

static NSString *animationKey = @"key";

- (POPSpringAnimation *)_positionAnimation
{
  POPSpringAnimation *anim = [POPSpringAnimation animation];
  anim.fromValue = @0.0;
  anim.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionX];
  anim.springBounciness = 4.0;
  return anim;
}

- (void)testCompletion
{
  // animation
  // the default from, to and bounciness values are used
  NSArray *markers = @[@0.5, @0.75, @1.0];
  POPSpringAnimation *anim = [POPSpringAnimation animation];
  anim.property = [POPAnimatableProperty propertyWithName:kPOPLayerPosition];
  anim.progressMarkers = markers;
  XCTAssertEqualObjects(markers, anim.progressMarkers, @"%@ shoudl equal %@", markers, anim.progressMarkers);

  // delegate
  id delegate = [OCMockObject niceMockForProtocol:@protocol(POPAnimationDelegate)];

  // expect start, progress & stop to all be called
  [[delegate expect] pop_animationDidStart:anim];
  [[delegate expect] pop_animationDidStop:anim finished:YES];

  anim.delegate = delegate;

  // layer
  id layer = [OCMockObject niceMockForClass:[CALayer class]];

  // expect position to be called
  CGPoint position = CGPointMake(100, 100);
  position = [(CALayer *)[[layer stub] andReturnValue:OCMOCK_VALUE(position)] position];
  [layer pop_addAnimation:anim forKey:@"key"];

  POPAnimatorRenderTimes(self.animator, self.beginTime, @[@0.0, @0.1, @0.2]);
  [layer verify];
  [delegate verify];
}

- (void)testConvergence
{
  POPAnimatable *circle = [POPAnimatable new];
  POPSpringAnimation *anim = [POPSpringAnimation animation];
  anim.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionX];
  anim.fromValue = @0.0;
  anim.toValue = @100.0;
  anim.velocity = @100.0;
  anim.springBounciness = 0.5;

  POPAnimationTracer *tracer = anim.tracer;
  [tracer start];

  [circle pop_addAnimation:anim forKey:@"key"];
  POPAnimatorRenderDuration(self.animator, self.beginTime, 1.0, 1.0/60.0);
  [tracer stop];

  // finished
  POPAnimationValueEvent *stopEvent = [[tracer eventsWithType:kPOPAnimationEventDidStop] lastObject];
  XCTAssertEqualObjects(stopEvent.value, @YES, @"unexpected stop event %@", stopEvent);

  // convergence threshold
  NSArray *writeEvents = [tracer eventsWithType:kPOPAnimationEventPropertyWrite];
  NSUInteger toValueFrameCount = POPAnimationCountLastEventValues(writeEvents, anim.toValue, anim.property.threshold);
  XCTAssertTrue(toValueFrameCount < kPOPAnimationConvergenceMaxFrameCount, @"unexpected convergence; toValueFrameCount: %lu", (unsigned long)toValueFrameCount);
}

- (void)testConvergenceRounded
{
  POPAnimatable *circle = [POPAnimatable new];
  POPSpringAnimation *anim = [POPSpringAnimation animation];
  anim.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionX];
  anim.fromValue = @0.0;
  anim.toValue = @100.0;
  anim.velocity = @100.0;
  anim.springBounciness = 0.5;
  anim.roundingFactor = 1.0;

  POPAnimationTracer *tracer = anim.tracer;
  [tracer start];

  [circle pop_addAnimation:anim forKey:@"key"];
  POPAnimatorRenderDuration(self.animator, self.beginTime, 1.0, 1.0/60.0);
  [tracer stop];

  // finished
  POPAnimationValueEvent *stopEvent = [[tracer eventsWithType:kPOPAnimationEventDidStop] lastObject];
  XCTAssertEqualObjects(stopEvent.value, @YES, @"unexpected stop event %@", stopEvent);

  // convergence threshold
  NSArray *writeEvents = [tracer eventsWithType:kPOPAnimationEventPropertyWrite];
  NSUInteger toValueFrameCount = POPAnimationCountLastEventValues(writeEvents, anim.toValue);
  XCTAssertTrue(toValueFrameCount < kPOPAnimationConvergenceMaxFrameCount, @"unexpected convergence; toValueFrameCount: %lu", (unsigned long)toValueFrameCount);
}

- (void)testConvergenceClampedRounded
{
  POPAnimatable *circle = [POPAnimatable new];
  POPSpringAnimation *anim = [POPSpringAnimation animation];
  anim.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionX];
  anim.fromValue = @0.0;
  anim.toValue = @100.0;
  anim.velocity = @100.0;
  anim.springBounciness = 0.5;
  anim.roundingFactor = 1.0;
  anim.clampMode = kPOPAnimationClampEnd;

  POPAnimationTracer *tracer = anim.tracer;
  [tracer start];

  [circle pop_addAnimation:anim forKey:@"key"];
  POPAnimatorRenderDuration(self.animator, self.beginTime, 1.0, 1.0/60.0);
  [tracer stop];

  // finished
  POPAnimationValueEvent *stopEvent = [[tracer eventsWithType:kPOPAnimationEventDidStop] lastObject];
  XCTAssertEqualObjects(stopEvent.value, @YES, @"unexpected stop event %@", stopEvent);

  // convergence threshold
  NSArray *writeEvents = [tracer eventsWithType:kPOPAnimationEventPropertyWrite];
  NSUInteger toValueFrameCount = POPAnimationCountLastEventValues(writeEvents, anim.toValue);
  XCTAssertTrue(toValueFrameCount < kPOPAnimationConvergenceMaxFrameCount, @"unexpected convergence; toValueFrameCount: %lu", (unsigned long)toValueFrameCount);
}

- (void)testRemovedOnCompletionNoStartStopBasics
{
  CALayer *layer = self.layer1;
  POPSpringAnimation *anim = self._positionAnimation;
  POPAnimationTracer *tracer = anim.tracer;
  id delegate = [OCMockObject niceMockForProtocol:@protocol(POPAnimationDelegate)];

  // cleanup
  [layer pop_removeAllAnimations];

  // configure animation
  anim.removedOnCompletion = NO;
  anim.toValue = @5.0;
  anim.delegate = delegate;

  __block BOOL completionBlock = NO;
  __block BOOL completionBlockFinished = NO;
  anim.completionBlock = ^(POPAnimation *a, BOOL finished) {
    completionBlock = YES;
    completionBlockFinished = finished;
  };

  // start tracer
  [tracer start];

  // expect start and stopped
  [[delegate expect] pop_animationDidStart:anim];
  [[delegate expect] pop_animationDidStop:anim finished:YES];

  [layer pop_addAnimation:anim forKey:animationKey];
  POPAnimatorRenderDuration(self.animator, self.beginTime, 20.0, 1.0/60.0);
  NSArray *allEvents = tracer.allEvents;

  // verify delegate
  [delegate verify];
  XCTAssertTrue(completionBlock, @"completion block did not execute %@", allEvents);
  XCTAssertTrue(completionBlockFinished, @"completion block did not finish %@", allEvents);

  // assert animation has not been removed
  XCTAssertTrue(anim == [layer pop_animationForKey:animationKey], @"expected animation on layer animations:%@", [layer pop_animationKeys]);
}

- (void)testRemovedOnCompletionNoContinuations
{
  static NSString *animationKey = @"key";
  static NSArray *toValues = @[@50.0, @100.0, @20.0, @80.0];
  static NSArray *durations = @[@2.0, @0.3, @0.4, @2.0];

  CALayer *layer = self.layer1;
  POPSpringAnimation *anim = self._positionAnimation;
  POPAnimationTracer *tracer = anim.tracer;
  id delegate = [OCMockObject niceMockForProtocol:@protocol(POPAnimationDelegate)];

  // cleanup
  [layer pop_removeAllAnimations];

  // configure animation
  anim.removedOnCompletion = NO;
  anim.delegate = delegate;

  // start tracer
  [tracer start];

  __block CFTimeInterval beginTime;
  __block BOOL completionBlock = NO;
  __block BOOL completionBlockFinished = NO;

  [toValues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *ptrStop) {
    anim.toValue = obj;

    if (0 == idx) {
      [tracer reset];

      // starts and stops
      [[delegate expect] pop_animationDidStart:anim];
      [[delegate expect] pop_animationDidStop:anim finished:YES];

      anim.completionBlock = ^(POPAnimation *a, BOOL finished) {
        completionBlock = YES;
        completionBlockFinished = finished;
      };

      [layer pop_addAnimation:anim forKey:animationKey];

      beginTime = self.beginTime;
      CFTimeInterval dt = [durations[idx] doubleValue];
      POPAnimatorRenderDuration(self.animator, beginTime, dt, 1.0/60.0);
      beginTime += dt;

      NSArray *allEvents = tracer.allEvents;
      NSArray *didReachEvents = [tracer eventsWithType:kPOPAnimationEventDidReachToValue];

      // verify delegate
      [delegate verify];
      XCTAssertTrue(1 == didReachEvents.count, @"unexpected didReachEvents %@", didReachEvents);
      XCTAssertTrue(completionBlock, @"completion block did not execute %@", allEvents);
      XCTAssertTrue(completionBlockFinished, @"completion block did not finish %@", allEvents);
    } else if (toValues.count - 1 == idx) {
      // continue stoped animation
      [tracer reset];
      completionBlock = NO;
      completionBlockFinished = NO;
      [[delegate expect] pop_animationDidStop:anim finished:YES];

      CFTimeInterval dt = [durations[idx] doubleValue];
      POPAnimatorRenderDuration(self.animator, beginTime, dt, 1.0/60.0);
      beginTime += dt;

      NSArray *allEvents = tracer.allEvents;
      NSArray *didReachEvents = [tracer eventsWithType:kPOPAnimationEventDidReachToValue];

      // verify delegate
      [delegate verify];
      XCTAssertTrue(1 == didReachEvents.count, @"unexpected didReachEvents %@", didReachEvents);
      XCTAssertTrue(completionBlock, @"completion block did not execute %@", allEvents);
      XCTAssertTrue(completionBlockFinished, @"completion block did not finish %@", allEvents);
    } else {
      // continue stoped (idx = 1) or started animation
      if (1 == idx) {
        [[delegate expect] pop_animationDidStart:anim];
      }

      // reset state
      [tracer reset];
      completionBlock = NO;
      completionBlockFinished = NO;

      CFTimeInterval dt = [durations[idx] doubleValue];
      POPAnimatorRenderDuration(self.animator, beginTime, dt, 1.0/60.0);
      beginTime += dt;

      NSArray *allEvents = tracer.allEvents;
      NSArray *didReachEvents = [tracer eventsWithType:kPOPAnimationEventDidReachToValue];

      // verify delegate
      [delegate verify];
      XCTAssertTrue(1 == didReachEvents.count, @"unexpected didReachEvents %@", didReachEvents);
      XCTAssertFalse(completionBlock, @"completion block did not execute %@ %@", anim, allEvents);
      XCTAssertFalse(completionBlockFinished, @"completion block did not finish %@ %@", anim, allEvents);
    }

    // assert animation has not been removed
    XCTAssertTrue(anim == [layer pop_animationForKey:animationKey], @"expected animation on layer animations:%@", [layer pop_animationKeys]);
  }];
}

- (void)testNoOperationAnimation
{
  const CGPoint initialValue = CGPointMake(100, 100);

  CALayer *layer = self.layer1;
  layer.position = initialValue;
  [layer pop_removeAllAnimations];

  POPSpringAnimation *anim = [POPSpringAnimation animation];
  anim.property = [POPAnimatableProperty propertyWithName:kPOPLayerPosition];

  id delegate = [OCMockObject niceMockForProtocol:@protocol(POPAnimationDelegate)];
  anim.delegate = delegate;

  // starts and stops
  [[delegate expect] pop_animationDidStart:anim];
  [[delegate expect] pop_animationDidStop:anim finished:YES];

  POPAnimationTracer *tracer = anim.tracer;
  [tracer start];

  [layer pop_addAnimation:anim forKey:animationKey];
  POPAnimatorRenderDuration(self.animator, self.beginTime, 5, 1.0/60.0);

  // verify delegate
  [delegate verify];

  // verify number values
  NSArray *writeEvents = [tracer eventsWithType:kPOPAnimationEventPropertyWrite];
  for (POPAnimationValueEvent *writeEvent in writeEvents) {
    XCTAssertEqualObjects(writeEvent.value, [NSValue valueWithCGPoint:initialValue], @"unexpected write event:%@ anim:%@", writeEvent, anim);
  }
}

- (void)testLazyValueInitialization
{
  CALayer *layer = self.layer1;
  layer.position = CGPointZero;

  POPSpringAnimation *anim = [POPSpringAnimation animation];
  anim.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionX];
  anim.fromValue = @100.0;
  anim.beginTime = self.beginTime + 0.3;

  POPAnimationTracer *tracer = anim.tracer;
  [tracer start];

  // add animation, but do not start
  [layer pop_addAnimation:anim forKey:animationKey];
  POPAnimatorRenderDuration(self.animator, self.beginTime, 0.2, 1.0/60.0);
  XCTAssertNotNil(anim.fromValue, @"unexpected from value %@", anim);
  XCTAssertNil(anim.toValue, @"unexpected to value %@", anim);

  // start animation
  POPAnimatorRenderDuration(self.animator, self.beginTime + 0.2, 0.2, 1.0/60.0);
  XCTAssertNotNil(anim.fromValue, @"unexpected from value %@", anim);
  XCTAssertNotNil(anim.toValue, @"unexpected to value %@", anim);

  // continue running animation
  anim.fromValue = nil;
  anim.toValue = @200.0;
  POPAnimatorRenderDuration(self.animator, self.beginTime + 0.4, 0.2, 1.0/60.0);
  XCTAssertNotNil(anim.fromValue, @"unexpected from value %@", anim);
  XCTAssertNotNil(anim.toValue, @"unexpected to value %@", anim);
}

- (void)testLatentSpring
{
  POPSpringAnimation *translationAnimation = [POPSpringAnimation animation];
  translationAnimation.dynamicsTension = 990;
  translationAnimation.dynamicsFriction = 230;
  translationAnimation.dynamicsMass = 1.0;
  translationAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerOpacity];
  translationAnimation.removedOnCompletion = NO;
  [self pop_addAnimation:translationAnimation forKey:@"test"];
  POPAnimatorRenderDuration(self.animator, self.beginTime + 0.4, 0.2, 1.0/60.0);
}

- (void)testRectSupport
{
  const CGRect fromRect = CGRectMake(0, 0, 0, 0);
  const CGRect toRect = CGRectMake(100, 200, 200, 400);
  const CGRect velocityRect = CGRectMake(1000, 1000, 1000, 1000);

  POPSpringAnimation *anim = [POPSpringAnimation animation];
  anim.property = [POPAnimatableProperty propertyWithName:kPOPLayerBounds];
  anim.fromValue = [NSValue valueWithCGRect:fromRect];
  anim.toValue = [NSValue valueWithCGRect:toRect];
  anim.velocity = [NSValue valueWithCGRect:velocityRect];
  id delegate = [OCMockObject niceMockForProtocol:@protocol(POPAnimationDelegate)];
  anim.delegate = delegate;

  // expect start and stop to be called
  [[delegate expect] pop_animationDidStart:anim];
  [[delegate expect] pop_animationDidStop:anim finished:YES];

  // start tracer
  POPAnimationTracer *tracer = anim.tracer;
  [tracer start];

  CALayer *layer = [CALayer layer];
  [layer pop_addAnimation:anim forKey:@""];

  // run animation
  POPAnimatorRenderDuration(self.animator, self.beginTime, 3, 1.0/60.0);

  NSArray *writeEvents = [tracer eventsWithType:kPOPAnimationEventPropertyWrite];

  // verify delegate
  [delegate verify];

  POPAnimationValueEvent *lastEvent = [writeEvents lastObject];
  CGRect lastRect = [lastEvent.value CGRectValue];

  // verify last rect is to rect
  XCTAssertTrue(CGRectEqualToRect(lastRect, toRect), @"unexpected last rect value: %@", lastEvent);
}

#if TARGET_OS_IPHONE
- (void)testEdgeInsetsSupport
{
  const UIEdgeInsets fromEdgeInsets = UIEdgeInsetsZero;
  const UIEdgeInsets toEdgeInsets = UIEdgeInsetsMake(100, 200, 200, 400);
  const UIEdgeInsets velocityEdgeInsets = UIEdgeInsetsMake(1000, 1000, 1000, 1000);

  POPSpringAnimation *anim = [POPSpringAnimation animation];
  anim.property = [POPAnimatableProperty propertyWithName:kPOPScrollViewContentInset];
  anim.fromValue = [NSValue valueWithUIEdgeInsets:fromEdgeInsets];
  anim.toValue = [NSValue valueWithUIEdgeInsets:toEdgeInsets];
  anim.velocity = [NSValue valueWithUIEdgeInsets:velocityEdgeInsets];
  id delegate = [OCMockObject niceMockForProtocol:@protocol(POPAnimationDelegate)];
  anim.delegate = delegate;

  // expect start and stop to be called
  [[delegate expect] pop_animationDidStart:anim];
  [[delegate expect] pop_animationDidStop:anim finished:YES];

  // start tracer
  POPAnimationTracer *tracer = anim.tracer;
  [tracer start];

  id scrollView = [OCMockObject niceMockForClass:[UIScrollView class]];
  [scrollView pop_addAnimation:anim forKey:nil];

  // expect final value to be set
  [[scrollView expect] setContentInset:toEdgeInsets];

  // run animation
  POPAnimatorRenderDuration(self.animator, self.beginTime, 3, 1.0/60.0);

  NSArray *writeEvents = [tracer eventsWithType:kPOPAnimationEventPropertyWrite];

  // verify delegate
  [delegate verify];

  // verify scroll view
  [scrollView verify];

  POPAnimationValueEvent *lastEvent = [writeEvents lastObject];
  UIEdgeInsets lastEdgeInsets = [lastEvent.value UIEdgeInsetsValue];

  // verify last insets are to insets
  XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(lastEdgeInsets, toEdgeInsets), @"unexpected last edge insets value: %@", lastEvent);
}
#endif

- (void)testColorSupport
{
  CGFloat fromValues[4] = {1, 1, 1, 1};
  CGFloat toValues[4] = {0, 0, 0, 1};
  CGColorRef fromColor = POPCGColorRGBACreate(fromValues);
  CGColorRef toColor = POPCGColorRGBACreate(toValues);

  POPSpringAnimation *anim = [POPSpringAnimation animation];
  anim.property = [POPAnimatableProperty propertyWithName:kPOPLayerBounds];
  anim.fromValue = (__bridge_transfer id)fromColor;
  anim.toValue = (__bridge_transfer id)toColor;

  id delegate = [OCMockObject niceMockForProtocol:@protocol(POPAnimationDelegate)];
  anim.delegate = delegate;

  // start tracer
  POPAnimationTracer *tracer = anim.tracer;
  [tracer start];

  CALayer *layer = [CALayer layer];
  [layer pop_addAnimation:anim forKey:@""];

  // run animation
  POPAnimatorRenderDuration(self.animator, self.beginTime, 3, 1.0/60.0);

  NSArray *writeEvents = [tracer eventsWithType:kPOPAnimationEventPropertyWrite];

  // verify delegate
  [delegate verify];

  // expect some interpolation
  XCTAssertTrue(writeEvents.count > 1, @"unexpected write events %@", writeEvents);
  POPAnimationValueEvent *lastEvent = [writeEvents lastObject];

  // verify last written color is to color
  POPAssertColorEqual((__bridge CGColorRef)lastEvent.value, (__bridge CGColorRef)anim.toValue);
}

static BOOL _floatingPointEqual(CGFloat a, CGFloat b)
{
  CGFloat epsilon = 0.0001;
  return std::abs(a - b) < epsilon;
}

- (void)testBouncinessSpeedToTensionFrictionConversion
{
  CGFloat sampleBounciness = 12.0;
  CGFloat sampleSpeed = 5.0;

  CGFloat tension, friction, mass;
  [POPSpringAnimation convertBounciness:sampleBounciness speed:sampleSpeed toTension:&tension friction:&friction mass:&mass];

  CGFloat outBounciness, outSpeed;
  [POPSpringAnimation convertTension:tension friction:friction toBounciness:&outBounciness speed:&outSpeed];

  XCTAssertTrue(_floatingPointEqual(sampleBounciness, outBounciness) && _floatingPointEqual(sampleSpeed, outSpeed), @"(bounciness, speed) conversion failed. Mapped (%f, %f) back to (%f, %f)", sampleBounciness, sampleSpeed, outBounciness, outSpeed);
}

- (void)testTensionFrictionToBouncinessSpeedConversion
{
  CGFloat sampleTension = 240.0;
  CGFloat sampleFriction = 25.0;

  CGFloat bounciness, speed;
  [POPSpringAnimation convertTension:sampleTension friction:sampleFriction toBounciness:&bounciness speed:&speed];

  CGFloat outTension, outFriction, outMass;
  [POPSpringAnimation convertBounciness:bounciness speed:speed toTension:&outTension friction:&outFriction mass:&outMass];

  XCTAssertTrue(_floatingPointEqual(sampleTension, outTension) && _floatingPointEqual(sampleFriction, outFriction), @"(tension, friction) conversion failed. Mapped (%f, %f) back to (%f, %f)", sampleTension, sampleFriction, outTension, outFriction);
}

- (void)testRemovedOnCompletionNoContinuationValues
{
  static CGFloat fromValue = 400.0;
  static NSArray *toValues = @[@200.0, @400.0];

  // configure animation
  POPSpringAnimation *anim = self._positionAnimation;
  anim.fromValue = [NSNumber numberWithFloat:fromValue];
  anim.toValue = toValues[0];
  anim.removedOnCompletion = NO;

  // run animation, from 400 to 200
  CALayer *layer = [CALayer layer];
  [layer pop_addAnimation:anim forKey:@""];
  POPAnimatorRenderDuration(self.animator, self.beginTime, 3, 1.0/60.0);

  // assert reached to value
  XCTAssertTrue(layer.position.x == [anim.toValue floatValue], @"unexpected value:%@ %@", layer, anim);

  // start tracer
  POPAnimationTracer *tracer = anim.tracer;
  [tracer start];

  // update to value, animate from 200 to 400
  anim.toValue = toValues[1];
  POPAnimatorRenderDuration(self.animator, self.beginTime, 3, 1.0/60.0);

  // verify from 200 to 400
  NSArray *writeEvents = [tracer eventsWithType:kPOPAnimationEventPropertyWrite];
  XCTAssertTrue(writeEvents.count > 5, @"unexpected frame count %@", writeEvents);

  CGFloat firstValue = [[(POPAnimationValueEvent *)[writeEvents firstObject] value] floatValue];
  CGFloat lastValue = [[(POPAnimationValueEvent *)[writeEvents lastObject] value] floatValue];
  XCTAssertEqualWithAccuracy(((CGFloat)[toValues[0] floatValue]), firstValue, 10, @"unexpected first value %@", writeEvents);
  XCTAssertEqualWithAccuracy(((CGFloat)[toValues[1] floatValue]), lastValue, 10, @"unexpected last value %@", writeEvents);
}

- (void)testNilColor
{
  POPSpringAnimation *anim = [POPSpringAnimation animation];
  anim.property = [POPAnimatableProperty propertyWithName:kPOPLayerBackgroundColor];

#if TARGET_OS_IPHONE
  anim.toValue = (__bridge id)[UIColor redColor].CGColor;
#else
  anim.toValue = (__bridge id)[NSColor redColor].CGColor;
#endif
  
  // start tracer
  POPAnimationTracer *tracer = anim.tracer;
  [tracer start];

  // run animation
  CALayer *layer = [CALayer layer];
  [layer pop_addAnimation:anim forKey:@""];
  POPAnimatorRenderDuration(self.animator, self.beginTime, 3, 1.0/60.0);

  // verify valid from color exists
  CGColorRef fromColor = (__bridge CGColorRef)anim.fromValue;
  XCTAssertTrue(fromColor, @"unexpected value %p", fromColor);

  // verify from color clear
#if TARGET_OS_IPHONE
  POPAssertColorEqual(fromColor, [UIColor clearColor].CGColor);
#else
  POPAssertColorEqual(fromColor, [NSColor clearColor].CGColor);
#endif
}

- (void)testExcessiveJumpInTime
{
  POPSpringAnimation *anim = self._positionAnimation;
  anim.toValue = @(1000.0);

  // start tracer
  POPAnimationTracer *tracer = anim.tracer;
  [tracer start];

  id delegate = [OCMockObject niceMockForProtocol:@protocol(POPAnimationDelegate)];
  anim.delegate = delegate;
  
  // expect start and stop to be called
  [[delegate expect] pop_animationDidStart:anim];
  [[delegate expect] pop_animationDidStop:anim finished:YES];

  CALayer *layer = [CALayer layer];
  [layer pop_addAnimation:anim forKey:animationKey];

  // render with large time jump
  POPAnimatorRenderTimes(self.animator, self.beginTime, @[@0.0, @0.01, @300]);

  // verify start stop
  [delegate verify];

  // verify last write event value
  POPAnimationValueEvent *writeEvent = [[tracer eventsWithType:kPOPAnimationEventPropertyWrite] lastObject];
  XCTAssertEqualObjects(writeEvent.value, anim.toValue, @"unexpected last write event %@", writeEvent);
}

- (void)testEquivalentFromToValues
{
  POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
  anim.fromValue = [NSValue valueWithCGPoint:CGPointZero];
  anim.toValue = [NSValue valueWithCGPoint:CGPointZero];
  anim.velocity = [NSValue valueWithCGPoint:CGPointMake(1000.0, 1000.0)];

  // start tracer
  POPAnimationTracer *tracer = anim.tracer;
  [tracer start];

  // run animation
  CALayer *layer = [CALayer layer];
  [layer pop_addAnimation:anim forKey:@""];
  POPAnimatorRenderDuration(self.animator, self.beginTime, 3, 1.0/60.0);

  // verify last write event value
  POPAnimationValueEvent *writeEvent = [[tracer eventsWithType:kPOPAnimationEventPropertyWrite] lastObject];
  XCTAssertEqualObjects(writeEvent.value, anim.toValue, @"unexpected last write event %@", writeEvent);
}

- (void)testNSCopyingSupportPOPSpringAnimation
{
  POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:@"asdf_asdf_asdf"];
  
  configureConcretePropertyAnimation(anim);
  
  anim.velocity = @(4321);
  anim.springBounciness = 11.1;
  anim.springSpeed = 12;
  anim.dynamicsTension = 0.83;
  anim.dynamicsFriction = 0.97;
  anim.dynamicsMass = 100;
  
  POPSpringAnimation *copy = [anim copy];
  
  XCTAssertEqualObjects(copy.velocity, anim.velocity, @"expected equality; value1:%@ value2:%@", copy.velocity, anim.velocity);
  XCTAssertEqual(copy.springBounciness, anim.springBounciness, @"expected equality; value1:%@ value2:%@", @(copy.springBounciness), @(anim.springBounciness));
  XCTAssertEqual(copy.springSpeed, anim.springSpeed, @"expected equality; value1:%@ value2:%@", @(copy.springSpeed), @(anim.springSpeed));
  XCTAssertEqual(copy.dynamicsTension, anim.dynamicsTension, @"expected equality; value1:%@ value2:%@", @(copy.dynamicsTension), @(anim.dynamicsTension));
  XCTAssertEqual(copy.dynamicsFriction, anim.dynamicsFriction, @"expected equality; value1:%@ value2:%@", @(copy.dynamicsFriction), @(anim.dynamicsFriction));
  XCTAssertEqual(copy.dynamicsMass, anim.dynamicsMass, @"expected equality; value1:%@ value2:%@", @(copy.dynamicsMass), @(anim.dynamicsMass));
}

@end
