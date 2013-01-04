//
//  AIReleaseToRefreshView.h
//  AIReleaseToRefreshWrapper
//
//  Created by CocoaToucher on 1/4/13.
//  Copyright (c) 2013 CocoaToucher. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Types for different release to refresh view states
 */
typedef NS_ENUM(NSInteger, AIReleaseToRefreshViewState) {
	/**
	 Indicates normal state of the view
	 */
    AIReleaseToRefreshViewStateDefault,
	/**
	 Indicates view is ready to be released for refreshing
	 */
    AIReleaseToRefreshViewStateReady,
	/**
	 Indicates view is currently in refreshing state
	 */
    AIReleaseToRefreshViewStateRefreshing
};

@protocol AIReleaseToRefreshView <NSObject>

/**
 Implement this property in your release to refresh view to change its appearance for different refresh cases
 */
@property(nonatomic, assign) AIReleaseToRefreshViewState state;

@optional
/**
 Implement this property to be able make scroll-progress dependent animations in your release to refresh view
 An example to this would be a spinning wheel which is rotated according to current scroll position of the scroll view
 */
@property(nonatomic, assign) double readyProgress;

@end
