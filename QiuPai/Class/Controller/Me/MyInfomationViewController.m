//
//  MyInfomationViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/11/21.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "MyInfomationViewController.h"
#import "InfomationCell.h"
#import "QiuPaiUserModel.h"
#import "CompleteInfomationViewController.h"
#import "ModifyNickViewController.h"
#import "ModifyRacketViewController.h"
#import "KnockUpReportViewController.h"

#import "LocationChooseViewController.h"
#import "SexChooseViewController.h"
#import "UILabel+FontAppearance.h"

@interface MyInfomationViewController () <NetWorkDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    NSArray *_configArr;
    NSArray *_valueArr;
    UITableView *_infoTV;
}

@end

@implementation MyInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的资料";
    [self.view setBackgroundColor:VCViewBGColor];
    
    
    UILabel * appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
    [appearanceLabel setAppearanceFont:[UIFont systemFontOfSize:15.0f]]; //for example
//    试打资料完善
    _configArr = @[@[@"头像", @"昵称", @"球龄", @"性别", @"试打报告"], @[@"使用的球拍", @"所在地", @"网球水平自测"]];
    [self updateValueArr];
    
    [self initInfoTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)updateValueArr {
    NSString *headPic = [QiuPaiUserModel getUserInstance].headPic;
    NSString *niCheng = [QiuPaiUserModel getUserInstance].nick;
    NSString *qiuLing = [NSString stringWithFormat:@"%@", [QiuPaiUserModel getUserInstance].playYear];
    NSString *xingBie = @"男";
    if ([[QiuPaiUserModel getUserInstance].sex integerValue] == SexIndicatorGirl) {
        xingBie = @"女";
    }
    NSString *qiuPaiUsed = [QiuPaiUserModel getUserInstance].racquet;
    NSString *location = [NSString stringWithFormat:@"%@ %@", [QiuPaiUserModel getUserInstance].province, [QiuPaiUserModel getUserInstance].city];
    NSString *ziCe = [NSString stringWithFormat:@"%.1f", [[QiuPaiUserModel getUserInstance].lvEevaluate integerValue]/10.0];
    _valueArr = @[@[headPic, niCheng, qiuLing, xingBie, @""], @[qiuPaiUsed, location, ziCe]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:IdentifierKnockUpReport]) {
        // 我的试打报告
        KnockUpReportViewController *vc = [[KnockUpReportViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([identifier isEqualToString:IdentifierModifySexVC]) {
        SexChooseViewController *vc = [[SexChooseViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.callDelegate = self;
        vc.sex = [[QiuPaiUserModel getUserInstance].sex integerValue];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([identifier isEqualToString:IdentifierModifyLocationVC]) {
        LocationChooseViewController *vc = [[LocationChooseViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.callDelegate = self;
        vc.title = @"所在地";
        vc.province = [QiuPaiUserModel getUserInstance].province;
        vc.city = [QiuPaiUserModel getUserInstance].city;
        vc.modifyType = InfoModifyTypeLocation;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([identifier isEqualToString:IdentifierModifyPlayYearVC]) {
        LocationChooseViewController *vc = [[LocationChooseViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.callDelegate = self;
        vc.title = @"球龄";
        vc.playYear = [QiuPaiUserModel getUserInstance].playYear;
        vc.modifyType = InfoModifyTypePlayYear;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([identifier isEqualToString:IdentifierModifySelfEvaluVC]) {
        LocationChooseViewController *vc = [[LocationChooseViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.callDelegate = self;
        vc.title = @"网球水平自测";
        vc.lvEvalu = [[QiuPaiUserModel getUserInstance].lvEevaluate integerValue];
        vc.modifyType = InfoModifyTypeSelfEvalu;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([identifier isEqualToString:IdentifierModifyNickVC]) {
        // 修改昵称
        ModifyNickViewController *vc = [[ModifyNickViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.callDelegate = self;
        vc.title = @"昵称";
        vc.nickName = [QiuPaiUserModel getUserInstance].nick;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([identifier isEqualToString:IdentifierModifyRacketUsedVC]) {
        ModifyRacketViewController *vc = [[ModifyRacketViewController alloc] init];
        vc.title = @"使用的球拍";
        vc.racketModel.name = [QiuPaiUserModel getUserInstance].racquet;
        vc.callDelegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)initInfoTableView {
    _infoTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight) style:UITableViewStylePlain];
    [_infoTV setDelegate:self];
    [_infoTV setDataSource:self];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [_infoTV setBackgroundColor:Gray240Color];
    [_infoTV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_infoTV];
    
    UIView *tmpView = [[UIView alloc] init];
    [tmpView setBackgroundColor:[UIColor clearColor]];
    [_infoTV setTableFooterView:tmpView];
}

- (void)sendModifyUserInfoRequest:(NSDictionary *)infoDic {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithDictionary:infoDic];
    [paramDic setObject:[NSNumber numberWithInt:1] forKey:@"getBackData"];
    RequestInfo *info = [HttpRequestManager modifyPersonalInfo:paramDic];
    info.delegate = self;
}

- (void)reloadTableView {
    [self updateValueArr];
    [_infoTV reloadData];
}

- (void)openCameraOrPhotoLibrary:(UIImagePickerControllerSourceType)sourceType {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)openHeadModifyTipView {
#ifdef __IPHONE_8_0
    if (TARGET_IS_IOS8) {
        UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil
                                                                                       message:nil
                                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"拍照"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            [self openCameraOrPhotoLibrary:UIImagePickerControllerSourceTypeCamera];
                                                        }];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"从手机相册选择"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            [self openCameraOrPhotoLibrary:UIImagePickerControllerSourceTypePhotoLibrary];
                                                        }];
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {}];
        [actionSheetController addAction:action0];
        [actionSheetController addAction:action1];
        [actionSheetController addAction:actionCancel];
        [actionSheetController.view setTintColor:Gray51Color];
        
        [self presentViewController:actionSheetController animated:YES completion:nil];
    }
#endif
    if (TARGET_NOT_IOS8) {
        UIActionSheet *myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
        [myActionSheet showInView:self.view];
    }
}

- (void)uploadImage:(UIImage *)image fileName:(NSString *)name {
    RequestInfo *info = [HttpRequestManager sendUploadImageRequest:image fileName:name];
    info.delegate = self;
    info.uploadProgress = ^(NSUInteger bytesWritten,long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    };
}

// 拍照
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    //得到图片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self uploadImage:image fileName:@"head_image"];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 取消
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma -mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                //来源:相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                //来源:相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                return;
        }
    } else {
        if (buttonIndex == 2) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    
    [self openCameraOrPhotoLibrary:sourceType];
}


#pragma -mark CompleteInfomationDelagate
- (void)racketChooseDone:(NSString *)racketName {
    if ([racketName isEqualToString:[QiuPaiUserModel getUserInstance].racquet]) {
        return;
    }
    [QiuPaiUserModel getUserInstance].racquet = racketName;
    NSDictionary *dic = @{@"racquet":racketName};
    [self sendModifyUserInfoRequest:dic];
}

- (void)nickNameModify:(NSString *)nickName {
    if ([nickName isEqualToString:[QiuPaiUserModel getUserInstance].nick]) {
        return;
    }
    [QiuPaiUserModel getUserInstance].nick = nickName;
    NSDictionary *dic = @{@"nick":nickName};
    [self sendModifyUserInfoRequest:dic];
}

- (void)playYearChooseDone:(NSString *)playYear {
    if ([playYear isEqualToString:[QiuPaiUserModel getUserInstance].playYear]) {
        return;
    }
    [QiuPaiUserModel getUserInstance].playYear = playYear;
    // 修改球龄
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *numTemp = [numberFormatter numberFromString:playYear];
    NSDictionary *dic = @{@"playYear":numTemp};
    [self sendModifyUserInfoRequest:dic];
}

- (void)lvEveluateChooseDone:(NSInteger)lvEveluate {
    if ([[QiuPaiUserModel getUserInstance].lvEevaluate integerValue] == lvEveluate) {
        return;
    }
    [QiuPaiUserModel getUserInstance].lvEevaluate = [NSNumber numberWithInteger:lvEveluate];
    // 修改网球水平自测
    NSDictionary *dic = @{@"lvEevaluate":[NSNumber numberWithInteger:lvEveluate]};
    [self sendModifyUserInfoRequest:dic];
}

- (void)sexChooseDone:(SexIndicator)sex {
    if (sex == [[QiuPaiUserModel getUserInstance].sex integerValue]) {
        return;
    }
    [QiuPaiUserModel getUserInstance].sex = [NSNumber numberWithInt:sex];
    // 修改性别
    NSDictionary *dic = @{@"sex":[NSNumber numberWithInteger:sex]};
    [self sendModifyUserInfoRequest:dic];
}

- (void)locationChooseDone:(NSString *)province city:(NSString *)city {
    if ([[QiuPaiUserModel getUserInstance].province isEqualToString:province] && [[QiuPaiUserModel getUserInstance].city isEqualToString:city]) {
        return;
    }
    [QiuPaiUserModel getUserInstance].province = province;
    [QiuPaiUserModel getUserInstance].city = city;
    // 修改所在地
    NSDictionary *dic = @{@"province":province, @"city":city};
    [self sendModifyUserInfoRequest:dic];
}

#pragma mark - NetWorkDelegate
- (void)netWorkFinishedCallBack:(NSDictionary *)dic withRequestID:(NetWorkRequestID)requestID {
    NSLog(@"result is %@", dic);
    if (RequestID_UploadImage == requestID) {
        if (NetWorkJsonResOK == [[dic objectForKey:@"statusCode"] integerValue]) {
            [QiuPaiUserModel getUserInstance].headPic = [dic objectForKey:@"fileName"];
            [QiuPaiUserModel getUserInstance].thumbHeadPic = [dic objectForKey:@"thumbFileName"];
            NSDictionary *paramDic = @{@"headPic":[dic objectForKey:@"fileName"], @"thumbHeadPic":[dic objectForKey:@"thumbFileName"]};
            [self sendModifyUserInfoRequest:paramDic];
        }
    } else if (RequestID_ModifyPersonalInfo == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            // 修改个人信息成功
            // update个人信息，并更新界面
            [self reloadTableView];
            [QiuPaiUserModel saveSelfToCoreData];
        }
    }
}

- (void)netWorkFailedCallback:(NSError *)err withRequestID:(NetWorkRequestID)requestID {

}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_configArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_configArr[section] count];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 17.0f)];
    [tmpView setBackgroundColor:[UIColor clearColor]];
    return tmpView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 17.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 43.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"infomationCell";
    InfomationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[InfomationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSString *tipStr = [_configArr[indexPath.section] objectAtIndex:indexPath.row];
    NSString *valueStr = [_valueArr[indexPath.section] objectAtIndex:indexPath.row];
    
    [cell bindCellWithData:tipStr valueStr:valueStr indexPath:(NSIndexPath*)indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setBackgroundColor:[UIColor whiteColor]];
    return cell;
}

//修改ActionSheet的字体颜色
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            [button setTitleColor:Gray51Color forState:UIControlStateNormal];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 修改头像
            [self openHeadModifyTipView];
        } else if (indexPath.row == 1) {
            // 修改昵称
            [self performSegueWithIdentifier:IdentifierModifyNickVC sender:nil];
        } else if (indexPath.row == 2) {
            // 修改球龄
            [self performSegueWithIdentifier:IdentifierModifyPlayYearVC sender:nil];
        } else if (indexPath.row == 3) {
            // 修改性别
            [self performSegueWithIdentifier:IdentifierModifySexVC sender:nil];
        } else if (indexPath.row == 4) {
            // 我的试打报告
            [self performSegueWithIdentifier:IdentifierKnockUpReport sender:nil];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // 修改使用的球拍
            [self performSegueWithIdentifier:IdentifierModifyRacketUsedVC sender:nil];
        } else if (indexPath.row == 1) {
            // 修改所在地
            [self performSegueWithIdentifier:IdentifierModifyLocationVC sender:nil];
        } else if (indexPath.row == 2) {
            // 网球水平自测
            [self performSegueWithIdentifier:IdentifierModifySelfEvaluVC sender:nil];
        }
    }
}


@end
