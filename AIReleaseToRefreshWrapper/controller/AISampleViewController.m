//
//  AISampleViewController.m
//  AIReleaseToRefreshWrapper
//
//  Created by CocoaToucher on 1/4/13.
//  Copyright (c) 2013 CocoaToucher. All rights reserved.
//

#import "AISampleViewController.h"
#import "AIReleaseToRefreshWrapper.h"
#import "AISampleReleaseToRefreshView.h"

@interface AISampleViewController () < UIScrollViewDelegate, AIReleaseToRefreshWrapperDelegate >

@property(nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property(nonatomic, strong) AIReleaseToRefreshWrapper *rtrWrapper;
@property(nonatomic, strong) IBOutlet UIButton *reloadButton;

- (IBAction)onReload:(id)sender;

@end

@implementation AISampleViewController

- (void)dealloc {
#if !(__has_feature(objc_arc))
	[_scrollView release];
	_scrollView = nil;
	[_rtrWrapper release];
	_rtrWrapper = nil;
	[_reloadButton release];
	_reloadButton = nil;
	
	[super dealloc];
#endif
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, 640.0f);
	
	AISampleReleaseToRefreshView *rrView = [[AISampleReleaseToRefreshView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 70.0f)];
	
	AIReleaseToRefreshWrapper *tWrapper = [[AIReleaseToRefreshWrapper alloc] initWithScrollView:self.scrollView
																					refreshView:rrView];
	self.rtrWrapper = tWrapper;
#if !(__has_feature(objc_arc))
	[rrView release];
	[tWrapper release];
#endif
	self.rtrWrapper.delegate = self;
	
	[self refreshReloadButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[self.rtrWrapper scrollViewDidEndDragging];
}

- (IBAction)onReload:(id)sender {
	[self.rtrWrapper setIsRefreshing:!self.rtrWrapper.isRefreshing
							animated:YES];
	
	[self refreshReloadButton];
}

- (void)refreshReloadButton {
	if (self.rtrWrapper.isRefreshing) {
		[self.reloadButton setTitle:NSLocalizedString(@"Finish", nil)
						   forState:UIControlStateNormal];
	} else {
		[self.reloadButton setTitle:NSLocalizedString(@"Reload", nil)
						   forState:UIControlStateNormal];
	}
}

- (void)releaseToRefreshWrapperDidBeginRefreshing:(AIReleaseToRefreshWrapper *)wrapper {
	[self refreshReloadButton];
}

@end
