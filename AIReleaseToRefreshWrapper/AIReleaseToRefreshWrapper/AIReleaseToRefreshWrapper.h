//
//  AIReleaseToRefreshWrapper.h
//  AIReleaseToRefreshWrapper
//
//  Created by CocoaToucher on 1/4/13.
//  Copyright (c) 2013 CocoaToucher. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AIReleaseToRefreshWrapperDelegate;
@protocol AIReleaseToRefreshView;

/**
 Release to refresh wrapper class for adding any custom release to refresh view to any scroll view
 */
@interface AIReleaseToRefreshWrapper : NSObject

/**
 @param scrollView, can be any UIScrollView subclass like UITableView
 @param inView, should conform to AIReleaseToRefreshView
 */
- (id)initWithScrollView:(UIScrollView *)scrollView
			 refreshView:(UIView<AIReleaseToRefreshView> *)inView;

@property(nonatomic, assign) id<AIReleaseToRefreshWrapperDelegate> delegate;
/**
 Indicates or sets whether release to refresh view is visible
 */
@property(nonatomic, assign) BOOL isRefreshing;

/**
 @param isRefreshing, YES if you want to make release to refresh view visible and refreshing state, NO otherwise
 @param animated, YES if release to refresh view should become visible or hidden with animation, NO otherwise
 */
- (void)setIsRefreshing:(BOOL)isRefreshing animated:(BOOL)animated;

/**
 Call this method in scroll view's scrollViewDidEndDragging:willDecelerate: method
 Then wrapper decides whether to switch to refreshing state or not
 */
- (void)scrollViewDidEndDragging;

@end

@protocol AIReleaseToRefreshWrapperDelegate <NSObject>

/**
 Informs delegate that scroll view is refreshing after a user interaction
 */
- (void)releaseToRefreshWrapperDidBeginRefreshing:(AIReleaseToRefreshWrapper *)wrapper;

@end
