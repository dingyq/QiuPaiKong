//
//  NetWorkConstants.h
//  QiuPai
//
//  Created by bigqiang on 15/11/10.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#ifndef NetWorkConstants_h
#define NetWorkConstants_h

#define Request_Base_Url @"http://qiupai.co/qpkServer/cgi/user_svc.php"
#define Request_UploadImage_Url @"http://qiupai.co/qpkServer/picCgi/evapic_upload.php"

//#define Request_Base_Url @"http://biubiu.co/qpkServer/cgi/user_svc.php"
//#define Request_UploadImage_Url @"http://biubiu.co/qpkServer/picCgi/evapic_upload.php"

// 信息类型
typedef NS_ENUM(NSInteger, InfoType) {
    InfoType_SpecialTopic = 1,
    InfoType_STRepost = 2,
    InfoType_Evaluation = 3,
};

// 标签自定义状态
typedef NS_ENUM(NSInteger, SelfDefine) {
    SelfDefine_NO = 0,
    SelfDefine_YES = 1,
};

// 收藏状态
typedef NS_ENUM(NSInteger, LikeState) {
    LikeState_NO = 0,
    LikeState_YES = 1,
};

// 喜欢状态
typedef NS_ENUM(NSInteger, PraisedState) {
    PraisedState_NO = 0,
    PraisedState_YES = 1,
};

// 分享场景
typedef NS_ENUM(NSInteger, ShareScene) {
    ShareScene_WxSession = 0,
    ShareScene_WxPyq = 1,
    ShareScene_QQSession = 2,
    ShareScene_QZone = 3,
};

// 消息状态：评测、留言、评论
typedef NS_ENUM(NSInteger, ItemStatus) {
    ItemStatus_Normal = 1,
    ItemStatus_Delete = 2,
};

// 关注状态
typedef NS_ENUM(NSInteger, ConcernedState){
    ConcernedState_None = 0,
    ConcernedState_Attentioned = 1,
    ConcernedState_HuFen = 2,
};

// 商品搜索类型
typedef NS_ENUM(NSInteger, GoodsSearchType){
    GoodsSearchType_All = 0,
    GoodsSearchType_Racket = 1,
    GoodsSearchType_RacketLine = 2,
};

// 用户消息类型
typedef NS_ENUM(NSInteger, UserMessageJumpType) {
    UserMessageJumpType_PersonMainPage = 2,
    UserMessageJumpType_SpecialTopic = 4,
    UserMessageJumpType_Evaluation = 5,
};

// 获取新内容的方式
typedef NS_ENUM(NSInteger, GetInfoType) {
    GetInfoTypePull = 1,
    GetInfoTypeRefresh = 2,
};

// 性别
typedef NS_ENUM(NSInteger, SexIndicator) {
    SexIndicatorBoy = 0,
    SexIndicatorGirl = 1,
};

//类别1专题2商品3评测4子评测
typedef NS_ENUM(NSInteger, UserLikeType) {
    UserLikeType_SpecialTopic = 1,
    UserLikeType_Goods = 2,
    UserLikeType_Evaluation = 3,
    UserLikeType_SubEvaluation = 4,
    UserLikeType_MainPage = 5,
};

// 删除消息类型，可删消息、评测
typedef NS_ENUM(NSInteger, DeleteOpType) {
    DeleteOpType_Message = 5,
    DeleteOpType_Evaluation = 6,
};

//商品类别，1球拍(目前只有球拍，也只有球拍有下面参数)
typedef NS_ENUM(NSInteger, GoodsType) {
    GoodsType_Racket = 1,
    GoodsType_RacketLine = 2,
    GoodsType_Shoes = 3,
};

// 用户类型
typedef NS_ENUM(NSInteger, UserType){
    UserTypeWeiXin = 1,
    UserTypeLocalUser = 2,
    UserTypeQQ = 3,
};

// 用户登录方式
typedef NS_ENUM(NSInteger, LoginMode){
    LoginModeAuthKey = 1,
    LoginModePwd = 2,
};

// 消息类型
typedef NS_ENUM(NSInteger, MessageSceneType) {
    MessageSceneType_MainPage = 1,
    MessageSceneType_SpecialTopic = 2,
    MessageSceneType_Evaluation = 3,
};

typedef NS_ENUM(NSInteger, NetWorkRequestID){
    RequestID_GetPreciseSelect = 1,
    RequestID_GetCircleInfo,
    RequestID_GetEvaluationDetailInfo,
    RequestID_SendComment,
    RequestID_PublishNewEvaluation,
    RequestID_UploadImage,
    RequestID_SearchGoodsList,
    RequestID_SendUserCollect,
    RequestID_SendUserShare,
    RequestID_SendUserAttention,
    RequestID_GetGoodsDetailAndEvaluation,
    RequestID_GetUserListRelatedWithMe,
    RequestID_GetCommentAndPraised,
    RequestID_GetSpecialTopicDetail,
    RequestID_GetUserMainPageInfo,
    RequestID_GetAllMyLikedInfo,
    RequestID_KnockUpDirectly,
    RequestID_CompleteSelfInfomation,
    RequestID_SendUserZan,
    RequestID_DeleteUGCContent,
    RequestID_ReportUGCContent,
    
    RequestID_GetUserInfo,
    RequestID_ModifyPersonalInfo,
    RequestID_GetAllMessageInfo,
    RequestID_SendUserLoginRequest,
};

typedef enum HttpRequestMethod {
    HttpRequestMethod_POST,
    HttpRequestMethod_GET,
    HttpRequestMethod_DELETE,
    HttpRequestMethod_PUT,
    HttpRequestMethod_IMAGE,
} HttpRequestMethod;

typedef NS_ENUM(NSInteger, NetWorkStatusCode){
    NetWorkJsonResOK = 0,
    NetWorkJsonResErr = 1,
    NetWorkNoSuchUser = 2,
    NetWorkKwTooShort = 3,
    NetWorkNoAvailGoods = 4,
    NetWorkBanUser = 5,
    NetWorkEvaIdUIdNotMatch = 6,
    NetWorkLikeDuplicate = 7,
    NetWorkLikeIdPartErr = 8,
    NetWorkAuthKeyExpr = 10,
    
};



//emJsonResOk	= 0,
//emJsonResErr	   = 1,
//emNoSuchUser       = 2,    没有用户
//emKwTooShort       = 3,    搜索关键词太短
//emNoAvailGoods     = 4,   评测的商品标签没有一个是库里的(不允许全部都是自定义标签)
//emBanUser          = 5,      被禁掉的用户(暂无)
//emEvaIdUIdNotMatch = 6,   发布评测子帖的人与主贴的不一致
//emLikeDuplicate    = 7,   重复点赞
//emLikeIdPartErr    = 8     点赞的时候(IDpart字段值有误)
//emAuthKeyExpr        = 10     authkey过期的值是10，先mark

#endif /* NetWorkConstants_h */
