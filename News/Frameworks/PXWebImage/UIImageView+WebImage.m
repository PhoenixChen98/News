//
//  UIImageView+WebImage.m
//  News
//
//  Created by Futu on 2018/8/6.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import "UIImageView+WebImage.h"
#import "PXWebImageManager.h"

#define ImageManager [PXWebImageManager sharedManager]

@interface UIImageView ()
@property (class, strong, nonatomic) PXWebImageManager *imageManager;
@end
@implementation UIImageView (WebImage)
- (void)px_setImageWithURLString:(NSString *)url {
    [self px_setImageWithURL:[NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
}
- (void)px_setImageWithURL:(NSURL *)url {
    if (!url) {
        return;
    }
    Class selfClass = [self class];
    //是否已缓存
	UIImage *image = [ImageManager imageFromCacheWithUrl:url];
    if (image) {
        self.image = image;
        return;
    }
	__weak typeof (self) weakSelf = self;
	[selfClass.imageManager downloadImageWithUrl:url completion:^(UIImage *image) {
		dispatch_async(dispatch_get_main_queue(), ^{
			weakSelf.image = image;
		});
	}];
    
}
+ (PXWebImageManager *)imageManager {
	static PXWebImageManager *imageManager;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		imageManager = [PXWebImageManager new];
	});
	return imageManager;
}
@end
