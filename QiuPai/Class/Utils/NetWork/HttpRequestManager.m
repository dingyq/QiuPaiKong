//
//  HttpRequestManager.m
//  QiuPai
//
//  Created by bigqiang on 15/11/10.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "HttpRequestManager.h"
#import "QiuPaiUserModel.h"

//static NSString *requestBaseUrl = @"http://qiupai.co/qpkServer/cgi/user_svc.php";


@interface HttpRequestManager() {
    AFHTTPRequestOperationManager *_manager;
}

@property (nonatomic,strong) AFHTTPRequestOperation *httpOperation;

@end


@implementation HttpRequestManager

#pragma mark - 对外公开接口
+ (HttpRequestManager *)shareManager {
    static HttpRequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        if (manager == nil) {
            manager = [[HttpRequestManager alloc] init];
        }
    });
    return manager;
}

- (void)completeParameterOfRequestInfo:(RequestInfo *)requestInfo {
    
    if (!requestInfo.method) {
        requestInfo.method = HttpRequestMethod_POST;
    }
    
    if (!requestInfo.urlStr) {
        requestInfo.urlStr = Request_Base_Url;
    }

    [requestInfo.jsonDict setObject:[QiuPaiUserModel getUserInstance].userId forKey:@"userId"];
    [requestInfo.jsonDict setObject:[QiuPaiUserModel getUserInstance].authKey forKey:@"authkey"];
//    [requestInfo.jsonDict setObject:@"abc" forKey:@"authkey"];
    [requestInfo.jsonDict setObject:Request_Version forKey:@"version"];
    [requestInfo.jsonDict setObject:Request_Channel forKey:@"fromWhere"];
    [requestInfo.jsonDict setObject:Request_Platform forKey:@"platform"];

}

- (void)startAsyncHttpRequestWithRequestInfo:(RequestInfo *)requestInfo {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    if (requestInfo.jsonDict) {
        jsonDict = requestInfo.jsonDict;
    }
    //补全请求信息
    [self completeParameterOfRequestInfo:requestInfo];
    
    switch (requestInfo.requestID) {
        case RequestID_SendComment:
        case RequestID_PublishNewEvaluation:
        case RequestID_UploadImage:
        case RequestID_SendUserCollect:
//        case RequestID_SendUserShare:
        case RequestID_SendUserAttention:
        case RequestID_GetUserListRelatedWithMe:
        case RequestID_GetCommentAndPraised:
        case RequestID_GetAllMyLikedInfo:
        case RequestID_KnockUpDirectly:
        case RequestID_CompleteSelfInfomation:
        case RequestID_SendUserZan:
        case RequestID_DeleteUGCContent:
        case RequestID_ReportUGCContent:
        case RequestID_GetUserInfo:
        case RequestID_ModifyPersonalInfo:
        case RequestID_GetAllMessageInfo:
        {
            if ([[QiuPaiUserModel getUserInstance] isTimeOut]) {
                [[QiuPaiUserModel getUserInstance] showUserLoginVC];
                return;
            }
        }
            break;
        default:
            break;
    }
    
    if (!requestInfo.method) {
        requestInfo.method = HttpRequestMethod_POST;
    }
    
    //不同的请求方式
    if (requestInfo.method == HttpRequestMethod_GET) {
        self.httpOperation = [_manager GET:requestInfo.urlStr parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //请求成功，转换成json字典
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
            [requestInfo.delegate netWorkFinishedCallBack:dic withRequestID:requestInfo.requestID];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //请求失败
            [requestInfo.delegate netWorkFailedCallback:error withRequestID:requestInfo.requestID];
        }];
        return;
    }
    if (requestInfo.method == HttpRequestMethod_POST) {
        self.httpOperation = [_manager POST:requestInfo.urlStr parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
            if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkAuthKeyExpr) {
                [QiuPaiUserModel getUserInstance].isTimeOut = YES;
                [[QiuPaiUserModel getUserInstance] showUserLoginVC];
                return;
            }
            NSLog(@"dic is %@", dic);
            [requestInfo.delegate netWorkFinishedCallBack:dic withRequestID:requestInfo.requestID];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [requestInfo.delegate netWorkFailedCallback:error withRequestID:requestInfo.requestID];
        }];
        return;
    }
    if (requestInfo.method == HttpRequestMethod_PUT) {
        self.httpOperation = [_manager PUT:requestInfo.urlStr parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
            [requestInfo.delegate netWorkFinishedCallBack:dic withRequestID:requestInfo.requestID];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [requestInfo.delegate netWorkFailedCallback:error withRequestID:requestInfo.requestID];
        }];
        return;
    }
    if (requestInfo.method == HttpRequestMethod_DELETE) {
        self.httpOperation = [_manager DELETE:requestInfo.urlStr parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
            [requestInfo.delegate netWorkFinishedCallBack:dic withRequestID:requestInfo.requestID];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [requestInfo.delegate netWorkFailedCallback:error withRequestID:requestInfo.requestID];
        }];
        return;
    }
    if (requestInfo.method == HttpRequestMethod_IMAGE) {
        self.httpOperation = [_manager POST:requestInfo.urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:requestInfo.imgData name:@"file" fileName:@"icon.jpg" mimeType:@"image/*"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
            [requestInfo.delegate netWorkFinishedCallBack:dic withRequestID:requestInfo.requestID];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [requestInfo.delegate netWorkFailedCallback:error withRequestID:requestInfo.requestID];
        }];
    }
}

- (void)sendUploadImageFileRequest1:(RequestInfo *)requestInfo {
    NSDictionary *parameters = @{@"name":@"额外的请求参数"};
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    [requestManager POST:Request_UploadImage_Url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        /**
         *  appendPartWithFileURL   //  指定上传的文件
         *  name                    //  指定在服务器中获取对应文件或文本时的key
         *  fileName                //  指定上传文件的原始文件名
         *  mimeType                //  指定商家文件的MIME类型
         */
        [formData appendPartWithFileData:requestInfo.imgData name:@"file" fileName:requestInfo.fileName  mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        [requestInfo.delegate netWorkFinishedCallBack:dic withRequestID:requestInfo.requestID];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [requestInfo.delegate netWorkFailedCallback:error withRequestID:requestInfo.requestID];
    }];
}

- (void)sendUploadImageFileRequest:(RequestInfo *)requestInfo {
    NSDictionary *parameters = @{@"name":@"额外的请求参数"};
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFHTTPRequestOperation *o2= [manager POST:Request_UploadImage_Url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:requestInfo.imgData name:@"file" fileName:requestInfo.fileName  mimeType:@"image/jpg"];
//        NSLog([NSString stringWithFormat:@"%ld", requestInfo.imgData.length]);
        NSLog(@"requestInfo.imgData byte length is %ld", (long)[requestInfo.imgData length]);
        
    }success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSDictionary *dic = (NSDictionary *)responseObject;
        [requestInfo.delegate netWorkFinishedCallBack:dic withRequestID:requestInfo.requestID];
    }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        [requestInfo.delegate netWorkFailedCallback:error withRequestID:requestInfo.requestID];
    }];
    //设置上传操作的进度
    [o2 setUploadProgressBlock:^(NSUInteger bytesWritten,long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        NSLog(@"bytesWritten:%ld totalBytesWritten:%lld   totalBytesExpectedToWrite:%lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        if (requestInfo.uploadProgress) {
            requestInfo.uploadProgress(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        }
        
    }];
}

- (void)cancelRequest {
    [self.httpOperation cancel];
}

- (id)init {
    if (self = [super init]) {
        _manager = [[AFHTTPRequestOperationManager alloc]init];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        _manager.requestSerializer=[AFJSONRequestSerializer serializer];
    }
    return self;
}


#pragma mark - 添加请求体信息，可自定义
- (void)createHttpHeader {
    
}

+ (RequestInfo *)sendUploadImageRequest:(UIImage *)image fileName:(NSString *)fileName {
    RequestInfo *info = [[RequestInfo alloc]init];
    CGFloat compress = kImageCompressScale;
    [Helper saveImage:image withName:[NSString stringWithFormat:@"11%@", fileName] compress:compress];
    info.imgData = UIImageJPEGRepresentation(image, compress);
    info.fileName = [NSString stringWithFormat:@"%@.jpg", fileName];
    info.urlStr = Request_UploadImage_Url;
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_UploadImage;
    [[HttpRequestManager shareManager] sendUploadImageFileRequest:info];
    return info;
}

+ (RequestInfo *)reportUGCContent:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc]init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x3201] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_ReportUGCContent;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}

+ (RequestInfo *)deleteUGCContent:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc]init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x3107] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_DeleteUGCContent;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}

+ (RequestInfo *)sendUserZanRequest:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc]init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x3106] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_SendUserZan;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}

+ (RequestInfo *)sendUserComment:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc]init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x3105] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_SendComment;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}

+ (RequestInfo *)sendUserShareRequest:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc]init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x3104] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_SendUserShare;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}

+ (RequestInfo *)sendUserCollectRequest:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc]init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x3103] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_SendUserCollect;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}

+ (RequestInfo *)sendUserAttentionRequest:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc]init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x3102] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_SendUserAttention;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}

+ (RequestInfo *)publishNewEvaluation:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc]init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x3101] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_PublishNewEvaluation;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}

+ (RequestInfo *)getGoodsSearchList:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc] init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x300b] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_SearchGoodsList;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}

+ (RequestInfo *)getAttentionedOrFansUsersList:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc]init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x3009] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_GetUserListRelatedWithMe;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}

+ (RequestInfo *)getAllMyLikedInfoList:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc]init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x3008] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_GetAllMyLikedInfo;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}

+ (RequestInfo *)getCommentAndPraisedInfoList:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc]init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x3007] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_GetCommentAndPraised;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}

+ (RequestInfo *)getEvaluationDetailInfo:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc]init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x3006] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_GetEvaluationDetailInfo;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}

+ (RequestInfo *)getGoodsDetailAndEvaluationList:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc]init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x3005] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_GetGoodsDetailAndEvaluation;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}

+ (RequestInfo *)getSpecialTopicDetailInfo:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc]init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x3004] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_GetSpecialTopicDetail;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}

+ (RequestInfo *)getUserMainPageInfo:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc]init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x3003] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_GetUserMainPageInfo;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}

+ (RequestInfo *)getCircleInfo:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc]init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x3002] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_GetCircleInfo;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}

+ (RequestInfo *)getPreciseSelectInfo:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc]init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x3001] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_GetPreciseSelect;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}

// 直接虚拟试打
+ (RequestInfo *)knockUpDirectly:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc]init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x2004] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_KnockUpDirectly;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}

// 完善资料后虚拟试打
+ (RequestInfo *)completeInfomationAndKnockUp:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc]init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x2003] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_CompleteSelfInfomation;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}


+ (RequestInfo *)findPwdBack:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc]init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x100a] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_FindPwdBack;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}

+ (RequestInfo *)modifyPwd:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc]init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x1009] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_ModifyPwd;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}

+ (RequestInfo *)getMobileAuthCode:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc]init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x1008] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_GetMobileAuthCode;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}

+ (RequestInfo *)getAllNewMessageTip:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc]init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x1007] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_GetAllMessageInfo;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}

+ (RequestInfo *)getUserInfo:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc]init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x1006] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_GetUserInfo;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}

+ (RequestInfo *)modifyPersonalInfo:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc]init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x1005] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_ModifyPersonalInfo;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}

+ (RequestInfo *)sendUserLoginRequest:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc]init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x1002] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_SendUserLoginRequest;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}

+ (RequestInfo *)sendUserRegisterRequest:(NSDictionary *)requestInfo {
    RequestInfo *info = [[RequestInfo alloc]init];
    info.jsonDict = [[NSMutableDictionary alloc] initWithDictionary:requestInfo];
    [info.jsonDict setObject:[NSNumber numberWithInteger:0x1001] forKey:@"cmd"];
    info.method = HttpRequestMethod_POST;
    info.requestID = RequestID_SendUserRegisterRequest;
    [[HttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info];
    return info;
}



@end
