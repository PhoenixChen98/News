//
//  PXFilterView.m
//  News
//
//  Created by Futu on 2018/8/3.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import "PXFilterView.h"
@interface PXFilterView ()<UITextFieldDelegate>
@property (strong, nonatomic) UIButton *dateButton;
@property (strong, nonatomic) UITextField *keyWordField;
@end
@implementation PXFilterView
#pragma mark - life circle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self setupView];
	}
	return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.dateButton sizeToFit];
    CGFloat buttonWidth = self.dateButton.PX_width;
    CGFloat height = self.PX_height;
    self.dateButton.frame = CGRectMake(0, 0, buttonWidth, height);
    self.keyWordField.frame = CGRectMake(buttonWidth, 0, self.PX_width - buttonWidth, height);
}
#pragma mark - methods
- (void)setupView {
	self.dateButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[self.dateButton setTitle:@"全部" forState:UIControlStateNormal];
	[self.dateButton addTarget:self action:@selector(clickDate) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:self.dateButton];
	self.keyWordField = [UITextField new];
	self.keyWordField.placeholder = @"富途";
	self.keyWordField.returnKeyType = UIReturnKeySearch;
	self.keyWordField.delegate = self;
	[self addSubview:self.keyWordField];
}
- (NSString *)keyWord {
    NSString *keyWord = self.keyWordField.text;
    if (keyWord.length == 0) {
        keyWord = @"富途";
    }
    return keyWord;
}

- (void)setFilterDate:(NSDate *)filterDate {
	_filterDate = filterDate;
	if (!filterDate) {
		[self.dateButton setTitle:@"全部" forState:UIControlStateNormal];
	} else {
		NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"yyyy/MM/dd"];//设定时间格式
		NSString *dateString = [dateFormat stringFromDate:filterDate];
		[self.dateButton setTitle:dateString forState:UIControlStateNormal];
	}
	[self setNeedsLayout];
}

- (void)clickDate {
	if (self.selectDate) {
		self.selectDate();
	}
	
}
#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (self.keyWordEnterBlock) {
		self.keyWordEnterBlock();
	}
	
    return YES;
}
@end
