//
//  SampleView.m
//  RollingView
//
//  Created by kim sunchul on 2018. 11. 24..
//  Copyright © 2018년 tronplay. All rights reserved.
//

#import "SampleView.h"

@implementation SampleView

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
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setNib];
    }
    return self;
}

- (void)setNib{
    _view = [[[NSBundle mainBundle] loadNibNamed:@"SampleView" owner:self options:nil] objectAtIndex:0];
    [_view setFrame:CGRectMake(0, 0, [self frame].size.width, [self frame].size.height)];
    [self addSubview:_view];
}



- (void)dealloc {
    [_view release];
    [_titleLabel release];
    [super dealloc];
}
@end
