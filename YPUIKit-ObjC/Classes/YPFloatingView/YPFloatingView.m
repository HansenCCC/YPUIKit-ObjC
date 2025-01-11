//
//  UIView+YPExtension.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/7/13.
//

#import "YPFloatingView.h"

@interface YPFloatingView ()

@property (nonatomic, assign) CGPoint startLocation;

@end

@implementation YPFloatingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickAction)];
        [self addGestureRecognizer:tapGesture];

        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:panGesture];
        self.startLocation = self.frame.origin;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:self.superview];
    CGRect frame = self.frame;
    frame.origin.x = self.startLocation.x + translation.x;
    frame.origin.y = self.startLocation.y + translation.y;

    CGRect parentBounds = self.superview.bounds;
    if (frame.origin.x < 0) frame.origin.x = 0;
    if (frame.origin.y < 0) frame.origin.y = 0;
    if (frame.origin.x + frame.size.width > parentBounds.size.width) frame.origin.x = parentBounds.size.width - frame.size.width;
    if (frame.origin.y + frame.size.height > parentBounds.size.height) frame.origin.y = parentBounds.size.height - frame.size.height;
    
    self.frame = frame;
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.startLocation = self.frame.origin;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.didMoveCallback) {
            self.didMoveCallback(self.frame.origin);
        }
    });
}

- (void)didClickAction {
    if (self.didClickCallback) {
        self.didClickCallback();
    }
}

- (CGPoint)currentLocation {
    return self.frame.origin;
}

- (void)setCurrentLocation:(CGPoint)currentLocation {
    CGRect frame = self.frame;
    frame.origin = currentLocation;
    self.frame = frame;
}

@end
