//
//  RollingView.m
//  RollingView
//
//  Created by kim sunchul on 2018. 11. 24..
//  Copyright © 2018년 tronplay. All rights reserved.
//

#import "RollingView.h"

#define CURRENT_TOP_CONSTRAINT @"currentTopConstraint"
#define NEXT_TOP_CONSTRAINT @"nextTopConstraint"

@implementation RollingView

- (void)dealloc {
    [_viewArray release];
    [super dealloc];
}

#pragma mark - Set Function

- (void)setUI{
    _animationDelay = 1.0;
    _waitDelay = 1.5;
}

- (void)setViewArray:(NSMutableArray *)viewArray {
    [_viewArray release];
    _viewArray = viewArray;
    [_viewArray retain];
    [self updateUI];
}

-(void)setNextView {
    [currentView removeFromSuperview];
    currentView = nextView;
    NSLayoutConstraint *nextTopConstraint = [self findViewConstraint:view identifier:NEXT_TOP_CONSTRAINT];
    [nextTopConstraint setIdentifier:CURRENT_TOP_CONSTRAINT];
    
    index++;
    if (index == _viewArray.count) {
        index = 0;
    }
    
    nextView = [_viewArray objectAtIndex:index];
    [self addContentViewWithConstraint:nextView identifier:NEXT_TOP_CONSTRAINT];
    nextTopConstraint = [self findViewConstraint:view identifier:NEXT_TOP_CONSTRAINT];
    [nextTopConstraint setConstant:view.frame.size.height];
}

#pragma mark - Update Function

- (void)updateUI {
    index = 0;
    currentView = [_viewArray objectAtIndex:index];
    [self addContentViewWithConstraint:currentView identifier:CURRENT_TOP_CONSTRAINT];
   
    index++;
    nextView = [_viewArray objectAtIndex:index];
    [self addContentViewWithConstraint:nextView identifier:NEXT_TOP_CONSTRAINT];
}

#pragma mark - Animation Function

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
    
    NSLayoutConstraint *currentTopConstraint = [self findViewConstraint:view identifier:CURRENT_TOP_CONSTRAINT];
    NSLayoutConstraint *nextTopConstraint = [self findViewConstraint:view identifier:NEXT_TOP_CONSTRAINT];
    [currentTopConstraint setConstant:0];
    [nextTopConstraint setConstant:view.frame.size.height];
    [currentView setAlpha:1];
    [nextView setAlpha:0];
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:_animationDelay
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^(void) {
                         [currentTopConstraint setConstant:-view.frame.size.height];
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

#pragma mark - Add Function

-(void)addContentViewWithConstraint:(UIView *)contentView identifier:(NSString *)identifier {
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:contentView];
    
    [[contentView.widthAnchor constraintEqualToAnchor:view.widthAnchor constant:0] setActive:YES];
    [[contentView.heightAnchor constraintEqualToAnchor:view.heightAnchor constant:0] setActive:YES];
    [[contentView.centerXAnchor constraintEqualToAnchor:view.centerXAnchor constant:0] setActive:YES];
    NSLayoutConstraint *top = [contentView.topAnchor constraintEqualToAnchor:view.topAnchor constant:0];
    [top setIdentifier:identifier];
    [top setActive:YES];
}


@end
