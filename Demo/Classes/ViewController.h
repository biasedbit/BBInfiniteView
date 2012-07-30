//
//  ViewController.h
//  Demo
//
//  Created by Bruno de Carvalho on 7/29/12.
//  Copyright (c) 2012 BiasedBit. All rights reserved.
//

#import "BBInfiniteView.h"



#pragma mark -

@interface ViewController : UIViewController <UIScrollViewDelegate>


#pragma mark Interface Builder wiring

@property(weak, nonatomic) IBOutlet UIImageView* background;
@property(weak, nonatomic) IBOutlet BBInfiniteView* cloudLayerTwo;
@property(weak, nonatomic) IBOutlet BBInfiniteView* cloudLayerOne;
@property(weak, nonatomic) IBOutlet BBInfiniteView* buildingSkylineThree;
@property(weak, nonatomic) IBOutlet BBInfiniteView* buildingSkylineTwo;
@property(weak, nonatomic) IBOutlet BBInfiniteView* buildingSkylineOne;
@property(weak, nonatomic) IBOutlet BBInfiniteView* roadView;
@property(weak, nonatomic) IBOutlet BBInfiniteView* foremostView;
@property(weak, nonatomic) IBOutlet UIScrollView* scrollView;

@end
