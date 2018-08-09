//
//  UIImageView+WebImage.h
//  News
//
//  Created by Futu on 2018/8/6.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (WebImage)
/**
 根据url异步加载图片

 @param url NSString类型的图片URL
 */
- (void)px_setImageWithURLString:(NSString *)url;

/**
 根据url异步加载图片

 @param url 图片的URL
 */
- (void)px_setImageWithURL:(NSURL *)url;
@end
