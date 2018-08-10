//
//  PXDayView.h
//  News
//
//  Created by Futu on 2018/8/8.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PXIndicatorView;
@interface PXDayView : UIView
@property (strong, nonatomic) UILabel *textLabel;
@property (copy, nonatomic) UIColor *textColor;
@property (copy, nonatomic) UIColor *highlightTextColor;
@property (strong, nonatomic) NSDate *date;
@property (assign, nonatomic) BOOL selected;
@property (assign, nonatomic) BOOL isToday;
@property (assign, nonatomic) BOOL bold;
@property (copy, nonatomic) UIColor *selectedColor;
@property (strong, nonatomic) UIColor *todayColor;
@property (strong, nonatomic) PXIndicatorView *indicatorView;
@property (assign, nonatomic) CGFloat indicatorRadius;
@property (strong, nonatomic) void (^dayDidTap)(PXDayView *sender);

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
@end
