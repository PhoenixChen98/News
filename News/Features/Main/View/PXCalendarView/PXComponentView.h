//
//  PXComponentView.h
//  News
//
//  Created by Futu on 2018/8/8.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PXComponentView : UIView
@property (strong, nonatomic) UILabel *textLabel;
@property (copy, nonatomic) UIColor *textColor;
@property (copy, nonatomic) UIColor *highlightTextColor;
@property (strong, nonatomic) NSDate *date;
@property (assign, nonatomic) BOOL selected;
@property (strong, nonatomic) void (^componentDidTap)(PXComponentView *sender);
@end
