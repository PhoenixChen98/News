//
//  PXNewsItemCell.h
//  News
//
//  Created by Futu on 2018/8/3.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PXNewsItem;
@interface PXNewsItemCell : UITableViewCell
/** 用于内容展示 */
@property (strong, nonatomic) PXNewsItem *item;
@end
