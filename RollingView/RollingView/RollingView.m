//
//  RollingView.m
//  RollingView
//
//  Created by kim sunchul on 2018. 11. 24..
//  Copyright © 2018년 tronplay. All rights reserved.
//

#import "RollingView.h"

@implementation RollingView

- (void)dealloc {
    [_view release];
    [_viewArray release];
    [super dealloc];
}

- (instancetype)init
{
    self = [self initWithFrame:[[[UIApplication sharedApplication] keyWindow] bounds]];
    if (self) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setNib];
        [self setUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setNib];
        [self setUI];
    }
    return self;
}

- (void)setNib{
    _view = [[[NSBundle mainBundle] loadNibNamed:@"RollingView" owner:self options:nil] objectAtIndex:0];
    [_view setFrame:CGRectMake(0, 0, [self frame].size.width, [self frame].size.height)];
    [self addSubview:_view];
    [self setConstraint:_view];
}

- (void)setUI{
    _animationDelay = 1.0;
    _waitDelay = 1.5;
}

- (void)setConstraint:(UIView *)view {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    //xib view autolayout setting
    NSLayoutConstraint *viewWidth =  [NSLayoutConstraint constraintWithItem:view
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:1
                                                                   constant:0];
    
    NSLayoutConstraint *viewHeight =  [NSLayoutConstraint constraintWithItem:view
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeHeight
                                                                  multiplier:1
                                                                    constant:0];
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:view
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1
                                                                constant:0];
    
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:view
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1
                                                                constant:0];

    [self addConstraints:[NSArray arrayWithObjects:viewWidth,viewHeight,centerX,centerY,nil]];
}

- (void)setViewArray:(NSMutableArray *)viewArray {
    [_viewArray release];
    _viewArray = viewArray;
    [_viewArray retain];
    [self updateUI];
}

- (void)updateUI {
    index = 0;
    currentView = [_viewArray objectAtIndex:index];
    [self addViewWithConstraint:currentView identifier:@"currentTopConstraint"];
   
    index++;
    nextView = [_viewArray objectAtIndex:index];
    [self addViewWithConstraint:nextView identifier:@"nextTopConstraint"];
}

- (void)startAnimation {
    [self rollingAnimation];
    isStopAnimation = NO;
}

- (void) stopAnimation {
    isStopAnimation = YES;
}

- (void)rollingAnimation {
    if (isStopAnimation) {
        return;
    }
    
    NSLayoutConstraint *currentTopConstraint = [self findViewHeightConstraint:_view identifier:@"currentTopConstraint"];
    NSLayoutConstraint *nextTopConstraint = [self findViewHeightConstraint:_view identifier:@"nextTopConstraint"];
    [currentTopConstraint setConstant:0];
    [nextTopConstraint setConstant:_view.frame.size.height];
    [currentView setAlpha:1];
    [nextView setAlpha:0];
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:_animationDelay
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^(void) {
                         [currentTopConstraint setConstant:-_view.frame.size.height];
                         [nextTopConstraint setConstant:0];
                         [currentView setAlpha:0];
                         [nextView setAlpha:1];
                         [self layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [self setNextView];
                         [self performSelector:@selector(rollingAnimation) withObject:nil afterDelay:_waitDelay];
                     }];
}

-(void)setNextView {
    [currentView removeFromSuperview];
    currentView = nextView;
    NSLayoutConstraint *nextTopConstraint = [self findViewHeightConstraint:_view identifier:@"nextTopConstraint"];
    [nextTopConstraint setIdentifier:@"currentTopConstraint"];
    
    index++;
    if (index == _viewArray.count) {
        index = 0;
    }
    
    nextView = [_viewArray objectAtIndex:index];
    [self addViewWithConstraint:nextView identifier:@"nextTopConstraint"];
    nextTopConstraint = [self findViewHeightConstraint:_view identifier:@"nextTopConstraint"];
    [nextTopConstraint setConstant:_view.frame.size.height];
}

-(void)addViewWithConstraint:(UIView *)view identifier:(NSString *)identifier {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [_view addSubview:view];

    NSLayoutConstraint *viewWidth =  [NSLayoutConstraint constraintWithItem:view
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_view
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:1
                                                                   constant:0];
    
    NSLayoutConstraint *viewHeight =  [NSLayoutConstraint constraintWithItem:view
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_view
                                                                   attribute:NSLayoutAttributeHeight
                                                                  multiplier:1
                                                                    constant:0];
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:view
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_view
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1
                                                                constant:0];
    
    NSLayoutConstraint *top =  [NSLayoutConstraint constraintWithItem:view
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_view
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:0];
    [top setIdentifier:identifier];
    [_view addConstraints:[NSArray arrayWithObjects:viewWidth,viewHeight,top,centerX,nil]];
}

- (NSLayoutConstraint *) findViewHeightConstraint:(UIView *)view identifier:(NSString *)identifier{
    NSLayoutConstraint *findConstraint = nil;
    for(NSLayoutConstraint *cons in view.constraints)   {
        if ([cons.identifier isEqualToString:identifier]) {
            findConstraint = cons;
            break;
        }
    }
    return findConstraint;
}

@end
