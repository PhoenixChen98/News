//
//  UIImageView+WebImage.m
//  News
//
//  Created by Futu on 2018/8/6.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import "UIImageView+WebImage.h"
@interface UIImageView ()
@property (class,strong, nonatomic) NSMutableDictionary *images;
@property (class,strong, nonatomic) NSMutableDictionary *operations;
@property (class,strong, nonatomic) NSOperationQueue *operationQueue;
@end
@implementation UIImageView (WebImage)
- (void)px_setImageWithURLString:(NSString *)url {
    [self px_setImageWithURL:[NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
}
- (void)px_setImageWithURL:(NSURL *)url {
    if (!url) {
        return;
    }
    
    
    
    
    __block Class selfClass = [self class];
    //是否已缓存
    UIImage *image = selfClass.images[url];
    if (image) {
        self.image = image;
        return;
    }
    //是否已有任务
    NSBlockOperation *operation = selfClass.operations[url];
    if (operation) {
        return;
    }
    
    //建立下载任务
    __weak typeof(self) weakself = self;
    NSBlockOperation *newOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        //不加上这个header会403
        NSDictionary *headers = @{ @"User-Agent": @"Mozilla/5.0 (Linux; Android 5.0; SM-G900P Build/LRX21T) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.99 Mobile Safari/537.36"};
        [request setAllHTTPHeaderFields:headers];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@",error);
                [selfClass.operations removeObjectForKey:url];
                return;
            }
            
            __block UIImage *image = [UIImage imageWithData:data];
            selfClass.images[url] = image;

            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                weakself.image = image;
                [selfClass.operations removeObjectForKey:url];
            }];
        }];
        [dataTask resume];
        
//        NSError *error;
//        NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
//        if (!data) {
//            NSLog(@"%@",error);
//            [selfClass.operations removeObjectForKey:url];
//            return;
//        }
//        __block UIImage *image = [UIImage imageWithData:data];
//        selfClass.images[url] = image;
//
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            weakself.image = image;
//            [selfClass.operations removeObjectForKey:url];
//        }];
    }];
    
    selfClass.operations[url] = newOperation;
    [selfClass.operationQueue addOperation:newOperation];
    
}
+ (NSMutableDictionary *)images {
    static NSMutableDictionary *images = nil;
    if (!images) {
        images = [NSMutableDictionary dictionary];
    }
    return images;
}
+ (NSMutableDictionary *)operations {
    static NSMutableDictionary *operations = nil;
    if (!operations) {
        operations = [NSMutableDictionary dictionary];
    }
    return operations;
}
+ (NSOperationQueue *)operationQueue {
    static NSOperationQueue *operationQueue = nil;
    if (!operationQueue) {
        operationQueue = [NSOperationQueue new];
    }
    return operationQueue;
}
@end
