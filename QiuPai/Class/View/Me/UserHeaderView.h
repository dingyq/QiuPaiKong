//
//  UserHeaderView.h
//  QiuPai
//
//  Created by bigqiang on 15/11/22.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserHeaderViewDelegate <NSObject>

@optional

- (void)sendAttentionUserRequest:(NSString *)usrId;

@end

//@interface UserHeaderView : UIImageView
@interface UserHeaderView : UIView

//@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *sexLabel;
@property (nonatomic, strong) UIImageView *sexImage;
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *racketLabel;
@property (nonatomic, strong) UILabel *otherInfoLabel;
@property (nonatomic, assign) BOOL isMyHeader;

@property (nonatomic, weak) id<UserHeaderViewDelegate> myDelegate;

- (void)setLoginState:(BOOL)isLogin;

- (void)setHeadViewImage:(NSString *)strValue;
- (void)setNameLabelText:(NSString *)strValue;
- (void)setSexImageTip:(NSInteger)sexIndictator;
- (void)setAgeLabelText:(NSString *)strValue;
- (void)setRacketLabelText:(NSString *)strValue;
- (void)setOtherInfoLabelText:(NSString *)strValue;
- (void)setUserAttentioned:(NSInteger)attentionState;

@end
