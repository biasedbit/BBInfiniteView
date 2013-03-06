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

#pragma mark -

/**
 Animatable version of `<BBInfiniteView>`.
 
 It uses both a backing infinite view and a custom scroll view. It works by setting itself as the delegate of the custom
 scrollview and changing the offset of the infinite view when `scrollViewDidScroll:` method is called.
 
 By using a scrollview and hooking to its content offset change events we can avoid emulating `UIView` animations, thus
 keeping animation curves and simulator slow-motion almost "for free".
 */
@interface BBAnimatableInfiniteView : UIView


#pragma mark Properties

@property(strong, nonatomic) UIImage* background;
@property(assign, nonatomic) CGSize movementRatio;
@property(assign, nonatomic) CGPoint displacement;
@property(assign, nonatomic) NSTimeInterval animationStepInterval;

@property(assign, nonatomic, readonly) CGPoint offset;


#pragma mark Creation

- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage*)image;


#pragma mark Interface

- (void)scrollToOffset:(CGPoint)offset;
- (void)scrollToHorizontalOffset:(CGFloat)offset;
- (void)scrollToVerticalOffset:(CGFloat)offset;

- (void)scrollToOffset:(CGPoint)offset withDuration:(NSTimeInterval)duration
            completion:(void (^)(BOOL finished))completion;
- (void)scrollToHorizontalOffset:(CGFloat)offset withDuration:(NSTimeInterval)duration
                      completion:(void (^)(BOOL finished))completion;
- (void)scrollToVerticalOffset:(CGFloat)offset withDuration:(NSTimeInterval)duration
                    completion:(void (^)(BOOL finished))completion;

@end
