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

    __strong UIView* _patternView;
    __strong UIImage* _image;
    __strong UIColor* _color;
}


#pragma mark Property synthesizers

@synthesize movementRatio = _movementRatio;
@synthesize displacement = _displacement;


#pragma mark Creation

- (id)initWithFrame:(CGRect)frame andImage:(UIImage*)image
{
    return [self initWithFrame:frame image:image andBackgroundColor:nil];
}

- (id)initWithFrame:(CGRect)frame image:(UIImage*)image andBackgroundColor:(UIColor*)color
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        _image = image;
        _color = color;
        _movementRatio = 1;
        _displacement = 0;

        _lastOffset = 0;

        [self setup];
    }

    return self;
}


#pragma mark Manual property accessors

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

    CGFloat movement = fmodf(normalizedOffset, _image.size.width);

    CGRect frame = _patternView.frame;
    frame.origin.x = _originOffset - movement;
    _patternView.frame = frame;
}


#pragma mark Private helpers

- (void)setup
{
    CGFloat a = self.bounds.size.width;
    CGFloat b = _image.size.width;

    // +2 to add one to the left and other to the right; makes the transition look seamless
    _offsetLimit = (ceilf(a / b) + 2) * b;
    _originOffset = -b;

    CGRect patternFrame = self.bounds;
    patternFrame.origin.x = _originOffset;
    patternFrame.size.width = _offsetLimit;

    _patternView = [[UIView alloc] initWithFrame:patternFrame];
    _patternView.backgroundColor = [UIColor colorWithPatternImage:_image];

    [self addSubview:_patternView];
}

@end
