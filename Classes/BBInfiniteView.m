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

#import "BBInfiniteView.h"



#pragma mark -

@implementation BBInfiniteView
{
    CGSize _offsetLimit;
    CGPoint _originOffset;
    CGPoint _lastOffset;

    UIView* _patternView;
}


#pragma mark Creation

- (id)initWithFrame:(CGRect)frame andImage:(UIImage*)image
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        _background = image;
        [self setup];

        [self recalculateInfiniteView];
        self.clipsToBounds = YES;
    }

    return self;
}


#pragma mark UIView

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.clipsToBounds = YES;
    [self setup];
}

- (void)layoutSubviews
{
    [self recalculateInfiniteView];
}


#pragma mark Properties

- (void)setBackground:(UIImage*)background
{
    _background = background;
    if (_patternView != nil) _patternView.backgroundColor = [UIColor colorWithPatternImage:background];

    [self setup];
    [self setNeedsLayout];
}

- (void)setDisplacement:(CGPoint)displacement
{
    _displacement = displacement;

    [self scrollToOffset:_lastOffset];
}


#pragma mark Interface

- (void)scrollToOffset:(CGPoint)offset
{
    _lastOffset = offset;

    // Add the configured displacement to the offset input
    CGFloat normalizedOffsetX = offset.x + _displacement.x;
    CGFloat normalizedOffsetY = offset.y + _displacement.y;

    // Multiply the normalized offset by the movement ratio
    normalizedOffsetX *= _movementRatio.width;
    normalizedOffsetY *= _movementRatio.height;

    CGFloat movementX = fmodf(normalizedOffsetX, _background.size.width);
    CGFloat movementY = fmodf(normalizedOffsetY, _background.size.height);

    CGRect frame = _patternView.frame;
    frame.origin = CGPointMake(_originOffset.x - movementX, _originOffset.y - movementY);
    _patternView.frame = frame;
}

- (void)scrollToHorizontalOffset:(CGFloat)offset
{
    [self scrollToOffset:CGPointMake(offset, _lastOffset.y)];
}

- (void)scrollToVerticalOffset:(CGFloat)offset
{
    [self scrollToOffset:CGPointMake(_lastOffset.x, offset)];
}


#pragma mark Private helpers

- (void)setup
{
    _movementRatio = CGSizeMake(1, 1);
    _displacement = CGPointZero;

    _lastOffset = CGPointZero;
}

- (void)recalculateInfiniteView
{
    if (_background == nil) return;

    CGFloat containerWidth = self.bounds.size.width;
    CGFloat patternWidth = _background.size.width;

    CGFloat containerHeight = self.bounds.size.height;
    CGFloat patternHeight = _background.size.height;

    // +2 to add one to the left and other to the right; makes the transition look seamless
    CGFloat horizontalOffset = (ceilf(containerWidth / patternWidth) + 2) * patternWidth;
    CGFloat verticalOffset = (ceilf(containerHeight / patternHeight) + 2) * patternHeight;

    _offsetLimit = CGSizeMake(horizontalOffset, verticalOffset);
    _originOffset = CGPointMake(-patternWidth, -patternHeight);

    CGRect patternFrame = self.bounds;
    patternFrame.origin = _originOffset;
    patternFrame.size = _offsetLimit;

    if (_patternView == nil) {
        _patternView = [[UIView alloc] initWithFrame:patternFrame];
        _patternView.backgroundColor = [UIColor colorWithPatternImage:_background];
        [self addSubview:_patternView];
    } else {
        _patternView.frame = patternFrame;
    }

    [self scrollToOffset:_lastOffset];
}

@end
