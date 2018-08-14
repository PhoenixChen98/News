//
//  PXTitleBar.h
//  News
//
//  Created by Futu on 2018/8/8.
//  Copyright © 2018年 Futu. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface PXTitleBar : UIView
@property (strong, nonatomic) UILabel *textLabel;
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) UIButton *lastButton;
@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) void (^lastMonth)(void);
@property (strong, nonatomic) void (^nextMonth)(void);
@end
