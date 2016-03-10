//
//  SearchResultCell.m
//  QiuPai
//
//  Created by bigqiang on 15/12/6.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "SearchResultCell.h"
#import "UIImageView+WebCache.h"

#define NAME_FONT_SIZE 14.0f
#define TIP_TAG 111

@interface SearchResultCell() {
    UIView *_cBgView;
    UIImageView *_goodsImageView;
    
    UILabel *_nameLabel;
    UILabel *_descLabel;
    UILabel *_evaluationNumLabel;
    
    UIButton *_gotoBuyBtn;
    
    UIView *_lineView;
}

@property (nonatomic, weak) RacketSearchModel *infoModel;

@end

@implementation SearchResultCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 100)];
        [_cBgView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:_cBgView];
        
        _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        [_cBgView addSubview:_goodsImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(91, 8, kFrameWidth - 101, 20)];
        [_nameLabel setTextColor:Gray17Color];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:NAME_FONT_SIZE]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_cBgView addSubview:_nameLabel];
        
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(91, _nameLabel.frame.size.height + _nameLabel.frame.origin.y + 2, kFrameWidth - 150, 20)];
        [_descLabel setTextColor:Gray51Color];
        [_descLabel setBackgroundColor:[UIColor clearColor]];
        [_descLabel setFont:[UIFont systemFontOfSize:NAME_FONT_SIZE]];
        [_descLabel setTextAlignment:NSTextAlignmentLeft];
        [_cBgView addSubview:_descLabel];
        
        _evaluationNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(91, _descLabel.frame.size.height + _descLabel.frame.origin.y + 2, kFrameWidth - 150, 20)];
        [_evaluationNumLabel setTextColor:mUIColorWithRGB(73, 119, 146)];
        [_evaluationNumLabel setBackgroundColor:[UIColor clearColor]];
        [_evaluationNumLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_evaluationNumLabel setTextAlignment:NSTextAlignmentLeft];
        [_cBgView addSubview:_evaluationNumLabel];
        
        _gotoBuyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_gotoBuyBtn setFrame:CGRectMake(kFrameWidth - 62 - 10, 49, 62, 23)];
        [_gotoBuyBtn setTitle:@"去购买" forState:UIControlStateNormal];
        [_gotoBuyBtn setTitle:@"去购买" forState:UIControlStateSelected];
        _gotoBuyBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [_gotoBuyBtn setTitleColor:CustomGreenColor forState:UIControlStateNormal];
        [_gotoBuyBtn setTitleColor:CustomGreenColor forState:UIControlStateSelected];
        [_gotoBuyBtn addTarget:self action:@selector(gotoBuyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_gotoBuyBtn setHidden:YES];
        _gotoBuyBtn.layer.borderWidth = 0.5f;
        _gotoBuyBtn.layer.borderColor = CustomGreenColor.CGColor;
        _gotoBuyBtn.layer.cornerRadius = 11.5f;
        [_cBgView addSubview:_gotoBuyBtn];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 0.5f)];
        [_lineView setBackgroundColor:LineViewColor];
        [self.contentView addSubview:_lineView];
    }
    return self;
}

- (void)bindCellWithDataModel:(RacketSearchModel *)infoModel showBuyBtn:(BOOL)isShow {
    _infoModel = infoModel;
    CGFloat cellH = [_infoModel getZanListCellHeight];
    
    [_cBgView setFrame:CGRectMake(0, 0, kFrameWidth, cellH)];
    [_cBgView setHidden:NO];
    
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:infoModel.thumbPicUrl] placeholderImage:[UIImage imageNamed:@"placeholder_evaluation.jpg"]];
    [_nameLabel setText:[NSString stringWithFormat:@"型号:%@", infoModel.name]];
    
    [_descLabel setText:[NSString stringWithFormat:@"品牌:%@", infoModel.brand]];

    [_evaluationNumLabel setText:[NSString stringWithFormat:@"%ld条评测", (long)infoModel.evaluateNum]];
    
    [_lineView setFrame:CGRectMake(0, cellH - 0.5f, kFrameWidth, 0.5f)];
    
    if (isShow) {
        if (infoModel.type == GoodsType_Racket || infoModel.type == GoodsType_RacketLine) {
            [_gotoBuyBtn setHidden:infoModel.sellUrl.count <= 0 ? YES : NO];
        }
    } else {
        [_gotoBuyBtn setHidden:YES];
    }
    
    UIView *bgView = [self.contentView viewWithTag:TIP_TAG];
    if (bgView) {
        [bgView setHidden:YES];
    }
}

- (void)gotoBuyButtonClick:(UIButton *)sender {
    NSString *sellUrl = @"";
    if ([_infoModel.sellUrl count] > 0) {
        sellUrl = [_infoModel.sellUrl objectAtIndex:0];
    }
    [self.myDelegate gotoBuyGoods:_infoModel.name goodsId:_infoModel.goodsId goodsUrl:sellUrl];
}

- (void)showLoadMoreTip:(NSString *)tip {
    UIView *bgView = [self.contentView viewWithTag:TIP_TAG];
    if (!bgView) {
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 29.5f)];
        [tipLabel setTextColor:Gray119Color];
        [tipLabel setTag:112];
        [tipLabel setBackgroundColor:[UIColor clearColor]];
        [tipLabel setFont:[UIFont systemFontOfSize:13.0]];
        [tipLabel setTextAlignment:NSTextAlignmentCenter];
        [tipLabel setBackgroundColor:[UIColor whiteColor]];
        
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 30.0f)];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        [bgView addSubview:tipLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 29.5, kFrameWidth, 0.5f)];
        [lineView setBackgroundColor:Gray202Color];
        [bgView addSubview:lineView];
        [bgView setTag:TIP_TAG];
        [self.contentView addSubview:bgView];
    }
    [_cBgView setHidden:YES];
    [bgView setHidden:NO];
    UILabel *tipL = [bgView viewWithTag:112];
    [tipL setText:tip];
}

@end
