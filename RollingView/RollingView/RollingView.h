//
//  RollingView.h
//  RollingView
//
//  Created by kim sunchul on 2018. 11. 24..
//  Copyright © 2018년 tronplay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RollingView : UIView {
    UIView *currentView;
    UIView *nextView;
    NSInteger index;
    BOOL isStopAnimation;
}

@property (retain, nonatomic) IBOutlet UIView *view;
@property (retain, nonatomic) NSMutableArray *viewArray;
@property (assign, nonatomic) CGFloat animationDelay;
@property (assign, nonatomic) CGFloat waitDelay;

-(void)startAnimation;
-(void)stopAnimation;

@end

NS_ASSUME_NONNULL_END
