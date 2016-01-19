//
//  DDRemoteSearchBar.h
//  QiuPai
//
//  Created by bigqiang on 15/11/27.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDRemoteSearchBar;

@protocol DDRemoteSearchBarDelegate <NSObject, UISearchBarDelegate>

- (void)remoteSearchBar:(DDRemoteSearchBar *)searchBar textDidChange:(NSString *)searchText;

@end

@interface DDRemoteSearchBar : UISearchBar
// time to wait in seconds before calling the delegate with the text changed
// default: 0.5 seconds
@property (nonatomic, assign) NSTimeInterval timeToWait;
@end
