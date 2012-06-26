//
// Copyright 2009-2011 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "Three20UICommon/TTBaseViewController.h"

// UICommon
#import "Three20UICommon/TTGlobalUICommon.h"
#import "Three20UICommon/UIViewControllerAdditions.h"

// UICommon (Private)
#import "Three20UICommon/private/UIViewControllerGarbageCollection.h"

// Core
#import "Three20Core/TTCorePreprocessorMacros.h"
#import "Three20Core/TTDebug.h"
#import "Three20Core/TTDebugFlags.h"


// CIParentViewController is an abstract controller class that supports controller
// nesting.  Such nesting is newly available in iOS5 but is not backwards compatible
// so we implement it here.

@interface CIParentViewController()
@property (nonatomic, retain) NSMutableArray *childViewControllers;
@end

@implementation CIParentViewController

@synthesize childViewControllers = _childViewControllers;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nil bundle:nil])) {
    }
    return self;
}

#pragma mark -
#pragma mark View management

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    for (UIViewController *viewController in _childViewControllers) {
        [viewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    for (UIViewController *viewController in _childViewControllers) {
        [viewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
										 duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self layoutSubviewsForInterfaceOrientation:toInterfaceOrientation];
    for (UIViewController *viewController in _childViewControllers) {
        [viewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation
                                                         duration:duration];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)willAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                                    duration:(NSTimeInterval)duration
{
    [super willAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation
                                                       duration:duration];
    for (UIViewController *viewController in _childViewControllers) {
        [viewController willAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation
                                                                    duration:duration];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [super didAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation];
    for (UIViewController *viewController in _childViewControllers) {
        [viewController didAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
                                                       duration:(NSTimeInterval)duration
{
    [super willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation
                                                          duration:duration];
    for (UIViewController *viewController in _childViewControllers) {
        [viewController willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation
                                                                       duration:duration];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    for (UIViewController *viewController in _childViewControllers) {
        [viewController viewWillAppear:animated];
    }
    [self layoutSubviewsForInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviewsForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    for (UIViewController *viewController in _childViewControllers) {
        if ([viewController respondsToSelector:@selector(layoutSubviewsForInterfaceOrientation:)]) {
            [(CIParentViewController *)viewController layoutSubviewsForInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    for (UIViewController *viewController in _childViewControllers) {
        [viewController viewDidAppear:animated];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    for (UIViewController *viewController in _childViewControllers) {
        [viewController viewWillDisappear:animated];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    for (UIViewController *viewController in _childViewControllers) {
        [viewController viewDidDisappear:animated];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(CGRect) contentPaneFrameForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        return CGRectMake(0, 0, LANDSCAPE_MAIN_WINDOW_WIDTH, LANDSCAPE_MAIN_WINDOW_HEIGHT);
    }
    else {
        return CGRectMake(0, 0, PORTRAIT_MAIN_WINDOW_WIDTH, PORTRAIT_MAIN_WINDOW_HEIGHT);
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)loadView {
    [super loadView];
    self.childViewControllers = [[[NSMutableArray alloc] init] autorelease];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) viewDidUnload {
    self.childViewControllers = nil;
    [super viewDidUnload];
}

@end


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTBaseViewController

@synthesize navigationBarStyle      = _navigationBarStyle;
@synthesize navigationBarTintColor  = _navigationBarTintColor;
@synthesize statusBarStyle          = _statusBarStyle;
@synthesize isViewAppearing         = _isViewAppearing;
@synthesize hasViewAppeared         = _hasViewAppeared;
@synthesize autoresizesForKeyboard  = _autoresizesForKeyboard;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _navigationBarStyle = UIBarStyleDefault;
    _statusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
  }

  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
	self = [self initWithNibName:nil bundle:nil];
  if (self) {
  }

  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  TTDCONDITIONLOG(TTDFLAG_VIEWCONTROLLERS, @"DEALLOC %@", self);

  [self unsetCommonProperties];

  TT_RELEASE_SAFELY(_navigationBarTintColor);
  TT_RELEASE_SAFELY(_frozenState);

  // Removes keyboard notification observers for
  self.autoresizesForKeyboard = NO;

  // You would think UIViewController would call this in dealloc, but it doesn't!
  // I would prefer not to have to redundantly put all view releases in dealloc and
  // viewDidUnload, so my solution is just to call viewDidUnload here.
  [self viewDidUnload];

  [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)resizeForKeyboard:(NSNotification*)notification appearing:(BOOL)appearing {
	CGRect keyboardBounds;
	[[notification.userInfo objectForKey:UIKeyboardBoundsUserInfoKey] getValue:&keyboardBounds];

	CGPoint keyboardStart;
	[[notification.userInfo objectForKey:UIKeyboardCenterBeginUserInfoKey] getValue:&keyboardStart];

	CGPoint keyboardEnd;
	[[notification.userInfo objectForKey:UIKeyboardCenterEndUserInfoKey] getValue:&keyboardEnd];

	BOOL animated = keyboardStart.y != keyboardEnd.y;
  if (animated) {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:TT_TRANSITION_DURATION];
  }

  if (appearing) {
    [self keyboardWillAppear:animated withBounds:keyboardBounds];

  } else {
    [self keyboardDidDisappear:animated withBounds:keyboardBounds];
  }

  if (animated) {
    [UIView commitAnimations];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIViewController (TTCategory)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDictionary*)frozenState {
  return _frozenState;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setFrozenState:(NSDictionary*)frozenState {
  [_frozenState release];
  _frozenState = [frozenState retain];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIViewController


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  _isViewAppearing = YES;
  _hasViewAppeared = YES;

  if (!self.popupViewController) {
    UINavigationBar* bar = self.navigationController.navigationBar;
    bar.tintColor = _navigationBarTintColor;
    bar.barStyle = _navigationBarStyle;

    if (!TTIsPad()) {
      [[UIApplication sharedApplication] setStatusBarStyle:_statusBarStyle animated:YES];
    }
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];

  _isViewAppearing = NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning {
  TTDCONDITIONLOG(TTDFLAG_VIEWCONTROLLERS, @"MEMORY WARNING FOR %@", self);

  if (_hasViewAppeared && !_isViewAppearing) {
    NSMutableDictionary* state = [[NSMutableDictionary alloc] init];
    [self persistView:state];
    self.frozenState = state;
    TT_RELEASE_SAFELY(state);

    // This will come around to calling viewDidUnload
    [super didReceiveMemoryWarning];

    _hasViewAppeared = NO;

  } else {
    [super didReceiveMemoryWarning];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  if (TTIsPad()) {
    return YES;

  } else {
    UIViewController* popup = [self popupViewController];
    if (popup) {
      return [popup shouldAutorotateToInterfaceOrientation:interfaceOrientation];

    } else {
      return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    }
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
  UIViewController* popup = [self popupViewController];

  if (popup) {
    return [popup willAnimateRotationToInterfaceOrientation: fromInterfaceOrientation
                                                   duration: duration];

  } else {
    return [super willAnimateRotationToInterfaceOrientation: fromInterfaceOrientation
                                                   duration: duration];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  UIViewController* popup = [self popupViewController];

  if (popup) {
    return [popup didRotateFromInterfaceOrientation:fromInterfaceOrientation];

  } else {
    return [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)rotatingHeaderView {
  UIViewController* popup = [self popupViewController];

  if (popup) {
    return [popup rotatingHeaderView];

  } else {
    return [super rotatingHeaderView];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)rotatingFooterView {
  UIViewController* popup = [self popupViewController];

  if (popup) {
    return [popup rotatingFooterView];

  } else {
    return [super rotatingFooterView];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIKeyboardNotifications


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardWillShow:(NSNotification*)notification {
  if (self.isViewAppearing) {
    [self resizeForKeyboard:notification appearing:YES];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardDidShow:(NSNotification*)notification {
#ifdef __IPHONE_3_21
  CGRect frameStart;
  [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&frameStart];

  CGRect keyboardBounds = CGRectMake(0, 0, frameStart.size.width, frameStart.size.height);
#else
  CGRect keyboardBounds;
  [[notification.userInfo objectForKey:UIKeyboardBoundsUserInfoKey] getValue:&keyboardBounds];
#endif

  [self keyboardDidAppear:YES withBounds:keyboardBounds];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardDidHide:(NSNotification*)notification {
  if (self.isViewAppearing) {
    [self resizeForKeyboard:notification appearing:NO];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardWillHide:(NSNotification*)notification {
#ifdef __IPHONE_3_21
  CGRect frameEnd;
  [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&frameEnd];

  CGRect keyboardBounds = CGRectMake(0, 0, frameEnd.size.width, frameEnd.size.height);
#else
  CGRect keyboardBounds;
  [[notification.userInfo objectForKey:UIKeyboardBoundsUserInfoKey] getValue:&keyboardBounds];
#endif

  [self keyboardWillDisappear:YES withBounds:keyboardBounds];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setAutoresizesForKeyboard:(BOOL)autoresizesForKeyboard {
  if (autoresizesForKeyboard != _autoresizesForKeyboard) {
    _autoresizesForKeyboard = autoresizesForKeyboard;

    if (_autoresizesForKeyboard) {
      [[NSNotificationCenter defaultCenter] addObserver: self
                                               selector: @selector(keyboardWillShow:)
                                                   name: UIKeyboardWillShowNotification
                                                 object: nil];
      [[NSNotificationCenter defaultCenter] addObserver: self
                                               selector: @selector(keyboardWillHide:)
                                                   name: UIKeyboardWillHideNotification
                                                 object: nil];
      [[NSNotificationCenter defaultCenter] addObserver: self
                                               selector: @selector(keyboardDidShow:)
                                                   name: UIKeyboardDidShowNotification
                                                 object: nil];
      [[NSNotificationCenter defaultCenter] addObserver: self
                                               selector: @selector(keyboardDidHide:)
                                                   name: UIKeyboardDidHideNotification
                                                 object: nil];

    } else {
      [[NSNotificationCenter defaultCenter] removeObserver: self
                                                      name: UIKeyboardWillShowNotification
                                                    object: nil];
      [[NSNotificationCenter defaultCenter] removeObserver: self
                                                      name: UIKeyboardWillHideNotification
                                                    object: nil];
      [[NSNotificationCenter defaultCenter] removeObserver: self
                                                      name: UIKeyboardDidShowNotification
                                                    object: nil];
      [[NSNotificationCenter defaultCenter] removeObserver: self
                                                      name: UIKeyboardDidHideNotification
                                                    object: nil];
    }
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds {
  // Empty default implementation.
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds {
  // Empty default implementation.
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardDidAppear:(BOOL)animated withBounds:(CGRect)bounds {
  // Empty default implementation.
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardDidDisappear:(BOOL)animated withBounds:(CGRect)bounds {
  // Empty default implementation.
}


@end
