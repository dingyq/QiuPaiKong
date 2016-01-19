//
//  RadarChartView.m
//  QiuPai
//
//  Created by bigqiang on 15/12/16.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "RadarChartView.h"

@implementation RadarChartView

static CGPoint centerPoint;
static double PI = 3.14159267;
static CGFloat maxValue = 100.0f;
static CGFloat baseLineLength = 100.0f;
static CGFloat baseOriginY = 140.0f;
static NSInteger edgeCount = 5;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        centerPoint = CGPointMake(self.frame.size.width/2, baseOriginY);
    }
    return self;
}

- (void)setUserPropertyArr:(NSArray *)userPropertyArr {
    _userPropertyArr = [NSArray arrayWithArray:userPropertyArr];
    [self setNeedsDisplay];
}

// 覆盖drawRect方法，你可以在此自定义绘画和动画
- (void)drawRect:(CGRect)rect {
//    NSArray *colorArr = @[mUIColorWithRGB(223, 243, 236), mUIColorWithRGB(201, 236, 224), mUIColorWithRGB(185, 238, 217), mUIColorWithRGB(166, 234, 208), mUIColorWithRGB(149, 229, 199), mUIColorWithRGB(149, 229, 199)];
    NSMutableArray *colorArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < edgeCount; i ++) {
        [colorArr addObject:mUIColorWithRGB(223-16*i, 243-3*i, 236-7*i)];
    }
    
    CGFloat segGap = maxValue/edgeCount;
    NSMutableArray *acValueArrs = [[NSMutableArray alloc] init];
    for (int i = 0; i < edgeCount; i ++) {
        NSMutableArray *acarr = [[NSMutableArray alloc] init];
        for (int j = 0; j < edgeCount; j ++) {
            NSNumber *tmpNum = [NSNumber numberWithFloat:(maxValue - i * segGap)];
            [acarr addObject:tmpNum];
        }
        [acValueArrs addObject:acarr];
    }
    
    // 生成最外围的edgeCount个坐标点
    CGPoint edgePoints[edgeCount];
    [self getPoinstArr:edgePoints acValueArr:acValueArrs[0]];
    
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 文字辅助
    UIFont *font = [UIFont systemFontOfSize:14.0];//设置
    NSDictionary* fontDic = @{NSFontAttributeName:font, NSForegroundColorAttributeName:CustomGreenColor};
    NSArray *textTipArr = @[@"力量", @"旋转", @"球感", @"舒适度", @"控制", @"test", @"test", @"test", @"test"];
    CGRect textTipRect[edgeCount];
    [self generateRectWithPoints:edgePoints tarRectArr:textTipRect];
    for (int i = 0; i < edgeCount; i++) {
        [textTipArr[i] drawInRect:textTipRect[i] withAttributes:fontDic];
    }
    
    // 层次辅助
    UIColor *aColor = [UIColor colorWithRed:1 green:0.0 blue:0 alpha:1];
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    CGContextSaveGState(context);
    for (int i = 0; i < edgeCount; i++) {
        CGPoint tmpPoints[edgeCount];
        [self getPoinstArr:tmpPoints acValueArr:acValueArrs[i]];
        aColor = colorArr[i];
        CGContextSetStrokeColorWithColor(context, aColor.CGColor);//线框颜色
        CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
        CGContextAddLines(context, tmpPoints, edgeCount);//添加线
        CGContextClosePath(context);//封起来
        CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    }
    CGContextRestoreGState(context);// 恢复到之前的context
    
    // 自己实际属性
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, mUIColorWithRGBA(3, 189, 119, 0.6).CGColor);//线框颜色
    CGContextSetFillColorWithColor(context, mUIColorWithRGBA(3, 189, 119, 0.6).CGColor);//填充颜色
    if (_userPropertyArr && [_userPropertyArr count] > 0) {
        NSInteger arrCount = [_userPropertyArr count];
        CGPoint tmpPoints[arrCount];
        [self getPoinstArr:tmpPoints acValueArr:_userPropertyArr];
        CGContextAddLines(context, tmpPoints, arrCount);//添加线
        CGContextClosePath(context);//封起来
        CGContextDrawPath(context, kCGPathFill); //根据坐标绘制路径
    }
    CGContextRestoreGState(context);// 恢复到之前的context

    // 辅助白线
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    for (int i= 0; i < edgeCount; i++) {
        CGPoint aPoints[2];//坐标点
        aPoints[0] = centerPoint;
        aPoints[1] = edgePoints[i];
        CGContextAddLines(context, aPoints, 2);//添加线
        CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径

    }
    CGContextRestoreGState(context);// 恢复到之前的context
}

- (void)getPoinstArr:(CGPoint *)pointsArr acValueArr:(NSArray *)acVArr {
    for (int i = 0; i < [acVArr count]; i++) {
        CGFloat acValue = [[acVArr objectAtIndex:i] floatValue];
        pointsArr[i] = [self getPointPositionByIndex:i actualValue:acValue];
    }
}

- (CGRect *)generateRectWithPoints:(CGPoint *)pointsArr tarRectArr:(CGRect *)rectArr {
    CGFloat textWidth = 30;
    CGFloat textHeight = 17;
    CGFloat gap = 10.0f;
    for (int i = 0; i < edgeCount; i ++) {
        CGPoint tmpPoint = pointsArr[i];
        switch (i) {
            case 0:
            {
                rectArr[i] = CGRectMake(tmpPoint.x - textWidth/2, tmpPoint.y - textHeight - gap, textWidth, textHeight);
            }
                break;
            case 1:
            {
                rectArr[i] = CGRectMake(tmpPoint.x + gap, tmpPoint.y - textHeight/2, textWidth, textHeight);
            }
                break;
            case 2:
            {
                rectArr[i] = CGRectMake(tmpPoint.x + gap, tmpPoint.y + gap, textWidth, textHeight);
            }
                break;
            case 3:
            {
                rectArr[i] = CGRectMake(tmpPoint.x - textWidth - gap, tmpPoint.y + gap, textWidth, textHeight);
            }
                break;
            case 4:
            {
                rectArr[i] = CGRectMake(tmpPoint.x - textWidth - gap, tmpPoint.y - textHeight/2, textWidth, textHeight);
            }
                break;
                
            default:
                rectArr[i] = CGRectMake(tmpPoint.x - textWidth - gap, tmpPoint.y - textHeight/2, textWidth, textHeight);
                break;
        }
    }
    return rectArr;
}

// 从顶点开始，顺时针计算坐标
- (CGPoint)getPointPositionByIndex:(NSInteger)index actualValue:(CGFloat)acValue {
    CGFloat unitRadian = 2*PI/edgeCount;
    CGFloat currentRadian = index*unitRadian;
    CGFloat lineXDif = baseLineLength*(acValue/maxValue)*sin(currentRadian);
    CGFloat lineYDif = baseLineLength*(acValue/maxValue)*cos(currentRadian);
    return CGPointMake(centerPoint.x + lineXDif, centerPoint.y - lineYDif);
}

@end
