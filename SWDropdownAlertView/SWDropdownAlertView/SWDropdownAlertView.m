//
//  SWDropdownAlertView.m
//  SWDropdownAlertView
//
//  Created by 汪顺舟 on 3/11/15.
//  Copyright (c) 2015 HXQC. All rights reserved.
//


#import "UIColor+HexColor.h"
#import "SWDropdownAlertView.h"
@interface SWDropdownAlertView()<UIDynamicAnimatorDelegate,UICollisionBehaviorDelegate>
{
    NSArray *_settings;
    UIDynamicAnimator *_animator;
}

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
//@property (assign, nonatomic) CGFloat duration;
@property (assign, nonatomic) SWDropdownAlertViewType alertViewType;

@end

static NSString *kSWDropdownAlertViewIconImage = @"image";
static NSString *kSWDropdownAlertViewBackgroundColor = @"background";

@implementation SWDropdownAlertView

+ (SWDropdownAlertView*)alertViewWithMessage:(NSString*)message withType:(SWDropdownAlertViewType)type{
    SWDropdownAlertView *alertView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] objectAtIndex:0];
    
    [alertView alertViewWithMessage:message withType:type];
    
    return alertView;
}


- (void)alertViewWithMessage:(NSString*)message withType:(SWDropdownAlertViewType)type{
    _settings = @[@{kSWDropdownAlertViewIconImage : @"IconSuccess",
                    kSWDropdownAlertViewBackgroundColor : @"#17a05e"},
                  @{kSWDropdownAlertViewIconImage : @"IconInfo",
                    kSWDropdownAlertViewBackgroundColor : @"#ff6d00"},
                  @{kSWDropdownAlertViewIconImage : @"IconWarning",
                    kSWDropdownAlertViewBackgroundColor : @"#ff3d00"},
                ];
    self.alertViewType = type;

    CGRect frame = self.frame;
    frame.size.width = [UIScreen mainScreen].bounds.size.width + 1;
    frame.size.height = 64;
    frame.origin.x = -1;
    self.frame = frame;
    
    NSDictionary *setting = _settings[type];
    self.messageLabel.text = message;
    self.iconImageView.image = [UIImage imageNamed:setting[kSWDropdownAlertViewIconImage]];
    self.backgroundColor = [UIColor colorWithHexString:setting[kSWDropdownAlertViewBackgroundColor]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

- (void)show {
    [self showWithCompletion:nil];
}

- (void)showWithCompletion:(SWDropdownAlertViewCompletion)completion {
    [self showWithCompletion:completion withDuration:0];
}

- (void)showWithDuration:(CGFloat)duration{
    [self showWithCompletion:nil withDuration:duration];
}

- (void)showWithCompletion:(SWDropdownAlertViewCompletion)completion withDuration:(CGFloat)duration{
    if (duration < 0) {
        duration = 0;
    }
//    self.duration = duration;
    
    CGRect frame = self.frame;
    frame.origin.y -= frame.size.height;
    self.frame = frame;
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
//    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
//        UIVisualEffect *visualEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:visualEffect];
//        blurView.frame = self.bounds;
//        [self insertSubview:blurView atIndex:0];
//    }
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView: keyWindow];
    [keyWindow setWindowLevel:UIWindowLevelStatusBar + 1];

    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self]];
    [_animator addBehavior:gravity];
    
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self]];
    collision.translatesReferenceBoundsIntoBoundary = NO;
    [collision addBoundaryWithIdentifier:@"notificationEnd" fromPoint:CGPointMake(0, 65) toPoint:CGPointMake([[UIScreen mainScreen] bounds].size.width, 65)];
    [_animator addBehavior:collision];
    
    UIDynamicItemBehavior *elasticityBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self]];
    elasticityBehavior.elasticity = 0.35f;
    [_animator addBehavior:elasticityBehavior];
    
    __weak SWDropdownAlertView *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (completion) {
            completion(_alertViewType);
        }

        if (duration > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf dismiss];
            });
        }
    });
}

- (void)dismiss {
    [self dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(SWDropdownAlertViewCompletion)completion{
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self]];
    gravity.gravityDirection = CGVectorMake(0, -1.5);
    [_animator addBehavior:gravity];
    
    __weak SWDropdownAlertView *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [_animator removeAllBehaviors];
        [weakSelf removeFromSuperview];
        
        BOOL hasSWDropdownAlertView = NO;
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        for (UIView *view in keyWindow.subviews) {
            if ([view isKindOfClass:[SWDropdownAlertView class]]) {
                hasSWDropdownAlertView = YES;
            }
        }
        
        if (!hasSWDropdownAlertView) {
            [keyWindow setWindowLevel:UIWindowLevelNormal];
        }
        
        if (completion) {
            completion(_alertViewType);
        }
    });
}


@end
