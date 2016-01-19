//
//  BaseTableViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/11/30.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "BaseTableViewController.h"
#import "UINavigationBar+BackgroundColor.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationController.navigationBar.barTintColor = CustomGreenColor;
    self.navigationController.navigationBar.layer.contents = (id)[Helper imageWithColor:CustomGreenColor].CGImage;
    [self.navigationController.navigationBar lt_setBackgroundColor:CustomGreenColor];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    NSDictionary *tmpdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:18.0],NSFontAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = tmpdic;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 25, 25)];
    [backBtn setImage:[UIImage imageNamed:@"back_button.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToPreVC:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (DDActivityIndicatorView *)netIndicatorView {
    if (!_netIndicatorView) {
        _netIndicatorView = [[DDActivityIndicatorView alloc] init];
        [_netIndicatorView setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
        [self.view addSubview:_netIndicatorView];
        [_netIndicatorView hide];
    }
    [self.view bringSubviewToFront:_netIndicatorView];
    return _netIndicatorView;
}

- (BadNetTipView *)badNetTipV {
    if (!_badNetTipV) {
        __weak __typeof(self)weakSelf = self;
        _badNetTipV = [[BadNetTipView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight) withRetryEvent:^(UIButton *sender){
            [weakSelf requestMainInfo];
        }];
        [self.view addSubview:_badNetTipV];
        [_badNetTipV hide];
    }
    [self.view bringSubviewToFront:_badNetTipV];
    return _badNetTipV;
}

- (NoDataTipView *)noDataTipV {
    if (!_noDataTipV) {
        _noDataTipV = [[NoDataTipView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight)];
        [self.view addSubview:_noDataTipV];
        [_noDataTipV hide];
    }
    [self.view bringSubviewToFront:_noDataTipV];
    return _noDataTipV;
}

- (void)requestMainInfo {

}


- (void)backToPreVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
