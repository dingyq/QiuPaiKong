//
//  CircleEditView.m
//  QiuPai
//
//  Created by bigqiang on 15/11/20.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "CircleEditView.h"

#define ImageViewWidth 50.0f

@interface CircleEditView() {
    UIView *_photoDisplayView;
    UIButton *_addPhotoBtn;
    NSInteger _imageNum;
    NSInteger _imageTotalNum;
}

@end

@implementation CircleEditView

@synthesize textView = _textView;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageNum = 0;
        _imageTotalNum = 3;
        
        _textView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(15, 0, frame.size.width-30, frame.size.height - 77)];
        [_textView setBackgroundColor:[UIColor whiteColor]];
        [_textView setFont:[UIFont systemFontOfSize:15.0f]];
        [_textView setTextColor:[UIColor blackColor]];
//        _textView.layer.borderWidth = 1;
//        _textView.layer.borderColor = [UIColor blueColor].CGColor;
        _textView.layer.masksToBounds = YES;
        _textView.placeholderColor = Gray153Color;
        [self addSubview:_textView];
        [_textView.placeHolderLabel setFrame:CGRectMake(5, 6, _textView.frame.size.width-10, 20)];
        
        
        _photoDisplayView =[[UIView alloc] initWithFrame:CGRectMake(16, frame.size.height - ImageViewWidth - 14, ImageViewWidth * 4 + 30, ImageViewWidth)];
        [_photoDisplayView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_photoDisplayView];
       
        _addPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addPhotoBtn setFrame:CGRectMake(0, 0, _photoDisplayView.frame.size.height, _photoDisplayView.frame.size.height)];
        [_addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"add_image_btn.png"] forState:UIControlStateNormal];
        [_addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"add_image_btn.png"] forState:UIControlStateSelected];
        [_addPhotoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_addPhotoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        _addPhotoBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_addPhotoBtn setTag:101];
        [_addPhotoBtn addTarget:self.delegate action:@selector(openPhotoPickerView:) forControlEvents:UIControlEventTouchUpInside];
        [_photoDisplayView addSubview:_addPhotoBtn];
        
//        [_addPhotoBtn setTitle:[NSString stringWithFormat:@"最多%lu张", _imageTotalNum] forState:UIControlStateNormal];
//        [_addPhotoBtn setTitle:[NSString stringWithFormat:@"最多%lu张", _imageTotalNum] forState:UIControlStateSelected];
    }
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text {
    if ([text isEqualToString:@"\n"]) {
        [_textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)reloadImageData:(NSArray *)imageArr {
    NSInteger imageCount = [imageArr count];
    for (int i = 0; i < _imageTotalNum; i++) {
        UIImageView *tmpImageView = [_photoDisplayView viewWithTag:(i+1)*100];
        if (i >= imageCount) {
            if (tmpImageView) {
                [tmpImageView removeFromSuperview];
            }
        } else {
            if (!tmpImageView) {
                tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ImageViewWidth*i + 10 * i, 0, ImageViewWidth, ImageViewWidth)];
            }
            UIImage *image = [imageArr objectAtIndex:i];
            [tmpImageView setImage:image];
            [tmpImageView setTag:(i+1)*100];
            [_photoDisplayView addSubview:tmpImageView];
//            tmpImageView.userInteractionEnabled = YES;
//            UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(photoTapAction:)];
//            [tmpImageView addGestureRecognizer:singleTap1];
            
        }
    }
    CGRect photoBtnFrame = [_addPhotoBtn frame];
    photoBtnFrame.origin.x = (ImageViewWidth + 10)*(imageCount < _imageTotalNum ?imageCount:_imageTotalNum);
    [_addPhotoBtn setFrame:photoBtnFrame];
}

- (void)hideKeyBoard {
    [_textView resignFirstResponder];
}

@end
