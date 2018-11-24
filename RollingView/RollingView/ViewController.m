//
//  ViewController.m
//  RollingView
//
//  Created by kim sunchul on 2018. 11. 24..
//  Copyright © 2018년 tronplay. All rights reserved.
//

#import "ViewController.h"
#import "SampleView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    for (int i=0;i<10;i++) {
        SampleView *sampleView = [[[SampleView alloc] init] autorelease];
        [sampleView.titleLabel setText:[NSString stringWithFormat:@"%d", i+1]];
        [array addObject:sampleView];
    }
    [_rollingView setViewArray:array];
    [_rollingView startAnimation];
}


- (void)dealloc {
    [_rollingView release];
    [super dealloc];
}
@end
