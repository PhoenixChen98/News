//
//  PXWebImageManager.m
//  News
//
//  Created by Futu on 2018/8/10.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import "PXWebImageManager.h"
#import <CommonCrypto/CommonDigest.h>
@implementation PXWebImageManager
- (instancetype)init {
	if (self = [super init]) {
		self.maxMemCacheSize = 1024 * 1024 * 10;//10M
		
	}
	return self;
}
- (UIImage *)imageFromCacheWithUrl:(NSURL *)url {
	UIImage *image = [self imageFromMemCacheWithUrl:url];
	if (image) {
		return image;
	}
	return [self imageFromDiskCacheWithUrl:url];
}
- (UIImage *)imageFromMemCacheWithUrl:(NSURL *)url {
	return [UIImage imageWithData:self.imageDateCache[url]];
}
- (UIImage *)imageFromDiskCacheWithUrl:(NSURL *)url {
	NSString *path = [self.diskPath stringByAppendingPathComponent:[self filenameFromUrl:url]];
	NSData *data = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
	return [UIImage imageWithData:data];
}
- (void)downloadImageWithUrl:(NSURL *)url completion:(void(^)(UIImage *image))completion {
	//是否已有任务
	NSBlockOperation *operation = self.operations[url];
	if (operation) {
		return;
	}
	
	//建立下载任务
	__weak typeof(self) weakself = self;
	NSBlockOperation *newOperation = [NSBlockOperation blockOperationWithBlock:^{
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
		//加上这个header冒充浏览器，否则403
		NSDictionary *headers = @{ @"User-Agent": @"Mozilla/5.0 (Linux; Android 5.0; SM-G900P Build/LRX21T) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.99 Mobile Safari/537.36"};
		[request setAllHTTPHeaderFields:headers];
		NSURLSession *session = [NSURLSession sharedSession];
		NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
			if (error) {
				NSLog(@"%@",error);
				[weakself.operations removeObjectForKey:url];
				return;
			}
			
			weakself.imageDateCache[url] = data;
			weakself.memCacheSize += data.length;
			if (weakself.memCacheSize > weakself.maxMemCacheSize) {
				[weakself storeMemCacheToDisk];
			}
			[weakself.operations removeObjectForKey:url];
			UIImage *image = [UIImage imageWithData:data];
			completion(image);
		}];
		[dataTask resume];
	}];
	
	self.operations[url] = newOperation;
	[self.operationQueue addOperation:newOperation];
}
- (void)storeMemCacheToDisk {
	[self.imageDateCache enumerateKeysAndObjectsUsingBlock:^(NSURL * _Nonnull url, NSData * _Nonnull data, BOOL * _Nonnull stop) {
		NSString *path = [self.diskPath stringByAppendingPathComponent:[self filenameFromUrl:url]];
		BOOL succ = [NSKeyedArchiver archiveRootObject:data toFile:path];
		NSLog(@"缓存 %d",succ);
	}];
	[self.imageDateCache removeAllObjects];
}
- (NSString *)filenameFromUrl:(NSURL *)url {
	NSString *key = url.path;
	const char *str = key.UTF8String;
	if (str == NULL) {
		str = "";
	}
	unsigned char r[CC_MD5_DIGEST_LENGTH];
	CC_MD5(str, (CC_LONG)strlen(str), r);
	NSString *ext = url.pathExtension;
	NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%@",
						  r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
						  r[11], r[12], r[13], r[14], r[15], ext.length == 0 ? @"" : [NSString stringWithFormat:@".%@", ext]];
	return filename;
}
- (NSMutableDictionary *)imageDateCache {
	if (!_imageDateCache) {
		_imageDateCache = [NSMutableDictionary dictionary];
	}
	return _imageDateCache;
}
- (NSMutableDictionary *)operations {
	if (!_operations) {
		_operations = [NSMutableDictionary dictionary];
	}
	return _operations;
}
- (NSOperationQueue *)operationQueue {
	if (!_operationQueue) {
		_operationQueue = [NSOperationQueue new];
	}
	return _operationQueue;
}
- (NSString *)diskPath {
	if (!_diskPath) {
		_diskPath = [PXCachesDirectory stringByAppendingPathComponent:@"com.Phoenix"];
		NSFileManager *manager = [NSFileManager defaultManager];
		BOOL dir;
		if (![manager fileExistsAtPath:_diskPath isDirectory:&dir] || dir) {
			[manager createDirectoryAtPath:_diskPath withIntermediateDirectories:YES attributes:nil error:nil];
		}
		
	}
	
	return _diskPath;
}
@end
