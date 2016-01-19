//
//  PhotoBrowseView.m
//  QiuPai
//
//  Created by bigqiang on 15/11/16.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "PhotoBrowseView.h"
#import "UIImageView+WebCache.h"

@interface PhotoBrowseView() {
    UIPageControl *_pageControl;
    UIScrollView  *_contentPageView;
    CGRect _originalRect;
    long _originalIndex;
    
    CGFloat _photoViewW;
    CGFloat _photoViewH;
}
@end

@implementation PhotoBrowseView



- (instancetype)initWithUrlPathArr:(NSArray *)pathArr thumbImageArr:(NSArray *)thumbPathArr thumbImages:(NSArray *)thumbImages index:(long)index fromRect:(CGRect)rect {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        _originalRect = rect;
        _originalIndex = index;
        self.frame = [[[UIApplication sharedApplication] keyWindow] frame];
        _photoViewW = self.frame.size.width;
        _photoViewH = self.frame.size.height;
        
        _contentPageView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _photoViewW, _photoViewH)];
        _contentPageView.pagingEnabled = YES;
        _contentPageView.contentSize = CGSizeMake(_photoViewW*[pathArr count], _photoViewH);
        _contentPageView.showsHorizontalScrollIndicator = NO;
        _contentPageView.showsVerticalScrollIndicator = NO;
        _contentPageView.scrollsToTop = NO;
        _contentPageView.bounces = NO;
        _contentPageView.delegate = self;
        _contentPageView.maximumZoomScale = 4.0;
        _contentPageView.minimumZoomScale = 0.5;
        [self addSubview:_contentPageView];
        
        for (int i = 0; i < [pathArr count]; i++) {
            CGRect frameRect = CGRectMake(_photoViewW * i + rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
//            CGRect frameRect = CGRectMake(_photoViewW * i + _photoViewW/2-rect.size.width/2, _photoViewH/2-rect.size.height/2, rect.size.width, rect.size.height);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:frameRect];
            [imageView setTag:(100*i + 1)];
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFit;

            UIImage *thumbImage = [thumbImages objectAtIndex:i];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageAction:)];
            tapGesture.numberOfTapsRequired = 1;
            tapGesture.numberOfTouchesRequired = 1;
            [imageView addGestureRecognizer:tapGesture];
            [_contentPageView addSubview:imageView];
            
            UIActivityIndicatorView *actiIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 54, 54)];
            [actiIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];//设置进度轮显示类型
            [actiIndicator stopAnimating];
            [actiIndicator setTag:100];
            [imageView addSubview:actiIndicator];
   
            CGFloat duration = (i == index)?0.5f:0.0f;
            CGFloat newW = _photoViewW;
            CGFloat newH = _photoViewH;
            __block BOOL imageLoaded = NO;
            [UIView animateWithDuration:duration animations:^{
                [imageView setFrame:CGRectMake(_photoViewW * i,_photoViewH/2-newH/2, newW, newH)];
            }completion:^(BOOL finished){
                [actiIndicator setCenter:CGPointMake(imageView.frame.size.width/2, imageView.frame.size.height/2)];
                if (imageLoaded) {
                    [actiIndicator stopAnimating];
                } else {
                    [actiIndicator startAnimating];
                }
            }];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:[pathArr objectAtIndex:i]] placeholderImage:thumbImage   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                [actiIndicator stopAnimating];
                imageLoaded = YES;
            }];
        }
        
        [_contentPageView setContentOffset:CGPointMake(index*_contentPageView.frame.size.width, 0)];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((_photoViewW-100)/2, _photoViewH-35, 100, 30)];
        _pageControl.numberOfPages = [pathArr count];
        _pageControl.currentPage = index;
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = Gray153Color;
        [self addSubview:_pageControl];
    }
    
    return self;
}

- (void)tapImageAction:(UITapGestureRecognizer *)tapGesture {
    UIImageView *imageView = (UIImageView *)tapGesture.view;
    long index = ([imageView tag]-1)/100;
//    if (imageView.frame.size.width == _photoViewW) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImage *image = imageView.image;
        CGFloat newW = _photoViewW;
        CGFloat newH = newW * (image.size.height/image.size.width);
        CGRect rect = imageView.frame;
        [imageView setFrame:CGRectMake(rect.origin.x, _photoViewH/2-newH/2, newW, newH)];
        
        [imageView setClipsToBounds:YES];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UIActivityIndicatorView *indicator = [imageView viewWithTag:100];
    if (indicator) {
        [indicator stopAnimating];
    }

        [UIView animateWithDuration:0.5 animations:^{
            [_pageControl removeFromSuperview];
            CGRect frame = imageView.frame;
            float gap = (_photoViewW - 20 - 10)/3;
            imageView.frame = CGRectMake(_originalRect.origin.x + frame.origin.x + (index - _originalIndex)*(gap+5), _originalRect.origin.y, _originalRect.size.width, _originalRect.size.height);
        } completion:^(BOOL finished){
            [self removeFromSuperview];
        }];
//    }
}

#pragma mark
#pragma mark - UIScrollViewDelegate
#pragma mark

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//    return self.bigImageView;
//}
//
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
//    if (scale <= 1) {
//        [UIView animateWithDuration:0.3 animations:^{
//            view.center = scrollView.center;
//        }];
//    }
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControl.currentPage = scrollView.contentOffset.x/scrollView.frame.size.width;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}


@end
