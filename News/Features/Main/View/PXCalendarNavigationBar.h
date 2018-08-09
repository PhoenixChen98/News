//
//  PXCalendarNavigationBar.h
//  News
//
//  Created by Futu on 2018/8/8.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PXtitleBar : UIView
@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UIButton *prevButton;
@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) void (^prevMonth)(void);
@property (strong, nonatomic) void (^nextMonth)(void);

@end
