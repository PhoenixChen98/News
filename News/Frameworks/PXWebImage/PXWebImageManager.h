//
//  PXWebImageManager.h
//  News
//
//  Created by Futu on 2018/8/10.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PXWebImageManager : NSObject
@property (strong, nonatomic) NSMutableDictionary<NSURL *, NSData *> *imageDateCache;
@property (strong, nonatomic) NSMutableDictionary<NSURL *, NSBlockOperation *> *operations;
@property (strong, nonatomic) NSOperationQueue *operationQueue;
@property (assign, nonatomic) NSUInteger memCacheSize;
@property (assign, nonatomic) NSUInteger maxMemCacheSize;
@property (strong, nonatomic) NSString *diskPath;
- (UIImage *)imageFromCacheWithUrl:(NSURL *)url;
- (UIImage *)imageFromMemCacheWithUrl:(NSURL *)url;
- (UIImage *)imageFromDiskCacheWithUrl:(NSURL *)url;
- (void)downloadImageWithUrl:(NSURL *)url completion:(void(^)(UIImage *image))completion;
+ (instancetype)sharedManager;
@end
