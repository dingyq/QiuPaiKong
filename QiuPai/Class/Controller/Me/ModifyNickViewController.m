//
//  ModifyNickViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/12/20.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "ModifyNickViewController.h"

#define MAX_LENGTH 20

@interface ModifyNickViewController()<UITextFieldDelegate> {
    UITextField *_nameInput;
}

@end

@implementation ModifyNickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:VCViewBGColor];
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setFrame:CGRectMake(0, 0, 40, 25)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存" forState:UIControlStateHighlighted];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [saveBtn setTitleColor:Gray153Color forState:UIControlStateDisabled];
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [self initNickNameInputView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_nameInput becomeFirstResponder];
    _nameInput.text = _nickName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveBtnClick:(UIButton *)sender {
    [_nameInput resignFirstResponder];
    
    _nickName = _nameInput.text;
    [self.callDelegate nickNameModify:_nickName];
    [self backToPreVC:nil];
}

- (void)initNickNameInputView {
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 17, kFrameWidth, 43)];
    [tmpView setBackgroundColor:[UIColor whiteColor]];
    _nameInput = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, kFrameWidth-20, 43)];
    _nameInput.delegate = self;
    [_nameInput setBorderStyle:UITextBorderStyleNone]; //外框类型
//    [_nameInput setBackgroundColor:[UIColor whiteColor]];
    _nameInput.placeholder = @"昵称"; //默认显示的字

    _nameInput.autocorrectionType = UITextAutocorrectionTypeNo;
    _nameInput.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _nameInput.returnKeyType = UIReturnKeyDone;
    _nameInput.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    [tmpView addSubview:_nameInput];
    
    UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 0.5f)];
    [upLine setBackgroundColor:LineViewColor];
    [tmpView addSubview:upLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 42.5, kFrameWidth, 0.5f)];
    [bottomLine setBackgroundColor:LineViewColor];
    [tmpView addSubview:bottomLine];
    
    [self.view addSubview:tmpView];
}

- (void)setNickName:(NSString *)nickName {
    _nickName = nickName;
    _nameInput.text = nickName;
}

// 触摸事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [_nameInput resignFirstResponder];
}

#pragma -mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_nameInput resignFirstResponder];
    return YES;
}

// 可以在UITextField使用下面方法，按return键返回
-(void)textFieldDone:(id) sender {
    [_nameInput resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.location >= MAX_LENGTH)
        return NO; // return NO to not change text
    return YES;
}

@end
