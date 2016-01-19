//
//  utilityVar.h
//  QiuPai
//
//  Created by bigqiang on 15/11/13.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#ifndef utilityVar_h
#define utilityVar_h

#define PATH_OF_DOCUMENT [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define Request_Channel @"AppStore"
#define Request_Platform @"iOS"
#define Request_Version [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define Goods_Default_Url @"https://shop137476919.taobao.com/?spm=a230r.7195193.1997079397.2.6he1NT"

//#define kFrameWidth self.view.frame.size.width
//#define kFrameHeight self.view.frame.size.height
#define kFrameWidth [UIScreen mainScreen].bounds.size.width
#define kFrameHeight [UIScreen mainScreen].bounds.size.height


//设置颜色相关
#define mUIColorWithRGB(_r,_g,_b)                   [UIColor colorWithRed:(_r)/255.0 green:(_g)/255.0 blue:(_b)/255.0 alpha:1.0]
#define mUIColorWithRGBA(_r,_g,_b,_a)               [UIColor colorWithRed:(_r)/255.0 green:(_g)/255.0 blue:(_b)/255.0 alpha:(_a)]
#define mUIColorWithValue(rgb)                      [UIColor colorWithRed:((rgb&0xFF0000)>>16)/255.0 green:((rgb&0xFF00)>>8)/255.0 blue:(rgb&0xFF)/255.0 alpha:1]
#define mDebugShowBorder(_v,_color)                 do{\
(_v).layer.borderColor=(_color).CGColor;\
(_v).layer.borderWidth=1.0;\
} while (0)

#define mDebugWithBorder(_v) mDebugShowBorder(_v, [UIColor redColor])

#define CustomGreenColor mUIColorWithRGB(3, 189, 119)
#define LineViewColor mUIColorWithRGB(225, 225, 225)
#define VCViewBGColor mUIColorWithRGB(240, 240, 240)

#define Gray17Color mUIColorWithRGB(17, 17, 17)
#define Gray51Color mUIColorWithRGB(51, 51, 51)
#define Gray85Color mUIColorWithRGB(85, 85, 85)
#define Gray102Color mUIColorWithRGB(102, 102, 102)
#define Gray119Color mUIColorWithRGB(119, 119, 119)
#define Gray153Color mUIColorWithRGB(153, 153, 153)
#define Gray166Color mUIColorWithRGB(166, 166, 166)
#define Gray202Color mUIColorWithRGB(202, 202, 202)
#define Gray212Color mUIColorWithRGB(212, 212, 212)
#define Gray220Color mUIColorWithRGB(220, 220, 220)
#define Gray233Color mUIColorWithRGB(233, 233, 233)
#define Gray240Color mUIColorWithRGB(240, 240, 240)

static NSInteger kPageSizeCount = 10;

#define FS_COMMON_PROMPT 15.0f
// 评测字号
//#define FS_PC_CONTENT 14.0f
#define FS_PC_CONTENT 15.0f
#define FS_PC_TITLE 16.0f
#define FS_PC_NAME 13.0f
#define FS_PC_PLAY_YEAR 10.0f
#define FS_PC_TAG 12.0f
#define FS_PC_BUTTON 12.0f
#define FS_PC_COMMENT 14.0f

// 专题title
#define FS_ZT_TITLE 15.0f
#define FS_ZT_BUTTON 12.0f

// 评测详情
#define FS_PCXQ_LOAD_MORE 15.0f
#define FS_PCXQ_TIME 11.0f

// 消息
#define FS_PL_CONTENT 14.0f
#define FS_PL_ORI_CONTENT 13.0f
#define FS_PL_NAME 12.0f
#define FS_PL_SELF_NAME 13.0f
#define FS_PL_TIME 12.0f

// 系统版本
#define KSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]
//#define KSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#define SYSTEM_VERSION_7 (KSystemVersion >= 7.0 && KSystemVersion < 8.0)
#define SYSTEM_VERSION_8 (KSystemVersion >= 8.0 && KSystemVersion < 9.0)
#define SYSTEM_VERSION_9 (KSystemVersion >= 9.0)
#define TARGET_IS_IOS8 (KSystemVersion >= 8.0)
#define TARGET_NOT_IOS8 (KSystemVersion < 8.0)

// AppStore下载链接
#define AppStoreUrlString @"https://itunes.apple.com/cn/app/id1068870786"
//#define AppStoreUrlString @"itms-apps://itunes.apple.com/cn/app/zhi-xing-huo-che-piao-for/id651323845?mt=8"

#define Url_Schema_Header_Qpk @"qiupaikong"

// 友盟统计
#define KUMengAppKey @"568a6864e0f55aac960035cb"
static NSString *kEventRacketKnockUp = @"event_RacketKnockUp";
static NSString *kEventWxSharePyq = @"event_WeixinSharePyq";
static NSString *kEventWxShareSession = @"event_WeixinShareSession";
static NSString *kEventGotoBuyPage = @"event_GotoBuyPage";
static NSString *kEventQQShareSession = @"event_QQShareSession";
static NSString *kEventQQShareQZone = @"event_QQShareQZone";

// qq相关
#define kLoginSuccessed @"loginSuccessed"
#define kLoginFailed    @"loginFailed"
#define KQQAppId @"1105067664"
#define KQQAppKey @"9fEw5qBo1rdYEzix"

// 微信相关
#define KWXAppId @"wxed3010d6d64e229e"
#define KAuthScope @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"
#define KAuthState @"xxx"
#define KAuthOpenID @"0c806938e2413ce73eef92cc3"

static NSString *kAPPContentTitle = @"App消息";
static NSString *kAPPContentDescription = @"这种消息只有App自己才能理解，由App指定打开方式";
static NSString *kAppContentExInfo = @"<xml>extend info</xml>";
static NSString *kAppContnetExURL = @"http://weixin.qq.com";
static NSString *kAppMessageExt = @"这是第三方带的测试字段";
static NSString *kAppMessageAction = @"<action>dotaliTest</action>";

static NSString *kLinkTagName = @"WECHAT_TAG_JUMP_APP";
static NSString *kImageTagName = @"WECHAT_TAG_JUMP_APP";
static NSString *kMessageExt = @"这是第三方带的测试字段";
static NSString *kMessageAction = @"<action>dotalist</action>";

// 生成的分享图片
static CGFloat kImageCompressScale = 0.4f;
static NSString *kShareImage = @"share_image_generate.jpg";
static NSString *kShareThumbImage = @"share_thumb_image_generate.jpg";

#define KSandBoxAbsoluteDirectory [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define KShareImagePath [NSString stringWithFormat:@"%@/%@",KSandBoxAbsoluteDirectory, kShareImage]
#define KShareThumbImagePath [NSString stringWithFormat:@"%@/%@",KSandBoxAbsoluteDirectory, kShareThumbImage]


#define IdentifierGoodsDetailAndEva @"toGoodsDetailAndEva"
#define IdentifierGotoBuyGoods @"gotoBuyGoods"
#define IdentifierEvaluationDetail @"toEvaluationDetail"
#define IdentifierSpecialTopicDetail @"toSpecialTopicDetail"
#define IdentifierGoodsSearch @"toGoodsSearchVC"
#define IdentifierRacketSearch @"toRacketSearchVC"
#define IdentifierRacketLineSearch @"toRacketLineSearchVC"
#define IdentifierSpecialTopicComment @"toSTCommentVC"
#define IdentifierAttentionVC @"toAttentionVC"
#define IdentifierFansVC @"toFansVC"
#define IdentifierJifenVC @"toJifenVC"
#define IdentifierWriteEvaluation @"toWriteEvalution"
#define IdentifierUserMessage @"toUserMessageVC"
#define IdentifierUserMainPage @"toPersonMainPage"
#define IdentifierAboutQPK @"toAboutQiuPaiKong"
#define IdentifierCompleteInfomation @"toCompleteUserInfomation"
#define IdentifierKnockUpReport @"toKnockUpReport"
#define IdentifierKnockUpResult @"toKnockUpResult"
#define IdentifierLoadLoginInVC @"loadLoginInVC"
#define IdentifierModifySexVC @"toModifySexVC"
#define IdentifierModifyLocationVC @"toModifyLocation"
#define IdentifierModifyPlayYearVC @"toModifyPlayYear"
#define IdentifierModifySelfEvaluVC @"toModifySelfEvaluate"
#define IdentifierModifyNickVC @"toModifyNickName"
#define IdentifierModifyRacketUsedVC @"toModifyRacketUsed"

#define IdentifierUserRegisterVC @"toUserRegisterVC"

#endif /* utilityVar_h */
