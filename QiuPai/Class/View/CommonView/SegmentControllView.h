//
//  SegmentControllView.h
//  QiuPai
//
//  Created by bigqiang on 15/11/21.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - SegmentItem Class

@protocol SegmentItemDelegate <NSObject>

- (void)selectedItemWithIndex:(NSInteger)itemIndex;

@end

@interface SegmentItem : UIView {
    
}

@property (nonatomic, copy) NSString *itemTitle;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImage *itemAttachImage;
@property (nonatomic, strong) UILabel *itemAttachView;
@property (nonatomic, assign) NSUInteger itemIndex;
@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic,assign) id<SegmentItemDelegate>delegate;

- (id)initWithFrame:(CGRect)frame NormalColor:(UIColor *)nColor SelectedColor:(UIColor *)sColor;

@end


#pragma mark - SegmentControllView Class

@interface SegmentControllView : UIView<SegmentItemDelegate> {
    id _delegate;
    SEL _segmentAction;
    UIControlEvents _controlEvents;
}

@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, strong) SegmentItem *selectedItem;

- (id)initWithFrame:(CGRect)frame items:(NSArray *)itemArray;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)setSegmentBg:(UIImage *)bgImage DevisionLine:(UIImage *)lineImage;

- (void)setSelectedIndex:(NSUInteger)selectedIndex;

@end
