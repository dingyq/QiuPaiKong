//
//  QQHelper.m
//  QiuPai
//
//  Created by bigqiang on 16/1/5.
//  Copyright © 2016年 barbecue. All rights reserved.
//

#import "QQHelper.h"

@implementation QQHelper

+ (void)shareImageMsg:(NSString *)title description:(NSString *)desc scene:(QQShareScene)scene callBack:(QQCallBack)successHandler {
    UIImage *tmpImage = [UIImage imageWithContentsOfFile:KShareImagePath];
    NSData *imageData = UIImageJPEGRepresentation(tmpImage, 1.0);
    UIImage *thumbImage =[UIImage imageWithContentsOfFile:KShareThumbImagePath];
    NSData *thumbImageData = UIImageJPEGRepresentation(thumbImage, 1.0);
    
    QQApiImageObject* img = [QQApiImageObject objectWithData:imageData previewImageData:thumbImageData title:title description:desc];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    if (scene == QQShareScene_QZone) {
        [img setCflag:kQQAPICtrlFlagQZoneShareOnStart];
    } else {
        //        [img setCflag:kQQAPICtrlFlagQQShare];
    }
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent callBack:successHandler];
}

+ (void)sendNewsMessageWithLocalImage:(UIImage *)image pageUrl:(NSString *)pageUrl title:(NSString *)title description:(NSString *)desc scene:(QQShareScene)scene callBack:(QQCallBack)successHandler {
    NSData* data = UIImageJPEGRepresentation(image, 1.0);
    NSURL* url = [NSURL URLWithString:pageUrl];

    QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:title description:desc previewImageData:data];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    if (scene == QQShareScene_QZone) {
        [img setCflag:kQQAPICtrlFlagQZoneShareOnStart];
    } else {
        //        [img setCflag:kQQAPICtrlFlagQQShare];
    }
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent callBack:successHandler];
}

+ (void)sendNewsMessageWithNetworkImage:(NSString *)imageUrl pageUrl:(NSString *)pageUrl title:(NSString *)title description:(NSString *)desc scene:(QQShareScene)scene callBack:(QQCallBack)successHandler {
    NSURL *previewURL = [NSURL URLWithString:imageUrl];
    NSURL* url = [NSURL URLWithString:pageUrl];
    
    QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:title description:desc previewImageURL:previewURL];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    if (scene == QQShareScene_QZone) {
        [img setCflag:kQQAPICtrlFlagQZoneShareOnStart];
    } else {
//        [img setCflag:kQQAPICtrlFlagQQShare];
    }
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent callBack:successHandler];
}

+ (void)handleSendResult:(QQApiSendResultCode)sendResult callBack:(QQCallBack)successHandler {
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"" message:@"请等待加载完毕后再尝试分享" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        default:
        {
            // qq暂时无法十分准确的统计到是否真的分享成功
            NSLog(@"分享成功");
            successHandler(sendResult);
            break;
        }
    }
}

@end
