//
//  PXFilterView.h
//  News
//
//  Created by Futu on 2018/8/3.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PXFilterView : UIView
@property (strong, nonatomic) void(^keyWordDidChangeBlock)(void);
@property (strong, nonatomic) void(^selectDate)(void);
@property (copy, nonatomic, readonly) NSString *keyWord;
@property (strong, nonatomic) NSDate *filterDate;
@end
