//
//  ViewController.m
//  Demo
//
//  Created by Bruno de Carvalho on 7/29/12.
//  Copyright (c) 2012 BiasedBit. All rights reserved.
//

#import "ViewController.h"



#pragma mark - Functions

NSUInteger GreatestCommonDivisor(NSUInteger a, NSUInteger b)
{
    NSUInteger tmp;
    while (b != 0) {
        tmp = b;
        b = a % b;
        a = tmp;
    }

    return tmp;
}

NSUInteger LeastCommonMultiple(NSUInteger a, NSUInteger b)
{
    return ((a * b) / GreatestCommonDivisor(a, b));
}


#pragma mark -

@implementation ViewController
{
    CGFloat _scrollWidth;
}


#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _scrollView.delegate = self;

    // Reset background color (set on IB to help distinguish)
    for (UIView* view in self.view.subviews) {
        view.backgroundColor = [UIColor clearColor];
    }

    // Images
    UIImage* cloudImage = [UIImage imageNamed:@"Clouds"];
    UIImage* cloud2Image = [UIImage imageNamed:@"Clouds2"];
    UIImage* buildingSkylineThreeImage = [UIImage imageNamed:@"BuildingSkylineThree"];
    UIImage* buildingSkylineTwoImage = [UIImage imageNamed:@"BuildingSkylineTwo"];
    UIImage* buildingSkylineOneImage = [UIImage imageNamed:@"BuildingSkylineOne"];
    UIImage* roadViewImage = [UIImage imageNamed:@"Road"];

    // Update the building view to match the size of the image
    [self prepareInfiniteView:_cloudLayerTwo forImage:cloud2Image];
    [self prepareInfiniteView:_cloudLayerOne forImage:cloudImage];
    [self prepareInfiniteView:_buildingSkylineThree forImage:buildingSkylineThreeImage];
    [self prepareInfiniteView:_buildingSkylineTwo forImage:buildingSkylineTwoImage];
    [self prepareInfiniteView:_buildingSkylineOne forImage:buildingSkylineOneImage];
    [self prepareInfiniteView:_roadView forImage:roadViewImage];

    // Setup the movement ratios
    _cloudLayerTwo.movementRatio = 0.01;
    _cloudLayerOne.movementRatio = 0.05;
    _buildingSkylineThree.movementRatio = 0.4;
    _buildingSkylineTwo.movementRatio = 0.6;
    _buildingSkylineOne.movementRatio = 0.7;
    _roadView.movementRatio = 1;


    // Calculate the size for the scroll; it's the LCM for all the layers
    [self calculateLCMForLayersAndSetupScrollViewContentSize];
    _scrollView.contentOffset = CGPointMake(_scrollView.contentSize.width / 2.0, 0);
}

- (void)prepareInfiniteView:(BBInfiniteView*)view forImage:(UIImage*)image
{
    view.frame = (CGRect) {
        .origin.x = 0,
        .origin.y = CGRectGetMaxY(view.frame) - image.size.height,
        .size.width = self.view.bounds.size.width,
        .size.height = image.size.height
    };

    view.background = image;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // Force a call to scrollViewDidScroll, just so the infinite views are updated to match the scroll view's current
    // offset.
    [self scrollViewDidScroll:_scrollView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    _scrollView.contentSize = CGSizeMake(_scrollWidth, _scrollView.bounds.size.height);
}


#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGFloat offset = scrollView.contentOffset.x;

    [_cloudLayerTwo scrollToOffset:offset];
    [_cloudLayerOne scrollToOffset:offset];
    [_buildingSkylineThree scrollToOffset:offset];
    [_buildingSkylineTwo scrollToOffset:offset];
    [_buildingSkylineOne scrollToOffset:offset];
    [_roadView scrollToOffset:offset];
//    [_foremostView scrollToOffset:offset];
}


#pragma mark Private helpers

- (void)calculateLCMForLayersAndSetupScrollViewContentSize
{
    NSMutableArray* widths = [NSMutableArray array];
    for (id view in self.view.subviews) {
        if ([view isKindOfClass:[BBInfiniteView class]] && ([view background] != nil)) {
            CGFloat width = [view background].size.width;
            NSNumber* wrappedWidth = [NSNumber numberWithFloat:width];
            [widths addObject:wrappedWidth];
        }
    }

    // This is an absurdly high (something like 7 million?) value but goes to prove this thing performs very well
//    _scrollWidth = [self calculateLCMForArray:widths];
    _scrollWidth = 10000;

    _scrollView.contentSize = CGSizeMake(_scrollWidth, _scrollView.bounds.size.height);
}

- (NSUInteger)calculateLCMForArray:(NSArray*)array
{
    switch ([array count]) {
        case 0:
            return 0;
        case 1:
            return [[array objectAtIndex:0] floatValue];
        case 2:
            return LeastCommonMultiple([[array objectAtIndex:0] unsignedIntegerValue],
                                       [[array objectAtIndex:1] unsignedIntegerValue]);
        default: {
            NSNumber* wrapper = [array objectAtIndex:0];
            NSArray* subArray = [array subarrayWithRange:NSMakeRange(1, [array count] - 1)];
            NSUInteger lcm = LeastCommonMultiple([wrapper unsignedIntegerValue],
                                                 [self calculateLCMForArray:subArray]);

            return lcm;
        }
    }
}

@end
