//
//  SegmentControllView.m
//  QiuPai
//
//  Created by bigqiang on 15/11/21.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "SegmentControllView.h"

#pragma mark - SegmentItem Class

#define kItemTitleTag 1001
#define kSeletedImageTag 1002
#define kItemAttachImageTag 1003

#define TitleFont [UIFont systemFontOfSize:15]
#define TitleSelectedColor [UIColor grayColor]
#define TitleNormalColor [UIColor whiteColor]

#define TitleLabelFrame CGRectMake(0,0,1,30)
#define AttachImageFrame CGRectMake(0,(self.bounds.size.height - 13.5)/2,13.5,8)


@interface SegmentItem(){
    UIColor *_nColor;
    UIColor *_sColor;
}

@end

@implementation SegmentItem

@synthesize itemTitle = _itemTitle;
@synthesize selectedImage = _selectedImage;
@synthesize itemAttachImage = _itemAttachImage;
@synthesize itemAttachView = _itemAttachView;
@synthesize itemIndex = _itemIndex;
@synthesize isSelected = _isSelected;
@synthesize delegate = _delegate;

- (void)dealloc {
    if (_itemTitle){
        _itemTitle = nil;
    }
    if (_selectedImage){
        _selectedImage = nil;
    }
    if (_itemAttachImage){
        _itemAttachImage = nil;
    }
    if (_itemAttachView){
        _itemAttachView = nil;
    }
    if (_nColor) {
        _nColor = nil;
    }
    if (_sColor){
        _sColor = nil;
    }
}

- (void)initProperty {
    _itemTitle = nil;
    _selectedImage = nil;
    _itemAttachImage = nil;
    _itemAttachView = nil;
    _itemIndex = 0;
    _isSelected = YES;
}

- (void)initSubViews {
    UIImageView *selectedImage = [[UIImageView alloc] initWithFrame:self.bounds];
    [selectedImage setTag:kSeletedImageTag];
    [selectedImage setUserInteractionEnabled:YES];
    [self addSubview:selectedImage];
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:TitleLabelFrame];
    [titleLable setTag:kItemTitleTag];
    [titleLable setBackgroundColor:[UIColor clearColor]];
    [titleLable setFont:TitleFont];
    [titleLable setTextColor:_nColor];
    [titleLable setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:titleLable];
    
    UIImageView *attachImage = [[UIImageView alloc] initWithFrame:AttachImageFrame];
    [attachImage setTag:kItemAttachImageTag];
    [attachImage setUserInteractionEnabled:YES];
    [self addSubview:attachImage];
    
//    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 1)];
//    lineView.backgroundColor = LineViewColor;
//    [self addSubview:lineView];
}

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        _nColor = TitleNormalColor;
        _sColor = TitleSelectedColor;
        [self initProperty];
        [self initSubViews];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame NormalColor:(UIColor *)nColor SelectedColor:(UIColor *)sColor {
    if (self = [self initWithFrame:frame]) {
        if (nColor) {
            _nColor = nColor;
        }else {
            _nColor = TitleNormalColor;
        }
        
        if (sColor) {
            _sColor = sColor;
        }else {
            _sColor = TitleSelectedColor;
        }
    }
    
    return self;
}

- (void)setSelectedImage:(UIImage *)selectedImage {
    if (_selectedImage){
        _selectedImage = nil;
    }
    
    _selectedImage = selectedImage;
    [(UIImageView *)[self viewWithTag:kSeletedImageTag] setImage:_selectedImage];
}

- (void)setItemAttachImage:(UIImage *)itemAttachImage {
    if (_itemAttachImage){
        _itemAttachImage = nil;
    }
    
    _itemAttachImage = itemAttachImage;
    [(UIImageView *)[self viewWithTag:kItemAttachImageTag] setImage:_itemAttachImage];
}

- (void)setItemTitle:(NSString *)itemTitle {
    if (_itemTitle){
        _itemTitle = nil;
    }
    _itemTitle = itemTitle;
    
    UILabel *titleLabel = (UILabel *)[self viewWithTag:kItemTitleTag];
    UIImageView *attachImage = (UIImageView *)[self viewWithTag:kItemAttachImageTag];
    
    [titleLabel setText:_itemTitle];
    
//    CGSize size = [_itemTitle sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, titleLabel.frame.size.height)];
    
    CGSize size = [_itemTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, titleLabel.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : titleLabel.font} context:nil].size;
    
    if (self.itemAttachImage) {
        [titleLabel setFrame:CGRectMake((self.bounds.size.width - 25 - size.width)/2,
                                        (self.bounds.size.height - size.height)/2,
                                        size.width,
                                        size.height)];
        CGRect attachImageFrame = attachImage.frame;
        attachImageFrame.origin.x = titleLabel.frame.origin.x + size.width + 5;
        [attachImage setFrame:attachImageFrame];
    }else if (self.itemAttachView){
        [titleLabel setFrame:CGRectMake((self.bounds.size.width - 25 - size.width)/2,
                                        (self.bounds.size.height - size.height)/2,
                                        size.width,
                                        size.height)];
        CGRect attachViewFrame = self.itemAttachView.frame;
        attachViewFrame.origin.x = titleLabel.frame.origin.x + size.width;
        [self.itemAttachView setFrame:attachViewFrame];
        //        [self addSubview:self.itemAttachView];
    }else{
        [titleLabel setFrame:CGRectMake((self.bounds.size.width - size.width)/2,
                                        (self.bounds.size.height - size.height)/2,
                                        size.width,
                                        size.height)];
    }
    
}

- (void)setIsSelected:(BOOL)isSelected {
    if (isSelected) {
        [(UIImageView *)[self viewWithTag:kSeletedImageTag] setImage:self.selectedImage];
        [(UILabel *)[self viewWithTag:kItemTitleTag] setTextColor:_sColor];
    }else {
        [(UIImageView *)[self viewWithTag:kSeletedImageTag] setImage:nil];
        [(UILabel *)[self viewWithTag:kItemTitleTag] setTextColor:_nColor];
    }
    _isSelected = isSelected;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.isSelected || self.itemAttachImage) {
        if (!self.isSelected) {
            [(UIImageView *)[self viewWithTag:kSeletedImageTag] setImage:self.selectedImage];
            [(UILabel *)[self viewWithTag:kItemTitleTag] setTextColor:TitleSelectedColor];
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(selectedItemWithIndex:)]) {
            [_delegate selectedItemWithIndex:self.itemIndex];
        }
    }
    
}

@end

#pragma mark - SegmentControl Class

#define kSegmentBgTag 2001
#define kBeginDevisionLineTag 2002
#define kBeginItemViewTag 2100

@interface SegmentControllView()

@property (nonatomic,assign)NSUInteger itemCount;

@end


@implementation SegmentControllView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize selectedIndex = _selectedIndex;
@synthesize selectedItem = _selectedItem;
@synthesize itemCount = _itemCount;

- (void)dealloc {
    if (_selectedItem){
        _selectedItem = nil;
    }
}

- (void)initSegmentWithItems:(NSArray *)itemArray {
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:self.bounds];
    [bgImage setTag:kSegmentBgTag];
    [self addSubview:bgImage];
    
    for (int i = 0; i < [itemArray count]; i++) {
        SegmentItem *item = (SegmentItem *)[itemArray objectAtIndex:i];
        [item setDelegate:self];
        [item setTag:kBeginItemViewTag + i];
        [self addSubview:item];
        
        UIImageView *devisionImage = [[UIImageView alloc] initWithFrame:CGRectMake(item.frame.origin.x + item.frame.size.width,
                                                                                   (self.bounds.size.height - 14.5)/2, 1, 14.5)];
        [devisionImage setTag:kBeginDevisionLineTag + i];
        [self addSubview:devisionImage];
    }
}

- (id)initWithFrame:(CGRect)frame items:(NSArray *)itemArray {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.itemCount = [itemArray count];
        [self initSegmentWithItems:itemArray];
    }
    
    return self;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    _delegate = target;
    _segmentAction = action;
    _controlEvents = controlEvents;
}

- (void)setSegmentBg:(UIImage *)bgImage DevisionLine:(UIImage *)lineImage {
    [(UIImageView *)[self viewWithTag:kSegmentBgTag] setImage:bgImage];
    
    for (int i = 0; i < self.itemCount - 1; i++) {
        [(UIImageView *)[self viewWithTag:kBeginDevisionLineTag + i] setImage:lineImage];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    for (int i = 0; i < self.itemCount; i++) {
        SegmentItem *item = (SegmentItem *)[self viewWithTag:kBeginItemViewTag + i];
        if (selectedIndex == i) {
            item.isSelected = YES;
        }else {
            item.isSelected = NO;
        }
    }
}

#pragma  mark - SegmentItem delegate

- (void)selectedItemWithIndex:(NSInteger)itemIndex {
    for (int i = 0; i < self.itemCount; i++) {
        SegmentItem *item = (SegmentItem *)[self viewWithTag:kBeginItemViewTag + i];
        if (itemIndex == i) {
            item.isSelected = YES;
            self.selectedItem = item;
        }else {
            item.isSelected = NO;
        }
    }
    
    self.selectedIndex = itemIndex;
    
    if (_controlEvents == UIControlEventValueChanged) {
//        IMP imp = [_delegate methodForSelector:_segmentAction];
//        void (*func)(id, SEL) = (void *)imp;
//        func(_delegate, _segmentAction);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if (_delegate && [_delegate respondsToSelector:_segmentAction]) {
            [_delegate performSelector:_segmentAction withObject:self];
        }
#pragma clang diagnostic pop
    }
}
@end
