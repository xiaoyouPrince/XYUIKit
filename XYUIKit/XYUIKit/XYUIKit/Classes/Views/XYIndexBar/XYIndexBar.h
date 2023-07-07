//
//  XYIndexBar.m
//
//  Created by 渠晓友 on 2018/10/31.
//  Copyright © 2018年 渠晓友. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XYIndexBar;

@protocol XYIndexBarDelegate<NSObject>

- (void)indexDidChanged:(XYIndexBar *)indexBar index:(NSInteger)index title:(NSString *)title;

@end


@interface XYIndexBar : UIView

@property (nonatomic, weak) id <XYIndexBarDelegate> delegate;
@property (nonatomic, strong) UIColor *textColor;

/**
 The color of the selected text.
 */
@property (nonatomic, strong) UIColor *selectedTextColor;

/**
 The background color of the selected text.
 */
@property (nonatomic, strong) UIColor *selectedBackgroundColor;


/**
 When you click on a index, a view that shows the text that is currently clicked appears. This property is used to set the draw color of that view.
 */
@property (nonatomic, strong) UIColor *detailViewDrawColor;

/**
 This property is used to set the text color of indexDetailView.
 */
@property (nonatomic, strong) UIColor *detailViewTextColor;

/**
 A Boolean value indicating whether the indexBar is being clicked or swiped.
 */
@property (nonatomic, assign) BOOL onTouch;

/**
 A boolean value indicating whether an indexDetailView should be displayed.
 */
@property (nonatomic, assign) BOOL hideDetailView;


/**
 The height of each index.
 */
@property (nonatomic, assign) CGFloat sectionHeight;

- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
- (void)setIndexes:(NSArray *)indexes;
- (void)setSelectedLabel:(NSInteger)index;

@end







