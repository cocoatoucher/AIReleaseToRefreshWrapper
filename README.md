#AIReleaseToRefreshWrapper

a wrapper class for adding and managing release to refresh to any scroll view in iOS

#Requirements

Classes in this project supports both ARC and non-ARC projects

#Installation

Add the AIRelaseToRefreshWrapper folder to your project

#How to use it?

##AIRelaseToRefreshWrapper

    #import "AIRelaseToRefreshWrapper.h"
    
    
    //create a AIRelaseToRefreshWrapper object and give it your scroll view and a custom release to refresh view
    //for correctly implementing a release to refresh view see below section
    AIRelaseToRefreshWrapper *wrapper = [[AIRelaseToRefreshWrapper alloc] initWithScrollView:self.scrollView
                                                                             	 refreshView:rrView];
    
    //make sure you set the delegate of your scroll view
    self.scrollView.delegate = self;
    
    //optional: you can set your class as a delegate to your AIRelaseToRefreshWrapper instance 
    // to be informed after user interaction triggers refreshing
    wrapper.delegate = self;
    
    //in scroll view's delegate method make sure to call your AIRelaseToRefreshWrapper's scrollViewDidEndDragging method
    - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
        [self.wrapper scrollViewDidEndDragging];
    }
    
##AIReleaseToRefreshView Protocol

You can make any of your UIView subclass to be a release to refresh view within your scroll view by making it conform to this protocol
There is an "AISampleReleaseToRefreshView" sample class in the project at which you can have a look
    
    //Implement this property in your release to refresh view to change its appearance for different refresh cases
    @property(nonatomic, assign) AIReleaseToRefreshViewState state;
    
    @optional
    //Implement this property to be able make scroll-progress dependent animations in your release to refresh view
    //An example to this would be a spinning wheel which is rotated according to current scroll position of the scroll view
    @property(nonatomic, assign) double readyProgress;
    
