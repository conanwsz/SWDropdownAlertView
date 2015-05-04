//
//  SWDropdownAlertView.h
//  SWDropdownAlertView
//
//  Created by 汪顺舟 on 3/11/15.
//  Copyright (c) 2015 HXQC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SWDropdownAlertViewType) {
    SWDropdownAlertViewTypeDone = 0,
    SWDropdownAlertViewTypeWarning,
    SWDropdownAlertViewTypeError,
};

typedef void (^SWDropdownAlertViewCompletion)(SWDropdownAlertViewType type);

@interface SWDropdownAlertView : UIView
+ (SWDropdownAlertView*)alertViewWithMessage:(NSString*)message withType:(SWDropdownAlertViewType)type;


- (void)show;
- (void)showWithCompletion:(SWDropdownAlertViewCompletion)completion;
- (void)showWithDuration:(CGFloat)duration;
- (void)showWithCompletion:(SWDropdownAlertViewCompletion)completion withDuration:(CGFloat)duration;


- (void)dismiss;
- (void)dismissWithCompletion:(SWDropdownAlertViewCompletion)completion;
@end
