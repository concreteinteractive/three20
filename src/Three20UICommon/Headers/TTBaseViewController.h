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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


// CIParentViewController is an abstract controller class that supports controller
// nesting.  Such nesting is newly available in iOS5 but is not backwards compatible
// so we implement it here.


// We would like to dynamically measure these constants, using defines for now.

#define LANDSCAPE_MAIN_WINDOW_WIDTH 845
#define LANDSCAPE_MAIN_WINDOW_HEIGHT 655
#define PORTRAIT_MAIN_WINDOW_WIDTH 599
#define PORTRAIT_MAIN_WINDOW_HEIGHT 911
#define GENRE_RADIO_BUTTON_WIDTH 160


@interface CIParentViewController : UIViewController {
    NSMutableArray *_childViewControllers;
}
- (void)layoutSubviewsForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (CGRect) contentPaneFrameForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@property (nonatomic, retain, readonly) NSMutableArray *childViewControllers;

@end


/**
 * A view controller with some useful additions.
 */
@interface TTBaseViewController : CIParentViewController {
@protected
  NSDictionary*     _frozenState;
  UIBarStyle        _navigationBarStyle;
  UIColor*          _navigationBarTintColor;
  UIStatusBarStyle  _statusBarStyle;

  BOOL _isViewAppearing;
  BOOL _hasViewAppeared;
  BOOL _autoresizesForKeyboard;
}

/**
 * The style of the navigation bar when this view controller is pushed onto
 * a navigation controller.
 *
 * @default UIBarStyleDefault
 */
@property (nonatomic) UIBarStyle navigationBarStyle;

/**
 * The color of the navigation bar when this view controller is pushed onto
 * a navigation controller.
 *
 * @default TTSTYLEVAR(navigationBarTintColor)
 */
@property (nonatomic, retain) UIColor* navigationBarTintColor;

/**
 * The style of the status bar when this view controller is appearing.
 *
 * @default [[UIApplication sharedApplication] statusBarStyle] via app's info.plist
 *
 */
@property (nonatomic) UIStatusBarStyle statusBarStyle;

/**
 * The view has appeared at least once and hasn't been removed due to a memory warning.
 */
@property (nonatomic, readonly) BOOL hasViewAppeared;

/**
 * The view is about to appear and has not appeared yet.
 */
@property (nonatomic, readonly) BOOL isViewAppearing;

/**
 * Determines if the view will be resized automatically to fit the keyboard.
 */
@property (nonatomic) BOOL autoresizesForKeyboard;


/**
 * Sent to the controller before the keyboard slides in.
 */
- (void)keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds;

/**
 * Sent to the controller before the keyboard slides out.
 */
- (void)keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds;

/**
 * Sent to the controller after the keyboard has slid in.
 */
- (void)keyboardDidAppear:(BOOL)animated withBounds:(CGRect)bounds;

/**
 * Sent to the controller after the keyboard has slid out.
 */
- (void)keyboardDidDisappear:(BOOL)animated withBounds:(CGRect)bounds;


@end
