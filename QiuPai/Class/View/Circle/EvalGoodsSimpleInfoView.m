//
//  EvalGoodsSimpleInfoView.m
//  QiuPai
//
//  Created by bigqiang on 15/12/3.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "EvalGoodsSimpleInfoView.h"
#import "UIImageView+WebCache.h"

#define NAME_FONT_SIZE 15.0f
#define TIP_FONT_SIZE 12.0f

@interface EvalGoodsSimpleInfoView() {
    UIImageView *_goodsImageView;
    UILabel *_goodsNameL;
    
    UILabel *_weightTipL;
    UILabel *_weightL;

    UILabel *_balanceTipL;
    UILabel *_balanceL;
    
    UILabel *_headSizeTipL;
    UILabel *_headSizeL;
    
    UILabel *_tipLabel;
}

@end

@implementation EvalGoodsSimpleInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 6, frame.size.height - 12, frame.size.height - 12)];
        [self addSubview:_goodsImageView];
//        mDebugShowBorder(_goodsImageView, [UIColor redColor]);
        CGFloat gap = 5.0f;
        
        _goodsNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_goodsImageView.frame)+4, 8, frame.size.width - 106 - 40, 18)];
        [_goodsNameL setTextColor:Gray17Color];
        [_goodsNameL setBackgroundColor:[UIColor clearColor]];
        [_goodsNameL setFont:[UIFont systemFontOfSize:NAME_FONT_SIZE]];
        [_goodsNameL setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_goodsNameL];
        
        _weightTipL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_goodsNameL.frame), CGRectGetMaxY(_goodsNameL.frame)+gap*2, 32, 14)];
        [_weightTipL setTextColor:Gray153Color];
        [_weightTipL setBackgroundColor:[UIColor clearColor]];
        [_weightTipL setFont:[UIFont systemFontOfSize:TIP_FONT_SIZE]];
        [_weightTipL setTextAlignment:NSTextAlignmentLeft];
        [_weightTipL setText:@"重量:"];
        [_weightTipL sizeToFit];
        [self addSubview:_weightTipL];
        
        _weightL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_weightTipL.frame), CGRectGetMinY(_weightTipL.frame), 40, 14)];
        [_weightL setTextColor:Gray153Color];
        [_weightL setBackgroundColor:[UIColor clearColor]];
        [_weightL setFont:[UIFont systemFontOfSize:TIP_FONT_SIZE]];
        [_weightL setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_weightL];
        
        _balanceTipL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_weightTipL.frame), CGRectGetMaxY(_weightTipL.frame)+gap, 34, 14)];
        [_balanceTipL setTextColor:Gray153Color];
        [_balanceTipL setBackgroundColor:[UIColor clearColor]];
        [_balanceTipL setFont:[UIFont systemFontOfSize:TIP_FONT_SIZE]];
        [_balanceTipL setTextAlignment:NSTextAlignmentLeft];
        [_balanceTipL setText:@"平衡点:"];
        [_balanceTipL sizeToFit];
        [self addSubview:_balanceTipL];
        
        _balanceL = [[AutoResizeLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_balanceTipL.frame), CGRectGetMinY(_balanceTipL.frame), 34, 14)];
        [_balanceL setTextColor:Gray153Color];
        [_balanceL setBackgroundColor:[UIColor clearColor]];
        [_balanceL setFont:[UIFont systemFontOfSize:TIP_FONT_SIZE]];
        [_balanceL setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_balanceL];
        
        _headSizeTipL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_weightTipL.frame), CGRectGetMaxY(_balanceTipL.frame)+gap, 34, 14)];
        [_headSizeTipL setTextColor:Gray153Color];
        [_headSizeTipL setBackgroundColor:[UIColor clearColor]];
        [_headSizeTipL setFont:[UIFont systemFontOfSize:TIP_FONT_SIZE]];
        [_headSizeTipL setTextAlignment:NSTextAlignmentLeft];
        [_headSizeTipL setText:@"拍面:"];
        [_headSizeTipL sizeToFit];
        [self addSubview:_headSizeTipL];
        
        _headSizeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headSizeTipL.frame), CGRectGetMinY(_headSizeTipL.frame), 34, 14)];
        [_headSizeL setTextColor:Gray153Color];
        [_headSizeL setBackgroundColor:[UIColor clearColor]];
        [_headSizeL setFont:[UIFont systemFontOfSize:TIP_FONT_SIZE]];
        [_headSizeL setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_headSizeL];
        
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, frame.size.height/2-10, 90, 20)];
        [_tipLabel setTextColor:Gray153Color];
        [_tipLabel setBackgroundColor:[UIColor clearColor]];
        [_tipLabel setFont:[UIFont systemFontOfSize:NAME_FONT_SIZE]];
        [_tipLabel setTextAlignment:NSTextAlignmentLeft];
        [_tipLabel setHidden:YES];
        [self addSubview:_tipLabel];
        
    }
    return self;
}

- (void)setRacketInfo:(NSString *)imageUrl name:(NSString *)goodsName weight:(NSString *)weight balance:(NSString *)balance headSize:(NSString *)headSize {
    [_goodsImageView setHidden:NO];
    [_goodsNameL setHidden:NO];
    [_weightTipL setHidden:NO];
    [_weightL setHidden:NO];
    [_balanceTipL setHidden:NO];
    [_balanceL setHidden:NO];
    [_headSizeTipL setHidden:NO];
    [_headSizeL setHidden:NO];
    [_tipLabel setHidden:YES];
    
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_evaluation.jpg"]];
    
    [_goodsNameL setText:goodsName];
    [_goodsNameL sizeToFit];
//    CGRect orignNameFrame = _goodsNameL.frame;
//    CGRect newNameFrame = [goodsName boundingRectWithSize:CGSizeMake(orignNameFrame.size.width, 40) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName: _goodsNameL.font} context:nil];
//    [_goodsNameL setFrame:CGRectMake(orignNameFrame.origin.x, orignNameFrame.origin.y, newNameFrame.size.width+5, newNameFrame.size.height)];
    
    [_weightTipL setText:@"重量:"];
    [_weightL setText:weight];
    [_balanceL setText:balance];
    [_headSizeL setText:headSize];
    
    [_weightTipL sizeToFit];
    [_weightL sizeToFit];
    [_balanceL sizeToFit];
    [_headSizeL sizeToFit];
}

- (void)setRacketLineInfo:(NSString *)imageUrl name:(NSString *)goodsName caiZhi:(NSString *)caiZhi {
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_evaluation.jpg"]];
    [_goodsNameL setText:goodsName];
    [_goodsNameL sizeToFit];
    
    [_weightTipL setText:@"材质:"];
    [_weightL setText:caiZhi];
    [_weightTipL sizeToFit];
    [_weightL sizeToFit];
    
    [_goodsImageView setHidden:NO];
    [_goodsNameL setHidden:NO];
    [_weightTipL setHidden:NO];
    [_weightL setHidden:NO];
    [_balanceTipL setHidden:YES];
    [_balanceL setHidden:YES];
    [_headSizeTipL setHidden:YES];
    [_headSizeL setHidden:YES];
    [_tipLabel setHidden:YES];
}

- (void)showGoodsSelectTip:(NSString *)tipStr {
    [_goodsImageView setHidden:YES];
    [_goodsNameL setHidden:YES];
    [_weightTipL setHidden:YES];
    [_weightL setHidden:YES];
    [_balanceTipL setHidden:YES];
    [_balanceL setHidden:YES];
    [_headSizeTipL setHidden:YES];
    [_headSizeL setHidden:YES];
    [_tipLabel setHidden:NO];
    
    [_tipLabel setText:tipStr];
    [_tipLabel sizeToFit];
}

@end
