//
//  HttpRequestManager.h
//  QiuPai
//
//  Created by bigqiang on 15/11/10.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestInfo.h"

@interface HttpRequestManager : NSObject

//创建请求manager
+ (HttpRequestManager *)shareManager;
//发起请求
//- (void)startAsyncHttpRequestWithRequestInfo:(RequestInfo *)requestInfo;
//页面dealloc的时候，取消联网
- (void)cancelRequest;

+ (RequestInfo *)getGoodsDetailAndEvaluationList:(NSDictionary *)requestInfo; // 拉取商品详情页信息及评测列表(目前只有球拍有评测列表)
+ (RequestInfo *)sendUserAttentionRequest:(NSDictionary *)requestInfo; // 发送用户关注请求
+ (RequestInfo *)sendUserCollectRequest:(NSDictionary *)requestInfo; // 发送用户喜欢请求
+ (RequestInfo *)sendUserShareRequest:(NSDictionary *)requestInfo; // 发送用户分享的请求
+ (RequestInfo *)getAttentionedOrFansUsersList:(NSDictionary *)requestInf; // 获取我关注的和关注我的用户
+ (RequestInfo *)getGoodsSearchList:(NSDictionary *)requestInfo; // 搜索商品列表
+ (RequestInfo *)getHotSearchWordsList:(NSDictionary *)requestInfo; // 获取搜索热词列表
+ (RequestInfo *)sendUploadImageRequest:(UIImage *)image fileName:(NSString *)fileName; // 上传图片
+ (RequestInfo *)getPreciseSelectInfo:(NSDictionary *)requestInfo; // 请求精选信息
+ (RequestInfo *)getCircleInfo:(NSDictionary *)requestInfo; // 请求圈子信息
+ (RequestInfo *)getEvaluationDetailInfo:(NSDictionary *)requestInfo; // 请求评测详情
+ (RequestInfo *)getCommentAndPraisedInfoList:(NSDictionary *)requestInfo; // 请求留言我的和我喜欢的
+ (RequestInfo *)sendUserComment:(NSDictionary *)requestInfo; // 发表评测相关信息
+ (RequestInfo *)publishNewEvaluation:(NSDictionary *)requestInfo; // 发表新评测
+ (RequestInfo *)getSpecialTopicDetailInfo:(NSDictionary *)requestInfo; // 获取专题详情
+ (RequestInfo *)getUserMainPageInfo:(NSDictionary *)requestInfo; // 获取用户主页相关信息
+ (RequestInfo *)getAllMyLikedInfoList:(NSDictionary *)requestInfo; // 获取全部我喜欢的相关信息：评测、专题、商品

+ (RequestInfo *)knockUpDirectly:(NSDictionary *)requestInfo; // 直接虚拟试打
+ (RequestInfo *)completeInfomationAndKnockUp:(NSDictionary *)requestInfo; // 完善资料后虚拟试打

+ (RequestInfo *)findPwdBack:(NSDictionary *)requestInfo; // 找回密码
+ (RequestInfo *)modifyPwd:(NSDictionary *)requestInfo; // 修改密码
+ (RequestInfo *)getMobileAuthCode:(NSDictionary *)requestInfo; // 获取手机短信验证码
+ (RequestInfo *)getAllNewMessageTip:(NSDictionary *)requestInfo; // 拉取自己新消息数量
+ (RequestInfo *)getUserInfo:(NSDictionary *)requestInfo; // 拉取自己个人信息完整
+ (RequestInfo *)modifyPersonalInfo:(NSDictionary *)requestInfo; // 修改自己个人信息完整
+ (RequestInfo *)sendUserLoginRequest:(NSDictionary *)requestInfo; // 发送用户登录请求
+ (RequestInfo *)sendUserRegisterRequest:(NSDictionary *)requestInfo; // 发送用户注册请求

+ (RequestInfo *)sendUserZanRequest:(NSDictionary *)requestInfo; //赞

+ (RequestInfo *)deleteUGCContent:(NSDictionary *)requestInfo;// 删除ugc内容
+ (RequestInfo *)reportUGCContent:(NSDictionary *)requestInfo;// 举报ugc内容

@end
