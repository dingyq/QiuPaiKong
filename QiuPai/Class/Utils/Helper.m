//
//  Helper.m
//  QiuPai
//
//  Created by bigqiang on 15/12/21.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "Helper.h"
#import "UIImageView+WebCache.h"
#import "QuartzCore/QuartzCore.h"

@implementation Helper

+ (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}

+ (void)showMoreOpMenu:(MenuItemClick)clickHandler cancelHandler:(MenuItemCancel)cancelHandler titles:(NSArray *)titlesArr tags:(NSArray *)tagsArr {
    if (!tagsArr) {
        return;
    }
    MoreOpearationMenu *tmpView = [[MoreOpearationMenu alloc] initWithTitles:titlesArr itemTags:tagsArr];
    [tmpView showActionSheetWithClickBlock:^(NSInteger tag){
        clickHandler(tag);
    } cancelBlock:cancelHandler];
}

+ (void)showShareSheetView:(ClickBlock)clickHandler showQZone:(BOOL)isShow cancelHandler:(CancelBlock)cancelHandler {
    NSMutableArray *shareConfig = [[NSMutableArray alloc] initWithArray:
                                                        @[@{@"name":@"微信", @"image":@"share_tip_wx.png"},
                                                          @{@"name":@"朋友圈", @"image":@"share_tip_pyq.png"},
                                                          @{@"name":@"QQ", @"image":@"share_tip_qq.png"}]];
    if (isShow) {
        [shareConfig addObject:@{@"name":@"空间", @"image":@"share_tip_qzone.png"}];
    }
    ShareSheetView *tmpView = [[ShareSheetView alloc] initWithTitleAndIcons:shareConfig];
    [tmpView showActionSheetWithClickBlock:^(NSInteger btnIndex){
        clickHandler(btnIndex);
    } cancelBlock:cancelHandler];
}

+ (UIImage*)createImageFromView:(UIView*)view {
    return [Helper createImageFromView:view compress:1];
}

+ (UIImage *)createImageFromView:(UIView*)view compress:(CGFloat)compress {
    // 创建一个bitmap的context, 并把它设置成为当前正在使用的context
    CGFloat scale = [UIScreen mainScreen].scale; // obtain scale
    // 开始绘图，下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.frame.size.width, view.frame.size.height), NO, scale);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:currnetContext];
    // 从当前context中创建一个改变大小后的图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    //将照片存入沙盒
    [Helper saveImage:image withName:kShareImage compress:compress];
    //将压缩后的照片存入沙盒
    CGFloat dWidth = view.frame.size.width;
    UIImage* _newImage = [Helper imageCompressForWidth:image targetWidth:dWidth];
    //压缩后的图片存入沙盒
    [Helper saveImage:_newImage withName:kShareThumbImage compress:compress/2];
    return image;
}

// 保存图片至沙盒
+ (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName compress:(CGFloat)compress {
    NSData *imageData = UIImageJPEGRepresentation(currentImage, compress);
    // 获取沙盒目录
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", KSandBoxAbsoluteDirectory, imageName];
    NSLog(@"fullPath is %@", fullPath);
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

//指定宽度按比例缩放
+ (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        } else {
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if (newImage == nil) {
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSInteger)getCurrentYear {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSInteger year = [dateComponent year];
    return year;
}

/**
 ** lineView:	   需要绘制成虚线的view
 ** lineLength:	 虚线的宽度
 ** lineSpacing:	虚线的间距
 ** lineColor:	  虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

/**
 ** 生成个人模板页面
 **/
+ (void)generateUserTemplateImage:(NSString *)name sex:(SexIndicator)sex headImage:(NSString *)imageUrl likeNum:(NSInteger)likeNum influence:(NSInteger)influence {
    
    CGFloat viewH = kFrameHeight;
    CGFloat viewW = kFrameWidth;
    
    UILabel *(^createTipLabel)(NSString *basePreStr, NSString *tipStr, NSString *baseNextStr, CGRect frame)
    = ^(NSString *basePreStr, NSString *tipStr, NSString *baseNextStr, CGRect frame){
        UILabel *tipL1 = [[UILabel alloc]initWithFrame:frame];
        tipL1.backgroundColor = [UIColor clearColor];
        [tipL1 setTextColor:Gray102Color];
        tipL1.textAlignment = NSTextAlignmentCenter;
        tipL1.font = [UIFont systemFontOfSize:18.0f];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", basePreStr, tipStr, baseNextStr]];
        NSInteger wordCount = tipStr.length;
        NSInteger beginPosi = basePreStr.length;
        [attributedStr addAttribute:NSFontAttributeName
                              value:[UIFont systemFontOfSize:18.0]
                              range:NSMakeRange(beginPosi, wordCount)];
        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:CustomGreenColor
                              range:NSMakeRange(beginPosi, wordCount)];
        tipL1.attributedText = attributedStr;
        
        return tipL1;
    };
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH)];
    tmpView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"the_bg_view"]];
    
    UIView *colorBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewW, 102)];
    [colorBg setBackgroundColor:CustomGreenColor];
    [tmpView addSubview:colorBg];
    
    CGFloat headW = 112.0f;
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(viewW/2-headW/2, 34, headW, headW)];
    headImage.layer.cornerRadius = headW/2;
    headImage.layer.borderColor = [UIColor whiteColor].CGColor;
    headImage.layer.borderWidth = 2.5f;
    [headImage setClipsToBounds:YES];
    [tmpView addSubview:headImage];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 166, viewW, 24)];
    [nameLabel setTextColor:CustomGreenColor];
    [nameLabel setFont:[UIFont systemFontOfSize:22.0f]];
    [nameLabel setText:name];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [tmpView addSubview:nameLabel];
    
    CGFloat labelBeginY = viewH/2 - 80;
    NSString *taTip = sex==SexIndicatorGirl?@"她":@"他";
    UILabel *tipL1 = createTipLabel([NSString stringWithFormat:@"%@在球拍控发表了", taTip], [NSString stringWithFormat:@"%d", 1], @"篇装备评测", CGRectMake(0, labelBeginY, viewW, 30));
    [tmpView addSubview:tipL1];
    
    UILabel *tipL2 = createTipLabel([NSString stringWithFormat:@"%@的精彩评测得到了", taTip], [NSString stringWithFormat:@"%ld", (long)likeNum], @"个喜欢", CGRectMake(0, labelBeginY + 57, viewW, 30));
    [tmpView addSubview:tipL2];
    
    UILabel *tipL3 = createTipLabel([NSString stringWithFormat:@"%@的见解已经影响了", taTip], [NSString stringWithFormat:@"%ld", (long)influence], @"位球友的选择", CGRectMake(0, labelBeginY + 114, viewW, 30));
    [tmpView addSubview:tipL3];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.72*viewH, viewW, 0.5)];
    [tmpView addSubview:lineView];
    [Helper drawDashLine:lineView lineLength:2 lineSpacing:2 lineColor:Gray166Color];
    
    UIImageView *qrCode = [[UIImageView alloc] initWithFrame:CGRectMake(viewW/2 - 62/2, CGRectGetMaxY(lineView.frame)+30, 62, 62)];
//    [qrCode setImage:[UIImage imageNamed:@"appStore_qr_code"]];
    [qrCode setImage:[UIImage imageNamed:@"wd_qr_code.jpg"]];
    [tmpView addSubview:qrCode];
    
    UILabel *downLoadTip = [[UILabel alloc] initWithFrame:CGRectMake(0, viewH - 78, viewW, 16)];
    [downLoadTip setTextColor:Gray102Color];
    [downLoadTip setFont:[UIFont systemFontOfSize:15.0f]];
    [downLoadTip setText:@"公众号qiupaico"];
    [downLoadTip setTextAlignment:NSTextAlignmentCenter];
    [tmpView addSubview:downLoadTip];
    
    UILabel *downLoadTip1 = [[UILabel alloc] initWithFrame:CGRectMake(0, viewH - 52, viewW, 16)];
    [downLoadTip1 setTextColor:Gray102Color];
    [downLoadTip1 setFont:[UIFont systemFontOfSize:15.0f]];
    [downLoadTip1 setText:@"下载球拍控，切磋网球装备使用心得"];
    [downLoadTip1 setTextAlignment:NSTextAlignmentCenter];
    [tmpView addSubview:downLoadTip1];
    
    [headImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_head"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [Helper createImageFromView:tmpView compress:0.8];
    }];
}

/**
 ** 生成商品模板页面
 **/
+ (void)generateGoodsTemplateImage:(NSString *)name racketImageUrl:(NSString *)racketImageUrl {
    CGFloat viewH = kFrameHeight;
    CGFloat viewW = kFrameWidth;
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH)];
    tmpView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"the_bg_view"]];
    
    UIView *colorBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewW, 162)];
    [colorBg setBackgroundColor:CustomGreenColor];
    [tmpView addSubview:colorBg];
    
    CGFloat headW = 218.0f;
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(viewW/2-headW/2, 49, headW, headW)];
    headImage.layer.cornerRadius = headW/2;
    headImage.layer.borderColor = [UIColor whiteColor].CGColor;
    headImage.layer.borderWidth = 2.5f;
    [headImage setClipsToBounds:YES];
    [tmpView addSubview:headImage];
    
    CGFloat labelBeginY = viewH/2 - 18;
    UILabel *tipL = [[UILabel alloc] initWithFrame:CGRectMake(0, labelBeginY, viewW, 16)];
    [tipL setTextColor:Gray102Color];
    [tipL setFont:[UIFont systemFontOfSize:18.0f]];
    [tipL setText:@"我在球拍控发现了一件很棒的装备"];
    [tipL setTextAlignment:NSTextAlignmentCenter];
    [tmpView addSubview:tipL];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, labelBeginY + 45, viewW, 24)];
    [nameLabel setTextColor:CustomGreenColor];
    [nameLabel setFont:[UIFont systemFontOfSize:17.0f]];
    [nameLabel setText:name];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [tmpView addSubview:nameLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.72*viewH, viewW, 0.5)];
    [tmpView addSubview:lineView];
    [Helper drawDashLine:lineView lineLength:2 lineSpacing:2 lineColor:Gray166Color];
    
    UIImageView *qrCode = [[UIImageView alloc] initWithFrame:CGRectMake(viewW/2 - 62/2, CGRectGetMaxY(lineView.frame)+30, 62, 62)];
//    [qrCode setImage:[UIImage imageNamed:@"appStore_qr_code"]];
    [qrCode setImage:[UIImage imageNamed:@"wd_qr_code.jpg"]];
    [tmpView addSubview:qrCode];
        
    UILabel *downLoadTip = [[UILabel alloc] initWithFrame:CGRectMake(0, viewH - 78, viewW, 16)];
    [downLoadTip setTextColor:Gray102Color];
    [downLoadTip setFont:[UIFont systemFontOfSize:15.0f]];
    [downLoadTip setText:@"公众号qiupaico"];
    [downLoadTip setTextAlignment:NSTextAlignmentCenter];
    [tmpView addSubview:downLoadTip];
    
    UILabel *downLoadTip1 = [[UILabel alloc] initWithFrame:CGRectMake(0, viewH - 52, viewW, 16)];
    [downLoadTip1 setTextColor:Gray102Color];
    [downLoadTip1 setFont:[UIFont systemFontOfSize:15.0f]];
    [downLoadTip1 setText:@"下载球拍控，切磋网球装备使用心得"];
    [downLoadTip1 setTextAlignment:NSTextAlignmentCenter];
    [tmpView addSubview:downLoadTip1];
    
    
    [headImage sd_setImageWithURL:[NSURL URLWithString:racketImageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_evaluation.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [Helper createImageFromView:tmpView compress:0.8];
    }];
}

+(UIImage *)bundleImageFile:(NSString *)imageName {
    NSBundle *bundle = [NSBundle mainBundle];
    return [UIImage imageWithContentsOfFile:[bundle pathForResource:[imageName stringByDeletingPathExtension]
                                                            ofType:[imageName pathExtension]]];
}

+ (void)uploadShareEventDataToUmeng:(ShareScene)shareScene content:(NSString *)content name:(NSString *)name cId:(NSInteger)contentId {
    NSString *event = @"";
    switch (shareScene) {
        case ShareScene_WxSession:
            event = kEventWxShareSession;
            break;
        case ShareScene_WxPyq:
            event = kEventWxSharePyq;
            break;
        case ShareScene_QQSession:
            event = kEventQQShareSession;
            break;
        case ShareScene_QZone:
            event = kEventQQShareQZone;
            break;
        default:
            break;
    }
    [MobClick event:event attributes:@{@"content":content, @"name":name, @"cId":[NSString stringWithFormat:@"%ld", (long)contentId]}];
}

+ (void)uploadGotoBuyPageDataToUmeng:(NSString *)name goodsId:(NSInteger)goodsId {
    [MobClick event:kEventGotoBuyPage attributes:@{@"goodsName":name, @"goodsId":[NSString stringWithFormat:@"%ld", (long)goodsId]}];
}

+ (void)uploadRacketKonckUpDataToUment:(GoodsType)goodsType goodsName:(NSString *)goodsName goodsId:(NSInteger)goodsId {
    [MobClick event:kEventRacketKnockUp attributes:@{@"goodsType":[NSString stringWithFormat:@"%ld", (long)goodsType], @"goodsName":goodsName, @"goodsId":[NSString stringWithFormat:@"%ld", (long)goodsId]}];
}


+ (void)showAlertView:(NSString *)tipStr {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:tipStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
//    
    DDAlertView *alertView = [[DDAlertView alloc] initWithTitle:tipStr itemTitles:@[@"确定"] itemTags:@[@100]];
    [alertView showWithClickBlock:^(NSInteger btnIndex) {
        
    }];
}

+ (NSString *)jiexi:(NSString *)cs webaddress:(NSString *)webAddress {
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",cs];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    // 执行匹配的过程
    // NSString *webaddress=@"http://wgpc.wzsafety.gov.cn/dd/adb.htm?adc=e12&xx=lkw&dalsjd=12";
    NSArray *matches = [regex matchesInString:webAddress
                                      options:0
                                        range:NSMakeRange(0, [webAddress length])];
    for (NSTextCheckingResult *match in matches) {
        //NSRange matchRange = [match range];
        //NSString *tagString = [webaddress substringWithRange:matchRange];  // 整个匹配串
        //        NSRange r1 = [match rangeAtIndex:1];
        //        if (!NSEqualRanges(r1, NSMakeRange(NSNotFound, 0))) {    // 由时分组1可能没有找到相应的匹配，用这种办法来判断
        //            //NSString *tagName = [webaddress substringWithRange:r1];  // 分组1所对应的串
        //            return @"";
        //        }
        
        NSString *tagValue = [webAddress substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        //    NSLog(@"分组2所对应的串:%@\n",tagValue);
        return tagValue;
    }
    return @"";
}

//根据颜色返回图片
+ (UIImage*)imageWithColor:(UIColor*)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
