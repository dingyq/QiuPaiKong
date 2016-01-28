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
static CGFloat InputFontSize = 15.0f;

@interface DDTextBoxView() <ZLPhotoPickerViewControllerDelegate>{
    UIButton *_sendBtn;
    UIButton *_addImageBtn;
    UIButton *_pAddImage;
    UIView *_editBarView;
    
    CGRect _originalFrame;
    CGRect _newFrame;
    
    BOOL _isAddImage;
    NSInteger _imageTotalNum;
    NSString *_initPlaceHolderStr;
}
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSMutableArray *imagePickedArr; // 临时存储相册选取的照片

@end

@implementation DDTextBoxView

@synthesize textView = _textView;
@synthesize myDelegate = _myDelegate;
@synthesize isReply = _isReply;
@synthesize isSelfEvalu = _isSelfEvalu;

- (void)setIsSelfEvalu:(BOOL)isSelfEvalu {
    _isSelfEvalu = isSelfEvalu;
    _isReply = !isSelfEvalu;
    [self updateTextViewPlaceHolder];
}

- (void)updateTextViewPlaceHolder {
    if (_isSelfEvalu) {
        _initPlaceHolderStr = @"继续补充评测内容";
    }
    _textView.placeholder = _initPlaceHolderStr;
}

- (void)setIsReply:(BOOL)isReply {
    _isReply = isReply;
    if (isReply) {
        // 当重新回复其他人时，清空之前的输入
        [_textView setText:@""];
    }
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

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"ddd layoutSubviews");
}

- (void)updateConstraints {
    NSLog(@"ddd updateConstraints");
    CGFloat height = _newFrame.size.height;
    height = _isAddImage ? height + ImageViewHeight : height;
    [self mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(@(0));
        make.bottom.equalTo(@(0));
        make.width.equalTo(@(_newFrame.size.width));
        make.height.equalTo(@(height));
    }];
    [super updateConstraints];
}

- (void)updateSelfConstraints:(CGFloat)bottom height:(CGFloat)height {
    [self mas_updateConstraints:^(MASConstraintMaker *make){
        if (bottom <= 0) {
            make.bottom.equalTo(@(bottom));
        }
        make.height.equalTo(@(height));
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _isSelfEvalu = NO;
        _isAddImage = NO;
        _isReply = YES;
        
        _originalFrame = frame;
        _newFrame = frame;
        _imageTotalNum = 1;
        _initPlaceHolderStr = @"评论一下吧";
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [self initUI];
        
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

- (void)initUI {
    _editBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 49)];
    [_editBarView setBackgroundColor:Gray233Color];
    [self addSubview:_editBarView];
    [_editBarView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(@0);
        make.width.equalTo(@(kFrameWidth));
        make.top.equalTo(@0);
        make.height.equalTo(@(_originalFrame.size.height));
    }];
    
    _pAddImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pAddImage setImage:[UIImage imageNamed:@"publish_add_image_btn"] forState:UIControlStateNormal];
    [_pAddImage setImage:[UIImage imageNamed:@"publish_add_image_btn"] forState:UIControlStateHighlighted];
    [_pAddImage setImage:[UIImage imageNamed:@"publish_add_image_btn"] forState:UIControlStateSelected];
    [_pAddImage setHidden:YES];
    [_pAddImage addTarget:self action:@selector(openPhotoLibrary:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_pAddImage];
    [_pAddImage mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(@(kFrameWidth/2-25));
        make.top.equalTo(_editBarView.mas_bottom).with.offset(ImageViewHeight/2-50);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];

    CGFloat btnLeft = 12.0;
    _textView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(btnLeft, 5, kFrameWidth - 100, 39)];
    [_textView setBackgroundColor:[UIColor whiteColor]];
    [_textView setFont:[UIFont systemFontOfSize:InputFontSize]];
    [_textView setTextColor:Gray51Color];
    _textView.contentInset = UIEdgeInsetsMake(3, 0, 0, 0);
    _textView.layer.borderWidth = 1;
    _textView.layer.cornerRadius = 4.0f;
    _textView.layer.borderColor = Gray233Color.CGColor;
    _textView.layer.masksToBounds = YES;
    _textView.delegate = self;
    [_editBarView addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(@5);
        make.bottom.equalTo(@(-5));
        make.right.equalTo(@(-57));
        make.left.equalTo(@(btnLeft));
    }];

    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendBtn setTitleColor:CustomGreenColor forState:UIControlStateNormal];
    [_sendBtn setTitleColor:CustomGreenColor forState:UIControlStateSelected];
    [_sendBtn setTitleColor:Gray153Color forState:UIControlStateDisabled];
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_sendBtn setTitle:@"发送" forState:UIControlStateDisabled];
    _sendBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [_editBarView addSubview:_sendBtn];
    [_sendBtn addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *superView = _editBarView;
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(superView.mas_right).with.offset(-49);
        make.top.equalTo(@10);
        make.width.equalTo(@40);
        make.height.equalTo(@(29));
    }];
    
    [self resetSendBtnEnabledState];
}

- (void)resetSendBtnEnabledState {
    if ([[_textView text] isEqualToString:@""]) {
        [_sendBtn setEnabled:NO];
    } else {
        [_sendBtn setEnabled:YES];
    }
}

// 根据键盘弹出或收起的情况重新排版界面
- (void)resetViewWithTheKeyboardState:(BOOL)isDisplay {
    [self resetSendBtnEnabledState];
    BOOL isShowAddImage = YES;
    if (self.isSelfEvalu) {
        isShowAddImage = self.isReply ? NO : (isDisplay || _isAddImage);
    } else {
        isShowAddImage = NO;
    }
    [self showAddPhotoButton:isShowAddImage];
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
    [_pAddImage setHidden:YES];
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardH = value.CGRectValue.size.height;
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    [self updateSelfConstraints:-keyBoardH height:_newFrame.size.height];
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished){
 
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    //    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    //    CGFloat keyBoardEndY = value.CGRectValue.origin.y;  // 得到键盘弹出后的键盘视图所在y坐标
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    // 添加移动动画，使视图跟随键盘移动
    CGFloat height = _newFrame.size.height;
    height = _isAddImage ? height + ImageViewHeight : height;
    [self updateSelfConstraints:0 height:height];
    
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished){
        if (!_isAddImage) {
            [self updateEditBarViewSize];
        }
    }];
}


#pragma -mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    _isAddImage = NO;
    [self resetViewWithTheKeyboardState:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([[textView text] isEqualToString:@""]) {
        if (!_isAddImage) {
            [self updateSelfConstraints:0 height:_originalFrame.size.height];
        }
    }
    [self resetViewWithTheKeyboardState:NO];
}

- (void)updateEditBarViewSize {
    CGFloat textW  = CGRectGetWidth(_textView.frame);
    CGSize size = [_textView sizeThatFits:CGSizeMake(textW, MAXFLOAT)];
    CGFloat newHeight = 0.0f;
    newHeight = size.height < 35.0f ? 49.0 : size.height + 9;
    newHeight = newHeight < 116.0f ? newHeight:134.0f;
    _newFrame.size.height = newHeight;
    [self updateSelfConstraints:1 height:newHeight];
    
    [_editBarView mas_updateConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(@(newHeight));
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    _isAddImage = NO;
    [self updateEditBarViewSize];
    [self resetSendBtnEnabledState];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if ([textView.text isEqualToString:@""]) {
            _isReply = !_isSelfEvalu;
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
        CGFloat height = ImageViewHeight + _newFrame.size.height;
        [self updateSelfConstraints:-height height:height];
        [self hideKeyBoard];
    } else {
        [self displayKeyBoard];
    }
    [_pAddImage setHidden:!_isAddImage];
    [self showAddPhotoButton:YES];
}

- (void)sendButtonClick:(UIButton *)sender {
    NSString *commentStr = [self getTextStr];
    [self setTextViewText:@""];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification object:nil];
    NSArray *imageUploadArr = [NSArray arrayWithArray:self.imagePickedArr];
    [self.imagePickedArr removeAllObjects];
    [self.assets removeAllObjects];
    [self reloadImageData:@[]];
    if (self.isReply && ![_textView.placeholder isEqualToString:_initPlaceHolderStr]) {
        if (![_textView.placeholder isEqualToString:@"评论一下吧"]) {
            commentStr = [NSString stringWithFormat:@"%@ %@", _textView.placeholder, commentStr];
        }
    }
    [self.myDelegate sendMessageRequest:commentStr imageArr:imageUploadArr isReply:self.isReply];
    
    _textView.placeholder = _initPlaceHolderStr;
    _isReply = !_isSelfEvalu;
    [self resetViewWithTheKeyboardState:NO];
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
    _isReply = !_isSelfEvalu;
}

- (void)setTextViewText:(NSString *)str {
    [_textView setText:str];
    if (str == nil || [str isEqualToString:@""]) {
        _newFrame = _originalFrame;
        [self updateSelfConstraints:0 height:_newFrame.size.height];
        
        [_editBarView mas_updateConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(@(_originalFrame.size.height));
        }];
        
        [_textView resignFirstResponder];
        [self resetViewWithTheKeyboardState:NO];
    } else {
        CGSize size = [_textView sizeThatFits:CGSizeMake(CGRectGetWidth(_textView.frame), MAXFLOAT)];
        CGFloat newHeight = size.height + 10;
        _newFrame.size.height = newHeight;
        
        [self updateSelfConstraints:0 height:_newFrame.size.height];
        
        [_editBarView mas_updateConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(@(newHeight));
        }];
    }
}

- (void)showAddPhotoButton:(BOOL)isShow {
    if (!_addImageBtn) {
        _addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addImageBtn setImage:[UIImage imageNamed:@"evaluation_add_image_btn"] forState:UIControlStateNormal];
        [_addImageBtn setImage:[UIImage imageNamed:@"evaluation_add_image_btn"] forState:UIControlStateSelected];
        [_addImageBtn addTarget:self action:@selector(addImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_editBarView addSubview:_addImageBtn];
        [_addImageBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(@8);
            make.top.equalTo(@(12.0));
            make.width.equalTo(@25);
            make.height.equalTo(@25);
        }];
    }
    [_addImageBtn setHidden:!isShow];
    CGFloat btnLeft = isShow ? 41.0 : 12.0f;
    [_textView mas_updateConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(@(btnLeft));
    }];
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
                CGFloat imageH = ImageViewHeight - 20;
                CGFloat imageW = (image.size.width/image.size.height)*imageH;
                tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 60, imageW, imageH)];
                UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [tmpImageView addSubview:editBtn];
                [editBtn mas_makeConstraints:^(MASConstraintMaker *make){
                    make.top.equalTo(@0);
                    make.right.equalTo(@(0));
                    make.width.equalTo(@20);
                    make.height.equalTo(@20);
                }];
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
                tmpImageView.userInteractionEnabled = YES;
                [self addSubview:tmpImageView];
                [tmpImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(@0);
                    make.top.equalTo(_editBarView.mas_bottom).with.offset(10);
                    make.width.equalTo(@(imageW));
                    make.height.equalTo(@(imageH));
                }];
            }
            [tmpImageView setImage:image];
        }
    }
    [self resetPAddImageButtonPosition:[imageArr count]];
}

- (void)resetPAddImageButtonPosition:(NSInteger)imageCount {
    BOOL isHidden = imageCount > 0 ? YES:NO;
    [_pAddImage setHidden:isHidden];
}


@end
