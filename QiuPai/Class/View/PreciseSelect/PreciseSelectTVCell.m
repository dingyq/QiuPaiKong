//
//  PreciseSelectTVCell.m
//  QiuPai
//
//  Created by bigqiang on 15/11/21.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "PreciseSelectTVCell.h"

#import "RacketCollectionInfoModel.h"
#import "UIImageView+WebCache.h"
#import "EvaluationView.h"

@interface PreciseSelectTVCell(){
    UIView *_layerView;
    CAGradientLayer *_gradientLayer;
    UILabel *_titleLabel;
    UIButton *_likeBtn;
    UIImageView *_specialTopicImageView;
}

@property (nonatomic, weak) RacketCollectionInfoModel *preciseSelectModel;

@end

@implementation PreciseSelectTVCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat imageW = kFrameWidth - 10;
        CGFloat imageH = imageW * 170 / 365;
        
        _specialTopicImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5.0/2, imageW, imageH)];
        [_specialTopicImageView.layer setMasksToBounds:YES];
        [_specialTopicImageView.layer setCornerRadius:4.0];
        _specialTopicImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_specialTopicImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 13, kFrameWidth - 20, 25)];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:FS_ZT_TITLE]];
        [_titleLabel setTextAlignment:NSTextAlignmentLeft];
        
        _layerView = [[UIView alloc] initWithFrame:CGRectMake(0, imageH-40, imageW, 40)];
        _gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
        _gradientLayer.bounds = _layerView.bounds;
        _gradientLayer.borderWidth = 0;
        _gradientLayer.frame = _layerView.bounds;
        _gradientLayer.colors = [NSArray arrayWithObjects:
                                 (id)[[UIColor clearColor] CGColor],
                                 (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] CGColor], nil];
        _gradientLayer.startPoint = CGPointMake(0.5, 0);
        _gradientLayer.endPoint = CGPointMake(0.5, 1.0);
        [_gradientLayer setMasksToBounds:YES];
        [_gradientLayer setCornerRadius:4.0];
        [_layerView.layer insertSublayer:_gradientLayer atIndex:0];
        [_layerView addSubview:_titleLabel];
        [_specialTopicImageView addSubview:_layerView];
        
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn setFrame:CGRectMake(kFrameWidth - 64, 14, 44, 22)];
        [_likeBtn setImage:[UIImage imageNamed:@"like_normal"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"like_select"] forState:UIControlStateSelected];
        _likeBtn.titleLabel.font = [UIFont systemFontOfSize:FS_ZT_BUTTON];
        [_likeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_likeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        _likeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 22);
//        [_likeBtn setTitle:@"未收藏" forState:UIControlStateNormal];
//        [_likeBtn setTitle:@"已收藏" forState:UIControlStateSelected];
        [_likeBtn addTarget:self action:@selector(zanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_layerView addSubview:_likeBtn];
    }
    return self;
}

- (void)zanBtnClick:(UIButton *)sender {
    [sender setSelected:![sender isSelected]];
//    [self.myDelegate sendUserCollectRequest:_preciseSelectModel.type itemId:_preciseSelectModel.itemId];
    [self.myDelegate sendUserZanRequest:_preciseSelectModel.type itemId:_preciseSelectModel.itemId];
}

- (void)bindCellWithDataModel:(RacketCollectionInfoModel *)rciModel {
    _preciseSelectModel = rciModel;
    [rciModel getRCICellHeight];
    
    [_titleLabel setFont:[UIFont systemFontOfSize:FS_ZT_TITLE]];
    [_titleLabel setTextAlignment:NSTextAlignmentLeft];
    [_titleLabel setText:rciModel.title];
    
    [_specialTopicImageView sd_setImageWithURL:[NSURL URLWithString:rciModel.picUrl] placeholderImage:[UIImage imageNamed:@"placeholder_theme.jpg"]];
    
    NSString *likeTip = [NSString stringWithFormat:@"%ld", (long)rciModel.praiseNum];
    [_likeBtn setTitle:likeTip forState:UIControlStateNormal];
    [_likeBtn setTitle:likeTip forState:UIControlStateSelected];
    [_likeBtn setSelected:(rciModel.isPraised == PraisedState_YES ? YES:NO)];
}


@end
