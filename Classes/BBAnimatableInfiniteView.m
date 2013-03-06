//
// Copyright 2013 BiasedBit
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

//
//  Created by Bruno de Carvalho (@biasedbit, http://biasedbit.com)
//  Copyright (c) 2013 BiasedBit. All rights reserved.
//

#import "BBAnimatableInfiniteView.h"

#import "BBInfiniteView.h"



#pragma mark -

@interface BBScrollView : UIScrollView

- (void)setContentOffset:(CGPoint)contentOffset withDuration:(NSTimeInterval)duration
              completion:(void (^)(BOOL finished))completion;
@end

@implementation BBScrollView

- (void)setContentOffset:(CGPoint)contentOffset withDuration:(NSTimeInterval)duration
              completion:(void (^)(BOOL finished))completion
{
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState;
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        [self setContentOffset:contentOffset animated:NO];
    } completion:completion];
}

@end



#pragma mark -

@interface BBAnimatableInfiniteView () <UIScrollViewDelegate>
@end

@implementation BBAnimatableInfiniteView
{
    BBInfiniteView* _infiniteView;
    BBScrollView* _scrollView;
}


#pragma mark Creation

- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage*)image;
{
    self = [super initWithFrame:frame];
    if (self != nil) [self setupWithImage:image];

    return self;
}


#pragma mark UINibLoading

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self setupWithImage:nil];
}


#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    [_infiniteView scrollToOffset:scrollView.contentOffset];
}


#pragma mark Properties

- (UIImage*)background
{
    return _infiniteView.background;
}

- (void)setBackground:(UIImage*)background
{
    _infiniteView.background = background;
}

- (CGSize)movementRatio
{
    return _infiniteView.movementRatio;
}

- (void)setMovementRatio:(CGSize)movementRatio
{
    _infiniteView.movementRatio = movementRatio;
}

- (CGPoint)displacement
{
    return _infiniteView.displacement;
}

- (void)setDisplacement:(CGPoint)displacement
{
    _infiniteView.displacement = displacement;
}

- (CGPoint)offset
{
    return _scrollView.contentOffset;
}


#pragma mark Interface

- (void)scrollToOffset:(CGPoint)offset
{
    return [_infiniteView scrollToOffset:offset];
}

- (void)scrollToHorizontalOffset:(CGFloat)offset
{
    return [_infiniteView scrollToHorizontalOffset:offset];
}

- (void)scrollToVerticalOffset:(CGFloat)offset
{
    return [_infiniteView scrollToVerticalOffset:offset];
}

- (void)scrollToOffset:(CGPoint)offset withDuration:(NSTimeInterval)duration
            completion:(void (^)(BOOL finished))completion
{
    [_scrollView setContentOffset:offset withDuration:duration completion:completion];
}

- (void)scrollToHorizontalOffset:(CGFloat)offset withDuration:(NSTimeInterval)duration
                      completion:(void (^)(BOOL finished))completion
{
    CGPoint contentOffset = CGPointMake(offset, _scrollView.contentOffset.y);
    [_scrollView setContentOffset:contentOffset withDuration:duration completion:completion];
}

- (void)scrollToVerticalOffset:(CGFloat)offset withDuration:(NSTimeInterval)duration
                    completion:(void (^)(BOOL finished))completion
{
    CGPoint contentOffset = CGPointMake(_scrollView.contentOffset.x, offset);
    [_scrollView setContentOffset:contentOffset withDuration:duration completion:completion];
}


#pragma mark Private helpers

- (void)setupWithImage:(UIImage*)image
{
    _infiniteView = [[BBInfiniteView alloc] initWithFrame:self.bounds andImage:image];
    _infiniteView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_infiniteView];

    _scrollView = [[BBScrollView alloc] initWithFrame:self.bounds];
    _scrollView.userInteractionEnabled = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delegate = self;
}

@end
