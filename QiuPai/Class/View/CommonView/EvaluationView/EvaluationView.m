//
//  EvaluationView.m
//  QiuPai
//
//  Created by bigqiang on 15/11/16.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "EvaluationView.h"
#import "PhotoBrowseView.h"
#import "UIImageView+WebCache.h"

static CGFloat titleWidth;
static CGFloat imageWidth;


@interface EvaluationView(){
    NSArray *_picArr;
    NSArray *_thumbPicArr;
    NSString *_content;
    
    NSMutableArray *_imageViewTagArr;
    
    NSMutableArray *_thumbImageArr;
    
    BOOL _isShowDetailContent;
}
@end



@implementation EvaluationView

- (instancetype)initWithFrame:(CGRect)frame showDetailContent:(BOOL)detailInfo {
    self = [super initWithFrame:frame];
    if (self) {
        titleWidth = frame.size.width - 20;
        imageWidth = (titleWidth - 10)/3;
        _imageViewTagArr = [[NSMutableArray alloc] init];
        _thumbImageArr = [[NSMutableArray alloc] init];
        [self initUIWithBriefContent:detailInfo];
        _isShowDetailContent = detailInfo;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame showDetailContent:NO];
}

- (void)initUIWithBriefContent:(BOOL)detailInfo {
    UIView *superView = self;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, titleWidth, 0)];
    [self.titleLabel setTextColor:Gray85Color];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:FS_PC_TITLE]];
    [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(superView.mas_left).with.offset(10.0f);
        make.width.equalTo(superView.mas_width).with.offset(-20.0f);
        make.height.lessThanOrEqualTo(@(FS_PC_TITLE+4));
        make.top.equalTo(@0);
    }];
    
    self.textView = [[UILabel alloc] initWithFrame:CGRectMake(10, 27, titleWidth, 16)];
    self.textView.userInteractionEnabled = NO;
    self.textView.numberOfLines = 0;
    [self.textView setBackgroundColor:[UIColor clearColor]];
    self.textView.textAlignment = NSTextAlignmentLeft;
    [self.textView setTextColor:Gray153Color];
    self.textView.font = [UIFont systemFontOfSize:FS_PC_CONTENT];
    [self addSubview:self.textView];
    CGFloat limitH = FS_PC_CONTENT*2+8;
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_titleLabel.mas_left).with.offset(0);
        make.top.equalTo(_titleLabel.mas_bottom);
        make.height.lessThanOrEqualTo(@(limitH));
        make.width.equalTo(_titleLabel.mas_width).with.offset(0);
    }];
}

- (CGRect)addImageView:(NSString *)picUrl index:(int)index {
    int imageViewTag = index * 100 + 1;
    [_imageViewTagArr addObject:[NSNumber numberWithInt:imageViewTag]];
    UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+index*(imageWidth+5), CGRectGetMaxY(_textView.frame)+6.0, imageWidth, imageWidth)];
    [tmpImageView setTag:imageViewTag];
    [tmpImageView setContentMode:UIViewContentModeScaleAspectFill];
    [tmpImageView setClipsToBounds:YES];
    tmpImageView.userInteractionEnabled = YES;
    [tmpImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"placeholder_evaluation.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        if (image) {
            [_thumbImageArr addObject:image];
        }
    }];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAction:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [tmpImageView addGestureRecognizer:tapGesture];
    
    [self addSubview:tmpImageView];
    
    [tmpImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textView.mas_bottom).with.offset(6.0f);
        make.left.equalTo(self.mas_left).with.offset(10+index*(imageWidth+5));
        make.height.equalTo(@(imageWidth));
        make.width.equalTo(@(imageWidth));
    }];
    
    return [tmpImageView frame];
}

- (void)tapImageAction:(UITapGestureRecognizer *)tapGesture {
    UIImageView *imageView = (UIImageView *)tapGesture.view;
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    CGRect rectInWindow = [self convertRect:imageView.frame toView:currentWindow];
    if (imageView.image) {
        long index = (imageView.tag-1)/100;
        [_thumbImageArr removeAllObjects];
        for (NSNumber *numTag in _imageViewTagArr) {
            UIImageView *tmpImageView = [self viewWithTag:[numTag intValue]];
            if (tmpImageView) {
                [_thumbImageArr addObject:tmpImageView.image];
            }
        }
        PhotoBrowseView *browseView = [[PhotoBrowseView alloc] initWithUrlPathArr:_picArr thumbImageArr:_thumbPicArr thumbImages:_thumbImageArr index:index fromRect:rectInWindow];
        [currentWindow addSubview:browseView];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setPicArr:(NSArray *)picArr thumbPicArray:(NSArray *)thumbPicArr title:(NSString *)title contentStr:(NSString *)content isCircleList:(BOOL)circleList {
    _picArr = [NSArray arrayWithArray:picArr];
    _thumbPicArr = [NSArray arrayWithArray:thumbPicArr];
    _content = content;
    CGFloat height = 0.0f;
    [self.titleLabel setText:title];
    // 计算文本高度
    CGRect frame = [_content boundingRectWithSize:CGSizeMake(titleWidth, 3000) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:FS_PC_CONTENT]} context:nil];
    if (_isShowDetailContent) {
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make){
            make.height.lessThanOrEqualTo(@(frame.size.height + 8));
            make.left.equalTo(_titleLabel.mas_left).with.offset(0);
            make.top.equalTo(_titleLabel.mas_bottom);
            make.width.equalTo(_titleLabel.mas_width).with.offset(0);
        }];
    }
    self.textView.text = _content;
    
//    CGRect imageViewFrame = CGRectMake(0, 0, 0, 0);
    for (NSNumber *numTag in _imageViewTagArr) {
        UIImageView *tmpImageView = [self viewWithTag:[numTag intValue]];
        [tmpImageView removeFromSuperview];
    }
    [_imageViewTagArr removeAllObjects];
    
    for (int i = 0; i < [_thumbPicArr count]; i++) {
        [self addImageView:[_thumbPicArr objectAtIndex:i] index:i];
    }
    
    if (circleList) {
        if (frame.size.height > FS_PC_CONTENT+4) {
            height+=(FS_PC_CONTENT+4)*2;
        } else {
            height+=FS_PC_CONTENT+4;
        }
    } else {
        height+=frame.size.height;
    }
    
    if (![title isEqualToString:@""]) {
        height=height+FS_PC_TITLE+4;
    }
    
    if ([_thumbPicArr count] > 0) {
        height = height+6.0+imageWidth;
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(@(height));
    }];
}

@end
