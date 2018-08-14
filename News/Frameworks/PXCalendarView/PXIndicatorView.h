//
//  PXIndicatorView.h
//  News
//
//  Created by Futu on 2018/8/8.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PXIndicatorView : UIView
@property (copy, nonatomic) UIColor *color;
@property (weak, nonatomic) UIView *attachingView;
@property (strong, nonatomic) CAShapeLayer *ellipseLayer;
@end

