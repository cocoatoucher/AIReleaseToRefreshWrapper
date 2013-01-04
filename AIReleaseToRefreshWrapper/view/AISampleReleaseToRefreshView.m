//
//  AISampleReleaseToRefreshView.m
//  AIReleaseToRefreshWrapper
//
//  Created by CocoaToucher on 1/4/13.
//  Copyright (c) 2013 CocoaToucher. All rights reserved.
//

#import "AISampleReleaseToRefreshView.h"

@interface AISampleReleaseToRefreshView ()

@property(nonatomic, strong) UIActivityIndicatorView *activityView;
@property(nonatomic, strong) UILabel *statusLabel;
@property(nonatomic, strong) UIProgressView *progressView;

@end

@implementation AISampleReleaseToRefreshView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_activityView.hidesWhenStopped = YES;
		[self addSubview:_activityView];
		
		_statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, 20.0f, 200.0f, 30.0f)];
		_statusLabel.backgroundColor = [UIColor clearColor];
		_statusLabel.textColor = [UIColor blackColor];
		_statusLabel.font = [UIFont boldSystemFontOfSize:16.0f];
		[self addSubview:_statusLabel];
		
		_progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
		CGRect rect = _progressView.frame;
		rect.origin.x = 10.0f;
		rect.origin.y = self.bounds.size.height - rect.size.height - 10.0f;
		rect.size.width = self.bounds.size.width - 20.0f;
		_progressView.frame = rect;
		[self addSubview:_progressView];
	}
	return self;
}

- (void)dealloc {
#if !(__has_feature(objc_arc))
	[_activityView release];
	_activityView = nil;
	[_statusLabel release];
	_statusLabel = nil;
	[_progressView release];
	_progressView = nil;
	
	[super dealloc];
#endif
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGRect activityRect = self.activityView.frame;
	activityRect.origin.x = 10.0f;
	activityRect.origin.y = floorf((self.bounds.size.height - activityRect.size.height) / 2.0f);
	self.activityView.frame = activityRect;
}

- (void)setState:(AIReleaseToRefreshViewState)state {
	_state = state;
	
	switch (_state) {
		case AIReleaseToRefreshViewStateDefault:
			self.statusLabel.text = NSLocalizedString(@"Pull down to refresh", nil);
			self.backgroundColor = [UIColor redColor];
			[self.activityView stopAnimating];
			break;
		case AIReleaseToRefreshViewStateReady:
			self.statusLabel.text = NSLocalizedString(@"Release to refresh", nil);
			self.backgroundColor = [UIColor yellowColor];
			[self.activityView stopAnimating];
			break;
		case AIReleaseToRefreshViewStateRefreshing:
			self.statusLabel.text = NSLocalizedString(@"Reloading", nil);
			self.backgroundColor = [UIColor greenColor];
			[self.activityView startAnimating];
			break;
	}
}

- (void)setReadyProgress:(double)readyProgress {
	_readyProgress = readyProgress;
	
	self.progressView.progress = (float)readyProgress;
}

@end
