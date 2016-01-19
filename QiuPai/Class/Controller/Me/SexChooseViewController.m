//
//  SexChooseViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/12/18.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "SexChooseViewController.h"

@interface SexChooseViewController () {
    UIView *_panelView;
}

@end

@implementation SexChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"性别";
    [self.view setBackgroundColor:VCViewBGColor];
    
    [self initSexChoosePanel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resetSexSelected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSexChoosePanel {
    void(^createBtn)(NSString *title, NSInteger tag, CGRect frame, SEL btnEvent, UIView *parent) = ^(NSString *title, NSInteger tag, CGRect frame, SEL btnEvent, UIView *parent){
        UIButton *maleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [maleBtn setFrame:frame];
        [maleBtn setTitle:title forState:UIControlStateNormal];
        [maleBtn setTitle:title forState:UIControlStateNormal];
        [maleBtn setTitleColor:Gray51Color forState:UIControlStateNormal];
        [maleBtn setTitleColor:CustomGreenColor forState:UIControlStateSelected];
        maleBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [maleBtn setTag:tag];
        [maleBtn addTarget:self action:btnEvent forControlEvents:UIControlEventTouchUpInside];
        [parent addSubview:maleBtn];
    };
    
    CGFloat panelH = 85.0f;
    _panelView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 17, kFrameWidth, panelH)];
    [_panelView setBackgroundColor:[UIColor whiteColor]];
    createBtn(@"男", 100, CGRectMake(0, 0, kFrameWidth, panelH/2), @selector(sexButtonClick:), _panelView);
    createBtn(@"女", 200, CGRectMake(0, panelH/2, kFrameWidth, panelH/2), @selector(sexButtonClick:), _panelView);
    
    UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 0.5)];
    [upLine setBackgroundColor:LineViewColor];
    [_panelView addSubview:upLine];
    
    UIView *middleLine = [[UIView alloc] initWithFrame:CGRectMake(10, 85/2, kFrameWidth - 10, 0.5)];
    [middleLine setBackgroundColor:LineViewColor];
    [_panelView addSubview:middleLine];
    
    UIView *downLine = [[UIView alloc] initWithFrame:CGRectMake(0, 84.5, kFrameWidth, 0.5)];
    [downLine setBackgroundColor:LineViewColor];
    [_panelView addSubview:downLine];
    
    [self.view addSubview:_panelView];
}

- (void)sexButtonClick:(UIButton *)sender {
    _sex = sender.tag/100 - 1;
    [self resetSexSelected];
    [self.callDelegate sexChooseDone:_sex];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)resetSexSelected {
    for (UIButton *btn in [_panelView subviews]) {
        if ([NSStringFromClass([btn class]) isEqualToString:NSStringFromClass([UIButton class])]) {
            [btn setSelected:NO];
        }
        
        if ([btn tag] == (_sex+1)*100) {
            [btn setSelected:YES];
        }
    }
}

- (void)setSex:(SexIndicator)sex {
    _sex = sex;
    [self resetSexSelected];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
