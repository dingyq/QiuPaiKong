//
//  DDRemoteSearchBar.m
//  QiuPai
//
//  Created by bigqiang on 15/11/27.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "DDRemoteSearchBar.h"

@interface DDRemoteSearchBar () <UISearchBarDelegate>

@property (strong, nonatomic) NSTimer *searchTimer;
@property (strong, nonatomic) id <DDRemoteSearchBarDelegate> remoteSearchDelegate;

@end

@implementation DDRemoteSearchBar

- (void)setDelegate:(id <DDRemoteSearchBarDelegate, UISearchBarDelegate>)delegate {
    [super setDelegate:self];
    self.remoteSearchDelegate = delegate;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // forward method call to delegate
    if ([self.remoteSearchDelegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
        [self.remoteSearchDelegate searchBar:searchBar textDidChange:searchText];
    }
    if (self.searchTimer) {
        [self.searchTimer invalidate];
    }
    self.searchTimer = nil;
    self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeToWait target:self selector:@selector(fireSearch:) userInfo:nil repeats:NO];
}

- (void)fireSearch:(DDRemoteSearchBar *)remoteSearchBar {
    if (self.remoteSearchDelegate &&
        [self.remoteSearchDelegate respondsToSelector:@selector(remoteSearchBar:textDidChange:)]) {
        [self.remoteSearchDelegate remoteSearchBar:self textDidChange:self.text];
    }
}

- (NSTimeInterval)timeToWait {
    if (_timeToWait == 0) {
        double timeToWait = 0.5;
        _timeToWait = timeToWait;
    }
    return (_timeToWait);
}


#pragma mark - UISearchBarDelegate forwarding
- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.remoteSearchDelegate respondsToSelector:aSelector]) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}


- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.remoteSearchDelegate respondsToSelector:aSelector]) {
        return self.remoteSearchDelegate;
    }
    return [super forwardingTargetForSelector:aSelector];
}

@end
