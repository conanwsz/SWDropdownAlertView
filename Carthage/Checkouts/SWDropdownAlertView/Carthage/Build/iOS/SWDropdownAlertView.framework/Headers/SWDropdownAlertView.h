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

/**
 *  建立一个Dropdown alert view
 *
 *  @param message alert的具体内容
 *  @param type    alert的类型。类型有三种，“完成”，“警告”，“错误”。
 *
 *  @return SWDropdownAlertView
 */
+ (SWDropdownAlertView*)alertViewWithMessage:(NSString*)message withType:(SWDropdownAlertViewType)type;


- (void)show;
- (void)showWithCompletion:(SWDropdownAlertViewCompletion)completion;
- (void)showWithDuration:(CGFloat)duration;
- (void)showWithCompletion:(SWDropdownAlertViewCompletion)completion withDuration:(CGFloat)duration;

@end
