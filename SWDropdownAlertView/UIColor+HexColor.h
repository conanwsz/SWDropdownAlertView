//
//  UIColor+HexColor.h
//  SWDropdownAlertView
//
//  Created by 汪顺舟 on 3/11/15.
//  Copyright (c) 2015 HXQC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)
+ (UIColor *) colorWithHexString:(NSString *)hex;
+ (UIColor *) colorWithHexValue: (NSInteger) hex;
@end
