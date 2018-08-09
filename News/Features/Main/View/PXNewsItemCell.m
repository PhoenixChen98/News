//
//  PXNewsItemCell.m
//  News
//
//  Created by Futu on 2018/8/3.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import "PXNewsItemCell.h"
#import "UIImageView+WebImage.h"
@interface PXNewsItemCell ()
@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@end
@implementation PXNewsItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.iconView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.timeLabel];
    }
    return self;
}
- (void)setItem:(PXNewsItem *)item {
    _item = item;
	if (item.imageUrls.count) {
		[self.iconView px_setImageWithURLString:item.imageUrls[0]];
	} else {
		self.iconView.image = nil;
	}
    self.titleLabel.text = item.title;
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.timeLabel.text = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:item.publishDate]];
}
- (void)layoutSubviews {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat gap = 8;
    CGFloat iconWidth = 60;
    
    self.iconView.frame = CGRectMake(gap, gap, iconWidth, height - 2 * gap);
    self.titleLabel.frame = CGRectMake(2 * gap + iconWidth, gap, width - 3 * gap - iconWidth, 21);
    self.timeLabel.frame = CGRectMake(2 * gap + iconWidth, height - gap - 21, width - 3 * gap - iconWidth, 21);
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [UIImageView new];
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = PXSystemFont(15);
        _timeLabel.textColor = PXGrey(121);
    }
    return _timeLabel;
}
@end
