//
//  PXNewsItem.h
//  News
//
//  Created by Futu on 2018/8/3.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PXNewsItem : NSObject
/**
 新闻ID
 */
@property (copy, nonatomic) NSString *ID;

/**
 标题
 */
@property (copy, nonatomic) NSString *title;

/**
 新闻链接
 */
@property (copy, nonatomic) NSString *url;

/**
 图像url合集
 */
@property (strong, nonatomic) NSArray<NSString *> *imageUrls;

/**
 发布者名称
 */
@property (copy, nonatomic) NSString *posterScreenName;

/**
 发布日期时间戳
 */
@property (assign, nonatomic) long publishDate;

@end
