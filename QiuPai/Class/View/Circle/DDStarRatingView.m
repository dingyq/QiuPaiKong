//
//  DDStarRatingView.m
//  QiuPai
//
//  Created by bigqiang on 15/12/16.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "DDStarRatingView.h"

@interface DDStarRatingView() {
    UIView *_starView;
}

@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;

@end

@implementation DDStarRatingView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame numberOfStar:5];
}

static CGRect selfFrame;
static CGFloat gap = 5.0f;
static CGFloat starWidth = 21.0f;
static CGFloat acStarViewWidth;
static CGFloat originX;

- (instancetype)initWithFrame:(CGRect)frame numberOfStar:(NSInteger)number {
    self = [super initWithFrame:frame];
    if (self) {
        selfFrame = self.bounds;
        acStarViewWidth = _numberOfStar * starWidth + (_numberOfStar - 1) * gap;
        originX = frame.size.width/2 - acStarViewWidth/2 - 35;
        
        _numberOfStar = number;
        self.starBackgroundView = [self buidlStarViewWithImageName:@"rating_gray_star.png"];
        self.starForegroundView = [self buidlStarViewWithImageName:@"rating_light_star.png"];
        [self addSubview:self.starBackgroundView];
        [self addSubview:self.starForegroundView];
        
        [self updateForegroundViewWithScore:96];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, originX - 12, frame.size.height)];
        [tipLabel setBackgroundColor:[UIColor clearColor]];
        [tipLabel setTextAlignment:NSTextAlignmentRight];
        [tipLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [tipLabel setTextColor:Gray153Color];
        [tipLabel setText:@"匹配指数"];
        [self addSubview:tipLabel];
    }
    return self;
}

- (void)setCurrentScore:(CGFloat)currentScore {
    _currentScore = currentScore;
    [self updateForegroundViewWithScore:currentScore];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(CGRectContainsPoint(rect,point)) {
        [self changeStarForegroundViewWithPoint:point];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __weak DDStarRatingView * weekSelf = self;
    
    [UIView transitionWithView:self.starForegroundView
                      duration:0.2
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^
     {
         [weekSelf changeStarForegroundViewWithPoint:point];
     }
                    completion:^(BOOL finished)
     {
         
     }];
}

- (UIView *)buidlStarViewWithImageName:(NSString *)imageName {
    UIView *view = [[UIView alloc] initWithFrame:selfFrame];
    view.clipsToBounds = YES;
    
    for (int i = 0; i < self.numberOfStar; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(originX + i*(starWidth + gap), selfFrame.size.height/2 - starWidth/2, 21, 21);
        [view addSubview:imageView];
    }
    return view;
}

- (void)changeStarForegroundViewWithPoint:(CGPoint)point {
    CGPoint p = point;
    if (p.x < 0) {
        p.x = 0;
    } else if (p.x > self.frame.size.width) {
        p.x = self.frame.size.width;
    }
    
    NSString * str = [NSString stringWithFormat:@"%0.2f",p.x / self.frame.size.width];
    float score = [str floatValue];
    p.x = score * self.frame.size.width;
//    self.starForegroundView.frame = CGRectMake(0, 0, p.x, self.frame.size.height);
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingView: score:)]) {
        [self.delegate starRatingView:self score:score];
    }
}

- (void)updateForegroundViewWithScore:(CGFloat)score {
    CGFloat scorePerStar = 100.0/_numberOfStar;
    NSInteger gapCount = score/(scorePerStar);
    CGFloat newForeWidth = originX + starWidth * _numberOfStar * (score/100.0) + gapCount * gap;
    CGRect originRect = self.starForegroundView.frame;
    originRect.size.width = newForeWidth;
    [self.starForegroundView setFrame:originRect];
}


@end
