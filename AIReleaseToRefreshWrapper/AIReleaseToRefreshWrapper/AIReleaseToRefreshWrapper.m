//
//  AIReleaseToRefreshWrapper.m
//  AIReleaseToRefreshWrapper
//
//  Created by CocoaToucher on 1/4/13.
//  Copyright (c) 2013 CocoaToucher. All rights reserved.
//

#import "AIReleaseToRefreshWrapper.h"
#import "AIReleaseToRefreshView.h"


@interface AIReleaseToRefreshWrapper ()

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView<AIReleaseToRefreshView> *releaseToRefreshView;
@property(nonatomic, assign) AIReleaseToRefreshViewState refreshState;

@end

@implementation AIReleaseToRefreshWrapper

- (id)initWithScrollView:(UIScrollView *)scrollView refreshView:(UIView<AIReleaseToRefreshView> *)inView {
	self = [super init];
	if (self) {
#if !(__has_feature(objc_arc))
		_scrollView = [scrollView retain];
		_releaseToRefreshView = [inView retain];
#else
		_scrollView = scrollView;
		_releaseToRefreshView = inView;
#endif
		
		CGRect rect = _releaseToRefreshView.frame;
		rect.origin.y = -rect.size.height;
		[_releaseToRefreshView setFrame:rect];
		[_scrollView addSubview:_releaseToRefreshView];
		
		_refreshState = -1;
		
		[self onContentOffsetChange];
		
		[_scrollView addObserver:self
					  forKeyPath:@"contentOffset"
						 options:NSKeyValueObservingOptionNew
						 context:nil];
	}
	return self;
}

- (void)dealloc {
	[_scrollView removeObserver:self
					 forKeyPath:@"contentOffset"];
#if !(__has_feature(objc_arc))
	[_scrollView release];
	_scrollView = nil;
	[_releaseToRefreshView release];
	_releaseToRefreshView = nil;
	
	[super dealloc];
#endif
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	
	[self onContentOffsetChange];
}

- (void)onContentOffsetChange {
	if (self.releaseToRefreshView.isHidden ||
		self.releaseToRefreshView == nil)
		return;
	
	double readyProgress = 0.0;
	
	if (self.scrollView.contentOffset.y <= 0) {
		
		UIEdgeInsets insets = self.scrollView.scrollIndicatorInsets;
		insets.top = - self.scrollView.contentOffset.y;
		
		self.scrollView.scrollIndicatorInsets = insets;
		
		readyProgress = MIN((insets.top / self.releaseToRefreshView.frame.size.height), 1.0);
		
	} else {
		
		UIEdgeInsets insets = self.scrollView.scrollIndicatorInsets;
		insets.top = 0.0f;
		
		self.scrollView.scrollIndicatorInsets = insets;
		
		readyProgress = 0.0;
	}
	
	if (!self.isRefreshing) {
		
		if (self.scrollView.isDragging) { //did scroll
			
			if (self.scrollView.contentOffset.y <= self.releaseToRefreshView.frame.origin.y) {
				
				self.refreshState = AIReleaseToRefreshViewStateReady;
			} else {
				
				self.refreshState = AIReleaseToRefreshViewStateDefault;
				
				if ([self.releaseToRefreshView respondsToSelector:@selector(setReadyProgress:)]) {
					[self.releaseToRefreshView setReadyProgress:readyProgress];
				}
			}
			
		}
	}
}

- (void)scrollViewDidEndDragging {
	if (self.isRefreshing)
		return;
	
	if (!self.scrollView.isDragging) {
		
		if (self.scrollView.contentOffset.y <= self.releaseToRefreshView.frame.origin.y) {
			
			self.refreshState = AIReleaseToRefreshViewStateRefreshing;
			
			[UIView animateWithDuration:0.3
							 animations:^(void){
								 UIEdgeInsets insets = self.scrollView.contentInset;
								 insets.top = - self.releaseToRefreshView.frame.origin.y;
								 
								 self.scrollView.contentInset = insets;
							 }];
			
			[self.delegate releaseToRefreshWrapperDidBeginRefreshing:self];
		}
		
	}
}

- (void)setIsRefreshing:(BOOL)isRefreshing {
	[self setIsRefreshing:isRefreshing animated:NO];
}

- (void)setIsRefreshing:(BOOL)isRefreshing animated:(BOOL)animated {
	if (_isRefreshing == isRefreshing)
		return;
	
	_isRefreshing = isRefreshing;
	
	if (_isRefreshing) {
		self.refreshState = AIReleaseToRefreshViewStateRefreshing;
		
		UIEdgeInsets insets = self.scrollView.contentInset;
		insets.top = - self.releaseToRefreshView.frame.origin.y;
		
		CGPoint offset = CGPointMake(0.0f, self.releaseToRefreshView.frame.origin.y);
		
		if (animated) {
			[UIView animateWithDuration:0.3
							 animations:^(void){
								 
								 self.scrollView.contentInset = insets;
								 self.scrollView.contentOffset = offset;
								 
							 }];
		} else {
			
			self.scrollView.contentInset = insets;
			self.scrollView.contentOffset = offset;
		}
		
	} else {
		
		UIEdgeInsets insets = self.scrollView.contentInset;
		insets.top = 0.0f;
		
		if (animated) {
			[UIView animateWithDuration:0.3
							 animations:^(void){
								 
								 self.scrollView.contentInset = insets;
								 
							 }];
		} else {
			
			self.scrollView.contentInset = insets;
			
		}
		
	}
}

- (void)setRefreshState:(AIReleaseToRefreshViewState)refreshState {
	BOOL updateView = _refreshState != refreshState;
	
	_refreshState = refreshState;
	
	if (_refreshState == AIReleaseToRefreshViewStateRefreshing)
		_isRefreshing = YES;
	else _isRefreshing = NO;
	
	if (updateView && self.releaseToRefreshView != nil) {
		
		[self.releaseToRefreshView setState:refreshState];
		
		if (refreshState == AIReleaseToRefreshViewStateReady ||
			refreshState == AIReleaseToRefreshViewStateRefreshing) {
			
			if ([self.releaseToRefreshView respondsToSelector:@selector(setReadyProgress:)]) {
				
				[self.releaseToRefreshView setReadyProgress:1.0];
				
			}
		}
	}
}

@end
