//
//  AISampleReleaseToRefreshView.h
//  AIReleaseToRefreshWrapper
//
//  Created by CocoaToucher on 1/4/13.
//  Copyright (c) 2013 CocoaToucher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AIReleaseToRefreshView.h"

@interface AISampleReleaseToRefreshView : UIView < AIReleaseToRefreshView >

@property(nonatomic, assign) AIReleaseToRefreshViewState state;
@property(nonatomic, assign) double readyProgress;

@end
