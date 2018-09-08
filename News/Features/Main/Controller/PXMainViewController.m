//
//  PXMainViewController.m
//  News
//
//  Created by Futu on 2018/8/3.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import "PXMainViewController.h"
#import "PXNewsItemCell.h"
#import "PXFilterView.h"
#import <SafariServices/SafariServices.h>
#import "PXCalendarView.h"
#import "PXRefresh.h"
NSString * const requestUrl = @"https://120.76.205.241/news/baidu?apikey=qI9UW0gCBOdRSyUVjLo1tyHDZe4rwjHYs0tngCXcGQpkc6hT9X7usZq0tTYhUtDn&page=4";

@interface PXMainViewController ()<NSURLSessionDelegate, SFSafariViewControllerDelegate>
@property (strong, nonatomic) NSMutableArray<PXNewsItem *> *newsItems;
@property (strong, nonatomic) NSMutableArray<PXNewsItem *> *filteredItems;
@property (strong, nonatomic) PXFilterView *filterView;

@property (assign, nonatomic) CGFloat topInset;
@property (nonatomic, weak) UILabel *topRefreshLabel;
@property (nonatomic, assign, getter=isRefreshing) BOOL refreshing;
@property (nonatomic, assign, getter=isWillRefreshing) BOOL willRefreshing;
@end

@implementation PXMainViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"热点新闻";
	
	
    self.tableView.tableHeaderView = self.filterView;
    self.tableView.rowHeight = 60;
	self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerClass:[PXNewsItemCell class] forCellReuseIdentifier:NSStringFromClass([PXNewsItemCell class])];

	__weak typeof (self) weakSelf = self;
	self.tableView.px_header = [PXRefreshHeader headerWithRefreshigBlock:^{
		[weakSelf fetchNews];
	}];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self.tableView.px_header action:NSSelectorFromString(@"beginRefreshing")];
	
}
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.tableView.px_header beginRefreshing];
}
#pragma mark - methods
- (void)fetchNews {
    [self.view endEditing:YES];
    NSURL *url = [NSURL URLWithString:[[requestUrl stringByAppendingFormat:@"&kw=%@",self.filterView.keyWord] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue new]];
	__weak typeof (self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
            return;
        }
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (error) {
            NSLog(@"%@",error);
            return;
        }
        [weakSelf.newsItems removeAllObjects];
		[weakSelf.filteredItems removeAllObjects];
        for (int i = 0; i < [dict[@"data"] count]; i++) {
            PXNewsItem *newsItem = [PXNewsItem new];
            [newsItem setValuesForKeysWithDictionary:dict[@"data"][i]];
			[weakSelf.newsItems addObject:newsItem];
        }
		[weakSelf filterNews];
		
    }];
    [dataTask resume];
}

- (void)selectDate {
	[self.view endEditing:YES];
	PXCalendarView *datePicker = [PXCalendarView new];
	if (self.filterView.filterDate) {
		datePicker.date = self.filterView.filterDate;
	}
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	[alert.view addSubview:datePicker];
	
	
	
	__weak typeof (self) weakSelf = self;
	UIAlertAction *all = [UIAlertAction actionWithTitle:@"全部" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		weakSelf.filterView.filterDate = nil;
		[weakSelf filterNews];
	}];
	UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		weakSelf.filterView.filterDate = datePicker.date;
		[weakSelf filterNews];
		[weakSelf.tableView reloadData];
	}];
	UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
	[alert addAction:all];
	[alert addAction:ok];
	[alert addAction:cancel];
	datePicker.PX_width = alert.view.PX_width;
	datePicker.PX_height = 300;
	datePicker.PX_y = 2;
	datePicker.PX_centerX = alert.view.PX_width / 2;
	datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;//防止datePcker错位
	[self presentViewController:alert animated:YES completion:nil];
	
}

- (void)filterNews {
	[self.filteredItems removeAllObjects];
	for (PXNewsItem *item in self.newsItems) {
		NSDate *newsDate = [NSDate dateWithTimeIntervalSince1970:item.publishDate];
		NSDate *filterDate = self.filterView.filterDate;
		if (!filterDate) {
			[self.filteredItems addObject:item];
			continue;
		}
		if ([newsDate isSameDay:filterDate]) {
			[self.filteredItems addObject:item];
		}
	}
	__weak typeof (self) weakSelf = self;
	dispatch_async(dispatch_get_main_queue(), ^{
		[weakSelf.tableView reloadData];
		[weakSelf.tableView.px_header endRefreshing];
	});
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.filteredItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PXNewsItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PXNewsItemCell class]) forIndexPath:indexPath];
    cell.item = self.filteredItems[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	SFSafariViewController *safariVc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:self.newsItems[indexPath.row].url]];
	safariVc.delegate = self;
	[self presentViewController:safariVc animated:YES completion:nil];
}

#pragma mark - session delegate

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    //信任证书
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        if (credential) {
            disposition = NSURLSessionAuthChallengeUseCredential;
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    }
    
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}
#pragma mark - SFSafariViewControllerDelegate
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
	[controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - lazy load

- (NSMutableArray<PXNewsItem *> *)newsItems {
    if (!_newsItems) {
        _newsItems = [NSMutableArray array];
    }
    return _newsItems;
}

- (NSMutableArray<PXNewsItem *> *)filteredItems {
	if (!_filteredItems) {
		_filteredItems = [NSMutableArray array];
	}
	return _filteredItems;
}

- (PXFilterView *)filterView {
    if (!_filterView) {
        __weak typeof (self) weakSelf = self;
        _filterView = [[PXFilterView alloc] initWithFrame:CGRectMake(0, 0, PXScreenWith, 40)];
        _filterView.keyWordEnterBlock = ^() {
			[weakSelf.tableView.px_header beginRefreshing];
        };
		_filterView.selectDate = ^{
			[weakSelf selectDate];
		};
    }
    return _filterView;
}

@end
