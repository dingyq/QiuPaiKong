//
//  DDTextBoxView.m
//  QiuPai
//
//  Created by bigqiang on 15/11/19.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "DDTextBoxView.h"
#import "PlaceHolderTextView.h"
#import "ZLPhoto.h"
#import "UIImage+ImageFixOrientaion.h"

#define ImageViewHeight ((kFrameWidth/3) + 50)

@interface DDTextBoxView() <ZLPhotoPickerViewControllerDelegate>{
    UIButton *_sendBtn;
    UIButton *_addImageBtn;
    CGRect _originalFrame;
    CGRect _newFrame;
    CGRect _editBarFrame;
    NSArray *_sendBtnConstraintsArr;
    NSArray *_likeBtnConstraintsArr;
    
    NSLayoutConstraint *_textViewLeftC;
    
    UIView *_editBarView;
    
    BOOL _isAddImage;
    
    NSInteger _imageTotalNum;
    
    UIButton *_pAddImage;
    
    NSString *_initPlaceHolderStr;
    
    BOOL _responseToLike;
    
    BOOL _visitorReply;
}
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSMutableArray *imagePickedArr; // 临时存储相册选取的照片

@end

@implementation DDTextBoxView

@synthesize textView = _textView;
@synthesize checkBtn = _checkBtn;
@synthesize myDelegate = _myDelegate;
@synthesize isReply = _isReply;
@synthesize isUserLike = _isUserLike;
@synthesize isSelfEvalu = _isSelfEvalu;


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _isSelfEvalu = NO;
        _isAddImage = NO;
        _isReply = YES;
        _visitorReply = NO;
        _isShowLike = NO;
        
        _originalFrame = frame;
        _newFrame = frame;
        _imageTotalNum = 1;
        _initPlaceHolderStr = @"评论一下吧";
        
        [self initUI];
        [self initButtonsConstraint];
        [self resetViewWithTheKeyboardState:NO];
        
        //注册监听键盘事件的通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)initUI {
    _editBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 49)];
    [_editBarView setBackgroundColor:Gray233Color];
    [self addSubview:_editBarView];
    
    _pAddImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pAddImage setImage:[UIImage imageNamed:@"publish_add_image_btn"] forState:UIControlStateNormal];
    [_pAddImage setImage:[UIImage imageNamed:@"publish_add_image_btn"] forState:UIControlStateHighlighted];
    [_pAddImage setImage:[UIImage imageNamed:@"publish_add_image_btn"] forState:UIControlStateSelected];
    [_pAddImage setFrame:CGRectMake(kFrameWidth/2-25, 49 + ImageViewHeight/2-25, 50, 50)];
    [self addSubview:_pAddImage];
    [_pAddImage addTarget:self action:@selector(openPhotoLibrary:) forControlEvents:UIControlEventTouchUpInside];

    _textView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(12, 5, kFrameWidth - 100, 39)];
    [_textView setBackgroundColor:[UIColor whiteColor]];
    [_textView setFont:[UIFont systemFontOfSize:15.0f]];
    [_textView setTextColor:Gray51Color];
//    _textView.contentMode = UIViewContentModeCenter;
    _textView.contentInset = UIEdgeInsetsMake(3, 0, 0, 0);
    _textView.layer.borderWidth = 1;
    _textView.layer.cornerRadius = 4.0f;
    _textView.layer.borderColor = Gray233Color.CGColor;
    _textView.layer.masksToBounds = YES;
    _textView.delegate = self;
    [_editBarView addSubview:_textView];
    _textView.translatesAutoresizingMaskIntoConstraints = NO;

    
    _textViewLeftC = [NSLayoutConstraint constraintWithItem:_textView
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_editBarView
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:12];
    
    NSLayoutConstraint * right_c = [NSLayoutConstraint constraintWithItem:_textView
                                                               attribute:NSLayoutAttributeRight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_editBarView
                                                               attribute:NSLayoutAttributeRight
                                                              multiplier:1.0
                                                                constant:-57.0];
    
    NSLayoutConstraint * top_c = [NSLayoutConstraint constraintWithItem:_textView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_editBarView
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:5];
    
    NSLayoutConstraint * bottom_c = [NSLayoutConstraint constraintWithItem:_textView
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_editBarView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:-5];
    [self addConstraints:@[right_c, top_c, bottom_c]];
    [self addConstraint:_textViewLeftC];

    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendBtn setFrame:CGRectMake(kFrameWidth - 40, 5, 40, 29)];
    [_sendBtn setTitleColor:CustomGreenColor forState:UIControlStateNormal];
    [_sendBtn setTitleColor:CustomGreenColor forState:UIControlStateHighlighted];
    [_sendBtn setTitleColor:CustomGreenColor forState:UIControlStateSelected];
    [_sendBtn setTitleColor:Gray153Color forState:UIControlStateDisabled];
    _sendBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [_editBarView addSubview:_sendBtn];
    [_sendBtn addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _sendBtn.translatesAutoresizingMaskIntoConstraints = NO;
}

// 自定义setIsSelfEvalu方法，并据此来初始化输入框样式
- (void)setIsSelfEvalu:(BOOL)isSelfEvalu {
    _isSelfEvalu = isSelfEvalu;
    if (_isSelfEvalu) {
        _initPlaceHolderStr = @"继续补充评测内容";
    }
    _isReply = !isSelfEvalu;
    _textView.placeholder = _initPlaceHolderStr;
    [self resetViewWithTheKeyboardState:NO];
}

// 自定义setIsReply方法，并据此来初始化输入框样式
- (void)setIsReply:(BOOL)isReply {
    _isReply = isReply;
    _visitorReply = isReply;
    if (isReply) {
        // 当重新回复其他人时，清空之前的输入
        [_textView setText:@""];
    }
    [self resetViewWithTheKeyboardState:isReply];
}

- (void)setIsUserLike:(BOOL)isUserLike {
    _isUserLike = isUserLike;
    
    [self resetViewWithTheKeyboardState:NO];
}

- (void)setIsShowLike:(BOOL)isShowLike {
    _isShowLike = isShowLike;
    [self resetViewWithTheKeyboardState:NO];
}

- (NSMutableArray *)assets{
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}

- (NSMutableArray *)imagePickedArr{
    if (!_imagePickedArr) {
        _imagePickedArr = [NSMutableArray array];
    }
    return _imagePickedArr;
}

- (void)updateLikeBtnState:(BOOL)isNow {
    if (_isUserLike && isNow) {
        [_sendBtn setSelected:YES];
    } else {
        [_sendBtn setSelected:NO];
    }
}

- (void)resetSendBtnEnabledState {
    if ([[_textView text] isEqualToString:@""]) {
        [_sendBtn setEnabled:NO];
    } else {
        [_sendBtn setEnabled:YES];
    }
}

- (void)setSendBtnState:(NSString *)title withImage:(BOOL)isShow {
    [_sendBtn setTitle:title forState:UIControlStateNormal];
    [_sendBtn setTitle:title forState:UIControlStateSelected];
    [_sendBtn setTitle:title forState:UIControlStateHighlighted];
    [_sendBtn setTitle:title forState:UIControlStateDisabled];
    
    if (isShow) {
        [_sendBtn setFrame:CGRectMake(0, 0, 29, 29)];
        [_sendBtn setBackgroundImage:[UIImage imageNamed:@"like_button_green_nor.png"] forState:UIControlStateNormal];
        [_sendBtn setBackgroundImage:[UIImage imageNamed:@"like_button_green_sel.png"] forState:UIControlStateSelected];
        [_sendBtn setBackgroundImage:[UIImage imageNamed:@"like_button_green_nor.png"] forState:UIControlStateDisabled];
        
        [self removeConstraints:_sendBtnConstraintsArr];
        [self addConstraints:_likeBtnConstraintsArr];
        
        _responseToLike = YES;
    } else {
        [_sendBtn setFrame:CGRectMake(0, 0, 40, 29)];
        [_sendBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [_sendBtn setBackgroundImage:nil forState:UIControlStateSelected];
        [_sendBtn setBackgroundImage:nil forState:UIControlStateDisabled];
        
        [self removeConstraints:_likeBtnConstraintsArr];
        [self addConstraints:_sendBtnConstraintsArr];
        
        _responseToLike = NO;
    }
    
    [self updateLikeBtnState:_responseToLike];
}

// 根据键盘弹出或收起的情况重新排版界面
- (void)resetViewWithTheKeyboardState:(BOOL)isDisplay {
    if (self.isSelfEvalu) {
        // 自己发的评测
        NSString *titleStr = @"发送";
        BOOL isShowAddImage = YES;
        if (_isReply) {
            // 回复他人
            titleStr = @"回复";
            isShowAddImage = NO;
        } else {
            isShowAddImage = isDisplay;
        }
        [self setSendBtnState:titleStr withImage:NO];
        [self resetSendBtnEnabledState];
        [self showAddPhotoButton:isShowAddImage];
        
        return;
    }
        
    if (!self.isShowLike) {
        NSString *titleStr = @"发送";
        if (_visitorReply) {
            // 回复他人
            titleStr = @"回复";
        }
        [self setSendBtnState:titleStr withImage:NO];
        [self showAddPhotoButton:NO];
        [self resetSendBtnEnabledState];
        return;
    }
    
    if (isDisplay) {
        // 他人发的评测，同时弹起键盘且有文本输入时
        NSString *titleStr = @"发送";
        if (_visitorReply) {
            // 回复他人
            titleStr = @"回复";
        }
        [self setSendBtnState:titleStr withImage:NO];
        [self showAddPhotoButton:NO];
    } else {
        if ([[_textView text] isEqualToString:@""]) {
            // 他人发的评测，收起键盘后且无文本输入时
            [self setSendBtnState:@"" withImage:YES];
            [self showAddPhotoButton:NO];
        }
    }
}

- (void)openPhotoLibrary:(UIButton *)sender {
    NSLog(@"openPhotoLibrary");
    // 创建控制器
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.selectPickers = self.assets;
    // 最多能选3张图片
    pickerVc.maxCount = 1;
    pickerVc.delegate = self;
    UIViewController *vc = (UIViewController *)self.myDelegate;
    [pickerVc showPickerVc:vc];
    pickerVc.topShowPhotoPicker = YES;
}

- (void)editButtonClick:(UIButton *)sender {
    NSInteger index = ([sender tag])/110 - 1;
    UIImageView *imageView = (UIImageView *)[sender superview];
    if (imageView) {
        [sender removeFromSuperview];
        [imageView removeFromSuperview];
        [self.imagePickedArr removeObjectAtIndex:index];
        [self.assets removeObjectAtIndex:index];
    }
    [self resetPAddImageButtonPosition:[self.assets count]];
}

#pragma -mark 键盘事件
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;  // 得到键盘弹出后的键盘视图所在y坐标
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        CGRect currentFrame = [self frame];
        CGFloat chaZhi = currentFrame.size.height - _newFrame.size.height;
        currentFrame.origin.y = keyBoardEndY - currentFrame.size.height + chaZhi;
        [self setFrame:currentFrame];
    } completion:^(BOOL finished){
        if (_isAddImage) {
//            [self resetTextViewSize];
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    //    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    //    CGFloat keyBoardEndY = value.CGRectValue.origin.y;  // 得到键盘弹出后的键盘视图所在y坐标
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        // keyBoardEndY的坐标包括了状态栏的高度，要减去
        CGRect currentFrame = [self frame];
        CGFloat chaZhi = currentFrame.size.height - _newFrame.size.height;
        if (_isAddImage) {
            chaZhi = 0;
        }
        currentFrame.origin.y = kFrameHeight - currentFrame.size.height + chaZhi;
        [self setFrame:currentFrame];
    } completion:^(BOOL finished){
        if (!_isAddImage) {
            [self resetTextViewSize];
        }
    }];
    
}


#pragma -mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    _isAddImage = NO;
    [self resetViewWithTheKeyboardState:YES];
    [self resetSendBtnEnabledState];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([[textView text] isEqualToString:@""]) {
        if (!_isAddImage) {
            [self setFrame:_originalFrame];
        }
        
        if (self.isSelfEvalu) {
            [_sendBtn setEnabled:NO];
        } else {
            [_sendBtn setEnabled:YES];
        }
    }
    [self resetViewWithTheKeyboardState:NO];
}

- (void)resetTextViewSize {
    CGSize size = [_textView sizeThatFits:CGSizeMake(CGRectGetWidth(_textView.frame), MAXFLOAT)];
//    CGFloat newHeight = size.height + 15.5;
    CGFloat newHeight = 0.0f;
    CGRect editBarFrame = [_editBarView frame];
    CGRect selfFrame = self.frame;
    newHeight = size.height < 35.0f ? 49.0 : size.height + 9;
    NSLog(@"%f", newHeight);
    newHeight = newHeight < 116.0f ? newHeight:134.0f;
    selfFrame.size.height = newHeight;
    selfFrame.origin.y = selfFrame.origin.y - (newHeight - editBarFrame.size.height);
    self.frame = selfFrame;
    
    editBarFrame.size.height = newHeight;
    [_editBarView setFrame:editBarFrame];
    _newFrame = [self frame];
    for (int i = 0; i < _imageTotalNum; i++) {
        UIImageView *tmpImageView = [self viewWithTag:(i+1)*100];
        if (tmpImageView) {
            CGRect frame = [tmpImageView frame];
            frame.origin.y = _editBarView.frame.size.height + 10;
            [tmpImageView setFrame:frame];
        }
    }

}

- (void)textViewDidChange:(UITextView *)textView {
    _isAddImage = NO;
    [self resetTextViewSize];
    [_pAddImage setHidden:YES];
    [self resetSendBtnEnabledState];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        if ([textView.text isEqualToString:@""]) {
            self.isReply = NO;
            _textView.placeholder = _initPlaceHolderStr;
        }
        
        return NO;
    }
    return YES;
}

#pragma -mark 输入panel上button的一些响应事件
- (void)addImageButtonClick:(UIButton *)sender {
    _isAddImage = !_isAddImage;
    if (_isAddImage) {
        CGRect orignFrame = _newFrame;
        orignFrame.size.height = ImageViewHeight + 30 + orignFrame.size.height;
        orignFrame.origin.y = kFrameHeight - orignFrame.size.height;
        [self setFrame:orignFrame];
        [self hideKeyBoard];
        
        [_pAddImage setFrame:CGRectMake(kFrameWidth/2-25, orignFrame.size.height-59-ImageViewHeight/2, 50, 50)];
        
    } else {
        [self displayKeyBoard];
    }
    [_pAddImage setHidden:NO];
    [self showAddPhotoButton:YES];
}

- (void)sendButtonClick:(UIButton *)sender {
    if (_responseToLike) {
        [sender setSelected:![sender isSelected]];
        [self.myDelegate sendUserZanRequest];
    } else {
        NSString *commentStr = [self getTextStr];
        [self setTextViewText:@""];
        [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification object:nil];
        NSArray *imageUploadArr = [NSArray arrayWithArray:self.imagePickedArr];
        [self.imagePickedArr removeAllObjects];
        [self.assets removeAllObjects];
        [self reloadImageData:@[]];
        if (_isReply && ![_textView.placeholder isEqualToString:_initPlaceHolderStr]) {
            if (![_textView.placeholder isEqualToString:@"评论一下吧"]) {
                commentStr = [NSString stringWithFormat:@"%@ %@", _textView.placeholder, commentStr];
            }
        }
        [self.myDelegate sendMessageRequest:commentStr imageArr:imageUploadArr isReply:_isReply];
        
        _textView.placeholder = _initPlaceHolderStr;
        _isReply = !_isSelfEvalu;
        _visitorReply = NO;
        [self resetViewWithTheKeyboardState:NO];
    }
}

#pragma -mark 内部封装的一些方法，以供外部访问
- (NSString *)getTextStr {
    return [_textView text];
}

- (void)displayKeyBoard {
    [_textView becomeFirstResponder];
}

- (void)hideKeyBoard {
    [_textView resignFirstResponder];
    self.isReply = NO;
}

- (void)setTextViewText:(NSString *)str {
    [_textView setText:str];
    if (str == nil || [str isEqualToString:@""]) {
        _newFrame = _originalFrame;
        [self setFrame:_originalFrame];
        [_editBarView setFrame:CGRectMake(0, 0, _originalFrame.size.width, _originalFrame.size.height)];
        
        [_textView resignFirstResponder];
        [self resetViewWithTheKeyboardState:NO];
        
    } else {
        CGSize size = [_textView sizeThatFits:CGSizeMake(CGRectGetWidth(_textView.frame), MAXFLOAT)];
        CGRect selfFrame = self.frame;
        CGFloat newHeight = size.height + 10;
        selfFrame.origin.y = selfFrame.origin.y - (newHeight - selfFrame.size.height);
        selfFrame.size.height = newHeight;
        self.frame = selfFrame;
    }
}

/*
 基于UIView点击编辑框以外的虚拟键盘收起
 **/
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

}

#pragma -mark views constraint

- (void)initButtonsConstraint {
    NSLayoutConstraint * sendBtn_right_c = [NSLayoutConstraint constraintWithItem:_sendBtn
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_editBarView
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0
                                                                         constant:-8];
    
    NSLayoutConstraint * sendBtn_left_c = [NSLayoutConstraint constraintWithItem:_sendBtn
                                                                       attribute:NSLayoutAttributeLeft
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_editBarView
                                                                       attribute:NSLayoutAttributeLeft
                                                                      multiplier:1.0
                                                                        constant:kFrameWidth - 49];
    
    NSLayoutConstraint * sendBtn_top_c = [NSLayoutConstraint constraintWithItem:_sendBtn
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_editBarView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0
                                                                       constant:-10];
    
    NSLayoutConstraint * sendBtn_bottom_c = [NSLayoutConstraint constraintWithItem:_sendBtn
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_editBarView
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0
                                                                       constant:10];

    _sendBtnConstraintsArr = @[sendBtn_left_c, sendBtn_right_c, sendBtn_top_c, sendBtn_bottom_c];
    
    
    NSLayoutConstraint * likeBtn_left_c = [NSLayoutConstraint constraintWithItem:_sendBtn
                                                                       attribute:NSLayoutAttributeLeft
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_editBarView
                                                                       attribute:NSLayoutAttributeLeft
                                                                      multiplier:1.0
                                                                        constant:kFrameWidth-14-29];
    
    NSLayoutConstraint * likeBtn_right_c = [NSLayoutConstraint constraintWithItem:_sendBtn
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_editBarView
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0
                                                                         constant:-14];
    
    NSLayoutConstraint * likeBtn_top_c = [NSLayoutConstraint constraintWithItem:_sendBtn
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_editBarView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0
                                                                       constant:10];
    
    NSLayoutConstraint * likeBtn_bottom_c = [NSLayoutConstraint constraintWithItem:_sendBtn
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_editBarView
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0
                                                                          constant:-10];
    _likeBtnConstraintsArr = @[likeBtn_left_c, likeBtn_right_c, likeBtn_top_c, likeBtn_bottom_c];
}

- (void)showAddPhotoButton:(BOOL)isShow {
    if (!_addImageBtn) {
        _addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addImageBtn setFrame:CGRectMake(5, 5, 30, 20)];
        [_editBarView addSubview:_addImageBtn];
        [_addImageBtn addTarget:self action:@selector(addImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _addImageBtn.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint * addImagBtn_left_c = [NSLayoutConstraint constraintWithItem:_addImageBtn
                                                                              attribute:NSLayoutAttributeLeft
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:_editBarView
                                                                              attribute:NSLayoutAttributeLeft
                                                                             multiplier:1.0
                                                                               constant:8];
        
        NSLayoutConstraint * addImagBtn_top_c = [NSLayoutConstraint constraintWithItem:_addImageBtn
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:_editBarView
                                                                             attribute:NSLayoutAttributeTop
                                                                            multiplier:1.0
                                                                              constant:12];
        
        NSLayoutConstraint * addImagBtn_bottom_c = [NSLayoutConstraint constraintWithItem:_addImageBtn
                                                                                attribute:NSLayoutAttributeBottom
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:_editBarView
                                                                                attribute:NSLayoutAttributeBottom
                                                                               multiplier:1.0
                                                                                 constant:-12];
        
        [self addConstraints:@[addImagBtn_left_c, addImagBtn_top_c, addImagBtn_bottom_c]];
        
        [_addImageBtn setImage:[UIImage imageNamed:@"evaluation_add_image_btn"] forState:UIControlStateNormal];
        [_addImageBtn setImage:[UIImage imageNamed:@"evaluation_add_image_btn"] forState:UIControlStateSelected];
    }
    
    [_addImageBtn setHidden:!isShow];
    
    [self removeConstraint:_textViewLeftC];
    if (isShow) {
        _textViewLeftC = [NSLayoutConstraint constraintWithItem:_textView
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_editBarView
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1.0
                                                       constant:41];
    } else {
        _textViewLeftC = [NSLayoutConstraint constraintWithItem:_textView
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_editBarView
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1.0
                                                       constant:12];
    }
    [self addConstraint:_textViewLeftC];
}

#pragma mark - ZLPhotoPickerViewControllerDelegate

- (void)pickerViewControllerDoneAsstes:(NSArray *)assets {
    self.assets = [NSMutableArray arrayWithArray:assets];
    [self.imagePickedArr removeAllObjects];
    NSMutableArray *tmpThumbImageArr = [[NSMutableArray alloc] init];
    
    for (ZLPhotoAssets *asset in self.assets) {
        if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
            [self.imagePickedArr addObject:asset.originImage];
            [tmpThumbImageArr addObject:asset.thumbImage];
        } else if ([asset isKindOfClass:[UIImage class]]) {
            UIImage *tmpImage = (UIImage *)asset;
            [_imagePickedArr addObject:[UIImage fixOrientation:tmpImage]];
//            [self.imagePickedArr addObject:asset];
            [tmpThumbImageArr addObject:asset];
        }
    }
    
    [self reloadImageData:tmpThumbImageArr];
}

- (void)reloadImageData:(NSArray *)imageArr {
    NSInteger imageCount = [imageArr count];
    for (int i = 0; i < _imageTotalNum; i++) {
        UIImageView *tmpImageView = [self viewWithTag:(i+1)*100];
        if (i >= imageCount) {
            if (tmpImageView) {
                [tmpImageView removeFromSuperview];
            }
        } else {
            UIImage *image = [imageArr objectAtIndex:i];
            if (!tmpImageView) {
                tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kFrameWidth/2 - ImageViewHeight/2, _editBarView.frame.size.height + 10, (image.size.width/image.size.height)*ImageViewHeight, ImageViewHeight)];
                UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [tmpImageView addSubview:editBtn];
                [editBtn setFrame:CGRectMake(tmpImageView.frame.size.width - 20, 0, 20, 20)];
                [editBtn setBackgroundColor:mUIColorWithRGBA(0, 0, 0, 0.2)];
                [editBtn setTitle:@"X" forState:UIControlStateNormal];
                [editBtn setTitle:@"X" forState:UIControlStateSelected];
                [editBtn setTitle:@"X" forState:UIControlStateHighlighted];
                [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                editBtn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
                [editBtn addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [editBtn setTag:(i+1)*110];
            }
            
            [tmpImageView setImage:image];
            [tmpImageView setTag:(i+1)*100];
            tmpImageView.userInteractionEnabled = YES;
            [self addSubview:tmpImageView];
        }
    }
    [self resetPAddImageButtonPosition:[imageArr count]];
}

- (void)resetPAddImageButtonPosition:(NSInteger)imageCount {
    BOOL isHidden = imageCount > 0 ? YES:NO;
    [_pAddImage setHidden:isHidden];
//    [_pAddImage setFrame:CGRectMake(kFrameWidth/2 - 25, 49 + (ImageViewHeight + 30)/2-25, 50, 50)];
}


@end
