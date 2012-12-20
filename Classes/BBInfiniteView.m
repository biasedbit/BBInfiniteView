//
// Copyright 2012 BiasedBit
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
//  Copyright (c) 2012 BiasedBit. All rights reserved.
//

#import "BBInfiniteView.h"



#pragma mark -

@implementation BBInfiniteView
{
    CGFloat _offsetLimit;
    CGFloat _originOffset;
    CGFloat _lastOffset;

    UIView* _patternView;
}


#pragma mark Property synthesizers

@synthesize background = _background;
@synthesize movementRatio = _movementRatio;
@synthesize displacement = _displacement;


#pragma mark Creation

- (id)initWithFrame:(CGRect)frame andImage:(UIImage*)image
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        _background = image;
        [self setup];

        [self recalculateInfiniteView];
    }

    return self;
}


#pragma mark UIView

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self setup];
}

- (void)layoutSubviews
{
    [self recalculateInfiniteView];
}


#pragma mark Manual property accessors

- (void)setBackground:(UIImage*)background
{
    _background = background;

    [self setup];
}

- (void)setDisplacement:(CGFloat)displacement
{
    _displacement = displacement;
    
    [self scrollToOffset:_lastOffset];
}


#pragma mark Interface

- (void)scrollToOffset:(CGFloat)offset
{
    _lastOffset = offset;

    // Add the configured displacement to the offset input
    CGFloat normalizedOffset = offset + _displacement;
    // Multiply the normalized offset by the movement ratio
    normalizedOffset *= _movementRatio;

    CGFloat movement = fmodf(normalizedOffset, _background.size.width);

    CGRect frame = _patternView.frame;
    frame.origin.x = _originOffset - movement;
    _patternView.frame = frame;
}


#pragma mark Private helpers

- (void)setup
{
    _movementRatio = 1;
    _displacement = 0;

    _lastOffset = 0;
}

- (void)recalculateInfiniteView
{
    if (_background == nil) {
        return;
    }

    CGFloat a = self.bounds.size.width;
    CGFloat b = _background.size.width;

    // +2 to add one to the left and other to the right; makes the transition look seamless
    _offsetLimit = (ceilf(a / b) + 2) * b;
    _originOffset = -b;

    CGRect patternFrame = self.bounds;
    patternFrame.origin.x = _originOffset;
    patternFrame.size.width = _offsetLimit;

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
