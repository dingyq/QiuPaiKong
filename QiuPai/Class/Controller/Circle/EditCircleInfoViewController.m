//
//  EditCircleInfoViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/11/19.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "EditCircleInfoViewController.h"
#import "SearchViewController.h"
#import "ZLPhoto.h"
#import "EvaluationPublishStatusView.h"
#import "EvalGoodsSimpleInfoView.h"
#import "UIImage+ImageFixOrientaion.h"

#define PublishTipViewTag 9898
static NSInteger TitleWordsMaxNum = 18;
static NSInteger ContentWordsMaxNum = 1000;

@interface EditCircleInfoViewController() <VCInteractionDelegate, PhotoDisplayViewDelegate, ZLPhotoPickerBrowserViewControllerDataSource, ZLPhotoPickerBrowserViewControllerDelegate, ZLPhotoPickerViewControllerDelegate, UITextViewDelegate, WXApiManagerDelegate> {
    UIButton *_publishBtn;
    UITableView *_editTableView;
    NSArray *_tvCellListArr;
    PlaceHolderTextView *_titleInputView;
    CircleEditView *_circleEditView;
    EvalGoodsSimpleInfoView *_goodsInfoView;
    NSInteger _cellClickIndex;
    
    NSMutableArray *_imagePickedArr; // 临时存储相册选取的照片
    NSInteger _imageWaitToUploadCount; // 待上传图片数量
    NSMutableArray *_picUrl;
    NSMutableArray *_thumbPicUrl;
    
    CGFloat _totalBytesWritten;
    CGFloat _totalBytesExpectedToWrite;
    
    BOOL _isShareToPyq;
}
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) EvaluationPublishStatusView *publishTipView;

@end

@implementation EditCircleInfoViewController

- (EvaluationPublishStatusView *)publishTipView {
    if (!_publishTipView) {
        _publishTipView = [[EvaluationPublishStatusView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight)];
    }
    return _publishTipView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:VCViewBGColor];
    self.title = @"写评测";
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(publishNowBtnClick:)];
//    self.navigationItem.rightBarButtonItem = rightButton;
    
    _publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_publishBtn setFrame:CGRectMake(0, 0, 40, 25)];
    [_publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    _publishBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [_publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_publishBtn setTitleColor:Gray153Color forState:UIControlStateDisabled];
    [_publishBtn addTarget:self action:@selector(publishNowBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:_publishBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    [self resetPublishBtnState];
    
    _imagePickedArr = [[NSMutableArray alloc] init];
//    _tvCellListArr = @[@"添加球拍", @"添加球线" ,@"我的使用心得"];
    _tvCellListArr = @[@"添加装备", @"输入我的使用心得"];
    _cellClickIndex = 0;
    _imageWaitToUploadCount = 0;
    _picUrl = [[NSMutableArray alloc] init];
    _thumbPicUrl = [[NSMutableArray alloc] init];
    _isShareToPyq = NO;
    
    [WXApiManager sharedManager].delegate = self;
    [self initEditTableView];
    
    UITapGestureRecognizer* tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.numberOfTapsRequired = 1;
    tapGr.cancelsTouchesInView = NO;
    [_editTableView addGestureRecognizer:tapGr];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [_titleInputView resignFirstResponder];
    [_circleEditView hideKeyBoard];
}

- (void)dealloc {
    [WXApiManager sharedManager].delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)resetPublishBtnState {
//    if (_racketSRModel && _racketLineSRModel && ![[self getEvaluationTitle] isEqualToString:@""] && ![[self getEvaluationContent] isEqualToString:@""] && ([_imagePickedArr count] > 0)) {
//        [_publishBtn setEnabled:YES];
//    } else {
//        [_publishBtn setEnabled:NO];
//    }
}

- (void)initEditTableView {
    _editTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight) style:UITableViewStylePlain];
    [_editTableView setDelegate:self];
    [_editTableView setDataSource:self];
    [self.view addSubview:_editTableView];
    [_editTableView setBackgroundColor:VCViewBGColor];
    _editTableView.separatorColor = [UIColor lightGrayColor];
    _editTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *footerView = [[UIView alloc] init];
    _editTableView.tableFooterView = footerView;
    [footerView setBackgroundColor:[UIColor clearColor]];
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    searchVC.myDelegate = self;
    searchVC.isNeedBackPreVc = YES;
    searchVC.searchType = GoodsSearchType_All;
    searchVC.searchPlaceholder = @"搜索你要评测的装备";
//    if ([identifier isEqualToString:IdentifierRacketSearch]) {
//        searchVC.searchType = GoodsSearchType_Racket;
//        searchVC.searchPlaceholder = @"搜索你要评测的球拍";
//    } else if ([identifier isEqualToString:IdentifierRacketLineSearch]) {
//        searchVC.searchType = GoodsSearchType_RacketLine;
//        searchVC.searchPlaceholder = @"搜索你要评测的球线";
//    }
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)publishNowBtnClick:(UIButton *)sender {
    [_titleInputView resignFirstResponder];
    [_circleEditView hideKeyBoard];
    
    BOOL canPublish = YES;
    NSString *errMsg = @"";
    if ([[QiuPaiUserModel getUserInstance] isTimeOut]) {
        [[QiuPaiUserModel getUserInstance] showUserLoginVC];
        return;
    } else if (!_goodsSRModel) {
        errMsg = @"请选择要评测的装备";
        canPublish = NO;
    }
//    else if (!_racketLineSRModel) {
//        errMsg = @"no racket line";
//        canPublish = NO;
//    }
    else if ([[self getEvaluationTitle] isEqualToString:@""]) {
        errMsg = @"请输入评测标题";
        canPublish = NO;
    } else if ([[self getEvaluationContent] isEqualToString:@""]) {
        errMsg = @"请输入评测内容";
        canPublish = NO;
    } else if ([_imagePickedArr count] == 0) {
        canPublish = NO;
        errMsg = @"请添加待评测装备图片";
    }
    if (!canPublish) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:errMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    [self.publishTipView show];
    [_picUrl removeAllObjects];
    [_thumbPicUrl removeAllObjects];
    _totalBytesWritten = 0;
    _totalBytesExpectedToWrite = 0;
    _imageWaitToUploadCount = [_imagePickedArr count];
    for (int i = 0; i < [_imagePickedArr count]; i++) {
        NSString *fileName = [NSString stringWithFormat:@"image_%d", i];
        UIImage *image = [_imagePickedArr objectAtIndex:i];
        NSData *imgDataCompress = UIImageJPEGRepresentation(image, kImageCompressScale);
        _totalBytesExpectedToWrite += [imgDataCompress length];
        _totalBytesExpectedToWrite += 257;
        [self uploadImage:image fileName:fileName];
    }
}

- (void)uploadImage:(UIImage *)image fileName:(NSString *)name {
    __weak typeof(self) weakSelf = self;
    RequestInfo *info = [HttpRequestManager sendUploadImageRequest:image fileName:name];
    info.delegate = self;
    info.uploadProgress = ^(NSUInteger bytesWritten,long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        _totalBytesWritten += bytesWritten;
        [weakSelf.publishTipView updateProgress:_totalBytesWritten/_totalBytesExpectedToWrite];
    };
}

- (NSString *)getEvaluationContent {
    if (_circleEditView) {
        return [_circleEditView.textView text];
    }
    return @"";
}

- (NSString *)getEvaluationTitle {
    if (_titleInputView) {
        return _titleInputView.text;
    }
    return @"";
}

- (void)sendEvaluation {
    NSArray *goodsName = @[_goodsSRModel.name];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:goodsName forKey:@"goodsName"];
    [paramDic setObject:[NSNumber numberWithInteger:0] forKey:@"evaluateId"];
    [paramDic setObject:[self getEvaluationTitle] forKey:@"title"];
    [paramDic setObject:[self getEvaluationContent] forKey:@"content"];
    [paramDic setObject:_picUrl forKey:@"picUrl"];
    [paramDic setObject:_thumbPicUrl forKey:@"thumbPicUrl"];
    [paramDic setObject:[NSNumber numberWithInteger:2] forKey:@"getBackData"];
    
    RequestInfo *info = [HttpRequestManager publishNewEvaluation:paramDic];
    info.delegate = self;
}

- (CGFloat)getCellHeight:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    CGFloat height = 200.0f;
    if (section == 0 ) {
        height = 96.0f;
    } else {
        if (row == 0) {
            height = 51.0f;
        } else if (row == 1) {
            height = 228.0f;
        } else {
            height = 40.0f;
        }
    }
    return height;
}

- (NSMutableArray *)assets{
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}

#pragma -mark VCInteractionDelegate

- (void)sendSearchResult:(id)result {
    [self resetPublishBtnState];
    RacketSearchModel *dataModel = (RacketSearchModel*)result;
    _goodsSRModel = [dataModel copy];
//    
//    if (_cellClickIndex == 0) {
//        _racketSRModel = [dataModel copy];
//    } else if(_cellClickIndex == 1) {
//        _racketLineSRModel = [dataModel copy];
//    }
    [_editTableView reloadData];
}

#pragma -mark PhotoDisplayViewDelegate

- (void)openPhotoPickerView:(id)sender {
    // 创建控制器
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.selectPickers = self.assets;
    // 最多能选3张图片
    pickerVc.maxCount = 3;
    pickerVc.delegate = self;
    [pickerVc showPickerVc:self];
    pickerVc.topShowPhotoPicker = YES;
    
    /**
     *
     传值可以用代理，或者用block来接收，以下是block的传值
     __weak typeof(self) weakSelf = self;
     pickerVc.callBack = ^(NSArray *assets){
     weakSelf.assets = assets;
     [weakSelf.tableView reloadData];
     };
     */
}

- (void)photoTapAction:(UITapGestureRecognizer *)tapGesture {
    NSLog(@"photoTapAction");
    UIImageView *imageView = (UIImageView *)tapGesture.view;
    long index = ([imageView tag])/100 - 1;

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 数据源/delegate
    pickerBrowser.delegate = self;
    pickerBrowser.dataSource = self;
    // 是否可以删除照片
    pickerBrowser.editing = YES;
    // 当前选中的值
    pickerBrowser.currentIndexPath = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
    // 展示控制器
    [pickerBrowser showPickerVc:self];
}

#pragma mark - WXApiManagerDelegate
- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response {
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", response.errCode];
    if (response.errCode == 0) {
        NSLog(@"分享成功 %@", strMsg);
        [Helper uploadShareEventDataToUmeng:ShareScene_WxPyq content:@"装备评测" name:@"" cId:0];
    } else {
        NSLog(@"分享失败 %@", strMsg);
    }
    [self backToPreVC:nil];
}

#pragma -mark NetWorkDelegate
- (void)netWorkFinishedCallBack:(NSDictionary *)dic withRequestID:(NetWorkRequestID)requestID {
    if (RequestID_UploadImage == requestID) {
        if (NetWorkJsonResOK == [[dic objectForKey:@"statusCode"] integerValue]) {
            _imageWaitToUploadCount --;
            if (NetWorkJsonResOK == [[dic objectForKey:@"statusCode"] integerValue]) {
                [_picUrl addObject:[dic objectForKey:@"fileName"]];
                [_thumbPicUrl addObject:[dic objectForKey:@"thumbFileName"]];
            }
            if (_imageWaitToUploadCount == 0) {
                [self.publishTipView hide];
                [self sendEvaluation];
            }
        } else {
            // 出现图片上传失败问题，停止发布；
            [self.publishTipView hide];
            [self loadingTipView:@"图片上传失败" callBack:^{
                
            }];
        }
    } else if (RequestID_PublishNewEvaluation == requestID) {
        [self.publishTipView hide];
        if (NetWorkJsonResOK == [[dic objectForKey:@"statusCode"] integerValue]) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            NSLog(@"发布成功");
            if (_isShareToPyq) {
                [Helper generateUserTemplateImage:[QiuPaiUserModel getUserInstance].nick sex:[[QiuPaiUserModel getUserInstance].sex integerValue] headImage:[QiuPaiUserModel getUserInstance].headPic likeNum:0 influence:0];
                
                UIImage *tmpImage = [UIImage imageWithContentsOfFile:KShareImagePath];
                NSData *imageData = UIImageJPEGRepresentation(tmpImage, 1.0);
                UIImage *thumbImage =[UIImage imageWithContentsOfFile:KShareThumbImagePath];
                [WXApiRequestHandler sendImageData:imageData
                                           TagName:kImageTagName
                                        MessageExt:kMessageExt
                                            Action:kMessageAction
                                        ThumbImage:thumbImage
                                           InScene:WXSceneTimeline];
            } else {
                __weak typeof(self) weakSelf = self;
                NSArray *tmpArr = [dataDic objectForKey:@"contData"];
                [self loadingTipView:@"发布成功" callBack:^{
                    if ([tmpArr count]>0) {
                        [weakSelf.myDelegate publishNewEvaluationSuccess:[tmpArr firstObject]];
                    }
                    [weakSelf backToPreVC:nil];
                }];
            }
        } else {
            NSLog(@"发布失败");
            [self loadingTipView:@"发布失败" callBack:^{}];
        }
    }
}

- (void)netWorkFailedCallback:(NSError *)err withRequestID:(NetWorkRequestID)requestID {
    if (RequestID_UploadImage == requestID) {
        [self.publishTipView hide];
        [self loadingTipView:@"图片上传失败" callBack:^{}];
    } else if (RequestID_PublishNewEvaluation == requestID) {
        [self.publishTipView hide];
        [self loadingTipView:@"发布失败" callBack:nil];
    }
}

#pragma -mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect frame = [_editTableView frame];
    frame.origin.y -= 116.0f;
    [_editTableView setFrame:frame];
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect frame = [_editTableView frame];
    frame.origin.y += 116.0f;
    [_editTableView setFrame:frame];
    [UIView commitAnimations];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self resetPublishBtnState];
    NSInteger number = [textView.text length];
    if ([_titleInputView isEqual:textView] && number > TitleWordsMaxNum) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"字符个数不能大于128" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
        textView.text = [textView.text substringToIndex:TitleWordsMaxNum];
    } else if ([_circleEditView.textView isEqual:textView] && number > ContentWordsMaxNum) {
        textView.text = [textView.text substringToIndex:ContentWordsMaxNum];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self resetPublishBtnState];
        return NO;
    }
    return YES;
}

#pragma -mark TableView Delegate
#pragma -mark

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    _cellClickIndex = indexPath.section;
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:IdentifierRacketSearch sender:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 10)];
    [tmpView setBackgroundColor:[UIColor clearColor]];
    return tmpView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (void)syncMessageToPyq:(UIButton *)sender {
    [sender setSelected:![sender isSelected]];
    _isShareToPyq = [sender isSelected];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getCellHeight:indexPath];
}

#pragma -mark
#pragma -mark TableView DataSource
#pragma -mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    CGFloat cellHeight = [self getCellHeight:indexPath];
    NSString *identifier = @"RacketChooseCell";
    if (section == 0) {
        EvalGoodsSimpleInfoView *goodsInfo;
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            goodsInfo = [[EvalGoodsSimpleInfoView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, cellHeight)];
//            [goodsInfo showGoodsSelectTip:[_tvCellListArr objectAtIndex:section]];
            [goodsInfo setTag:102];
            [cell.contentView addSubview:goodsInfo];
        }
        goodsInfo = [cell.contentView viewWithTag:102];
        [goodsInfo showGoodsSelectTip:[_tvCellListArr objectAtIndex:section]];
        if (section < [_tvCellListArr count] - 1) {
            if (_goodsSRModel) {
                if (_goodsSRModel.type == GoodsSearchType_Racket) {
                    [goodsInfo setRacketInfo:_goodsSRModel.thumbPicUrl name:_goodsSRModel.name weight:[NSString stringWithFormat:@"%ldg", (long)_goodsSRModel.weight] balance:_goodsSRModel.balance headSize:[NSString stringWithFormat:@"%.0f平方英寸", _goodsSRModel.headSize]];
                } else if (_goodsSRModel.type == GoodsSearchType_RacketLine) {
                    [goodsInfo setRacketLineInfo:_goodsSRModel.thumbPicUrl name:_goodsSRModel.name caiZhi:_goodsSRModel.desc];
                }
            }
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    } else {
//        identifier = @"EditCircleCell";
        if (row == 0) {
            PlaceHolderTextView *titleInput;
            identifier = @"EditCircleCell1";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                titleInput = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(15, 9, kFrameWidth, cellHeight-18)];
                titleInput.placeholder = [NSString stringWithFormat:@"输入%ld字以内标题", (long)TitleWordsMaxNum];
                [titleInput.placeHolderLabel setFrame:CGRectMake(5, 6, titleInput.frame.size.width-10, 20)];
                titleInput.delegate = self;
                [titleInput setTextColor:Gray17Color];
                titleInput.font = [UIFont systemFontOfSize:15.0f];
                titleInput.placeholderColor = Gray153Color;
                [titleInput setTag:101];
                [cell.contentView addSubview:titleInput];
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            titleInput = [cell.contentView viewWithTag:101];
            _titleInputView = titleInput;
            return cell;
        } else if (row == 1) {
            CircleEditView *circleEdit;
            identifier = @"EditCircleCell2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                
                circleEdit = [[CircleEditView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, cellHeight)];
                circleEdit.textView.placeholder = [_tvCellListArr objectAtIndex:[_tvCellListArr count]-1];
                [circleEdit.textView setTextColor:Gray17Color];
                circleEdit.delegate = self;
                circleEdit.textView.delegate = self;
                [circleEdit setTag:103];
                [cell.contentView addSubview:circleEdit];
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 0.5)];
                [lineView setBackgroundColor:LineViewColor];
                [cell.contentView addSubview:lineView];
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            circleEdit = [cell.contentView viewWithTag:103];
            _circleEditView = circleEdit;
            return cell;
        } else {
            UIView *syncMsgView;
            identifier = @"EditCircleCell3";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                
                syncMsgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 40.0)];
                [syncMsgView setBackgroundColor:[UIColor clearColor]];
                
                UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [shareBtn setBackgroundColor:[UIColor clearColor]];
                [shareBtn setFrame:CGRectMake(0, 5, 76, 30)];
                [shareBtn setImage:[UIImage imageNamed:@"pyq_share_nor.png"] forState:UIControlStateNormal];
                [shareBtn setImage:[UIImage imageNamed:@"pyq_share_sel.png"] forState:UIControlStateSelected];
                shareBtn.imageEdgeInsets = UIEdgeInsetsMake(4, 54, 4, 0);
                [shareBtn setTitle:@"同步:" forState:UIControlStateNormal];
                [shareBtn setTitle:@"同步:" forState:UIControlStateSelected];
                shareBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
                [shareBtn addTarget:self action:@selector(syncMessageToPyq:) forControlEvents:UIControlEventTouchUpInside];
                [shareBtn setTitleColor:Gray153Color forState:UIControlStateNormal];
                [shareBtn setTitleColor:Gray153Color forState:UIControlStateSelected];
                shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 30);
                [shareBtn setSelected:YES];
                [syncMsgView setTag:104];
                [syncMsgView addSubview:shareBtn];
                [cell.contentView addSubview:syncMsgView];
            }
//            syncMsgView = [cell.contentView viewWithTag:104];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBackgroundColor:[UIColor clearColor]];
            return cell;
        }
    }
}

#pragma mark - ZLPhotoPickerViewControllerDelegate

- (void)pickerViewControllerDoneAsstes:(NSArray *)assets {
    self.assets = [NSMutableArray arrayWithArray:assets];
    [_imagePickedArr removeAllObjects];
    NSMutableArray *tmpThumbImageArr = [[NSMutableArray alloc] init];
    
    for (ZLPhotoAssets *asset in self.assets) {
        if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
            [_imagePickedArr addObject:asset.originImage];
            [tmpThumbImageArr addObject:asset.thumbImage];
        } else if ([asset isKindOfClass:[UIImage class]]) {
            /*
             * 如果我们忽略orientation信息，而直接对照片进行像素处理或者drawInRect等操作，得到的结果是翻转或者旋转90之后的样子。
             * 这是因为我们执行像素处理或者drawInRect等操作之后，imageOrientaion信息被删除了，imageOrientaion被重设为0，
             * 造成照片内容和imageOrientaion不匹配。
             * 所以，在对照片进行处理之前，先将照片旋转到正确的方向，并且返回的imageOrientaion为0。
             */
            UIImage *tmpImage = (UIImage *)asset;
            [_imagePickedArr addObject:[UIImage fixOrientation:tmpImage]];
            [tmpThumbImageArr addObject:asset];
        }
    }
    
    if (_circleEditView) {
        // image初始化显示view
        [_circleEditView reloadImageData:tmpThumbImageArr];
    }
}

#pragma mark - setupCell click ZLPhotoPickerBrowserViewController
//- (void) setupPhotoBrowser:(Example1TableViewCell *) cell{
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    // 图片游览器
//    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
//    // 数据源/delegate
//    pickerBrowser.delegate = self;
//    pickerBrowser.dataSource = self;
//    // 是否可以删除照片
//    pickerBrowser.editing = YES;
//    // 当前选中的值
//    pickerBrowser.currentIndexPath = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
//    // 展示控制器
//    [pickerBrowser showPickerVc:self];
//}

#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser{
    return 1;
}

- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return self.assets.count;
}

#pragma mark - 每个组展示什么图片,需要包装下ZLPhotoPickerBrowserPhoto
- (ZLPhotoPickerBrowserPhoto *) photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    ZLPhotoAssets *imageObj = [self.assets objectAtIndex:indexPath.row];
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
//    Example1TableViewCell *cell = (Example1TableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_circleEditView.frame), CGRectGetMinY(_circleEditView.frame), 60, 60)];
    [tmpImageView setImage:imageObj.originImage];
    photo.toView = tmpImageView;
    photo.thumbImage = tmpImageView.image;
    return photo;
}

#pragma mark - <ZLPhotoPickerBrowserViewControllerDelegate>
#pragma mark 删除照片调用
- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > [self.assets count]) return;
    [self.assets removeObjectAtIndex:indexPath.row];
//    [self.tableView reloadData];
}

@end
