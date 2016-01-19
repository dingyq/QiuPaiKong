//
//  Helper.h
//  QiuPai
//
//  Created by bigqiang on 15/12/21.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareSheetView.h"
#import "MoreOpearationMenu.h"

@interface Helper : NSObject

// 获取当前vc
+ (UIViewController *)getCurrentVC;

// 显示更多操作menu
+ (void)showMoreOpMenu:(MenuItemClick)clickHandler cancelHandler:(MenuItemCancel)cancelHandler titles:(NSArray *)titlesArr tags:(NSArray *)tagsArr;

// 显示分享sheetview
+ (void)showShareSheetView:(ClickBlock)clickHandler showQZone:(BOOL)isShow cancelHandler:(CancelBlock)cancelHandler;

// 从view生成image
+ (UIImage*)createImageFromView:(UIView*)view;

// 保存图像到沙盒
+ (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName compress:(CGFloat)compress;

// 获取当前年份
+ (NSInteger)getCurrentYear;

// 生成个人模板页面
+ (void)generateUserTemplateImage:(NSString *)name sex:(SexIndicator)sex headImage:(NSString *)imageUrl likeNum:(NSInteger)likeNum influence:(NSInteger)influence;

// 生成商品模板页面
+ (void)generateGoodsTemplateImage:(NSString *)name racketImageUrl:(NSString *)racketImageUrl;

// 获取图片
+(UIImage *)bundleImageFile:(NSString *)imageName;

// 上报分享事件
+ (void)uploadShareEventDataToUmeng:(ShareScene)shareScene content:(NSString *)content name:(NSString *)name cId:(NSInteger)contentId;
// 上报购买事件
+ (void)uploadGotoBuyPageDataToUmeng:(NSString *)name goodsId:(NSInteger)goodsId;

// 上报虚拟试打事件
+ (void)uploadRacketKonckUpDataToUment:(GoodsType)goodsType goodsName:(NSString *)goodsName goodsId:(NSInteger)goodsId;

// 提示框
+ (void)showAlertView:(NSString *)tipStr;

// 解析url中字段
+ (NSString *)jiexi:(NSString *)cs webaddress:(NSString *)webAddress;

+ (UIImage*)imageWithColor:(UIColor*)color;

@end
