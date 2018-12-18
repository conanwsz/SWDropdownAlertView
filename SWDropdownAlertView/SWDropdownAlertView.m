    //
    //  SWDropdownAlertView.m
    //  SWDropdownAlertView
    //
    //  Created by 汪顺舟 on 3/11/15.
    //  Copyright (c) 2015 HXQC. All rights reserved.
    //


#import "UIColor+HexColor.h"
#import "SWDropdownAlertView.h"
#import <Masonry/Masonry.h>

#define alertHeight [[UIApplication sharedApplication] statusBarFrame].size.height + 44

typedef NS_ENUM(NSUInteger, SWDropdownAlertViewAnimationDirection) {
    SWDropdownAlertViewAnimationDirectionDrop = 0,
    SWDropdownAlertViewAnimationDirectionBack,
};

@interface SWDropdownAlertView()<UIDynamicAnimatorDelegate,UICollisionBehaviorDelegate>
{
    NSArray *_settings;
    UIDynamicAnimator *_animator;
}

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *messageLabel;
@property (assign, nonatomic) SWDropdownAlertViewType alertViewType;
@property (assign, nonatomic) SWDropdownAlertViewAnimationDirection animationDirection;
@property (copy, nonatomic) SWDropdownAlertViewCompletion completionBlock;
@property (strong, nonatomic) UIView *maskView;
@property (assign, nonatomic) CGFloat duration;


@end

static NSString *kSWDropdownAlertViewIconImage = @"image";
static NSString *kSWDropdownAlertViewBackgroundColor = @"background";
static BOOL appeared = NO;

@implementation SWDropdownAlertView

+ (SWDropdownAlertView*)alertViewWithMessage:(NSString*)message withType:(SWDropdownAlertViewType)type{
    if (!message.length) {
        return nil;
    }
    if (appeared) {
        return nil;
    }
    
    SWDropdownAlertView *alertView = [[SWDropdownAlertView alloc] init];
    
    [alertView alertViewWithMessage:message withType:type];
    
    return alertView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UIImageView *iconImageView = [UIImageView new];
    [self addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UILabel *messageLabel = [UILabel new];
    [self addSubview:messageLabel];
    messageLabel.font = [UIFont boldSystemFontOfSize:14];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.numberOfLines = 0;
    self.messageLabel = messageLabel;
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.superview).offset(20);
        make.centerY.equalTo(self.iconImageView.superview);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(8);
        make.centerY.equalTo(self.iconImageView);
        make.right.equalTo(self.messageLabel.superview).offset(-20);
    }];
}

- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];
    NSLog(@"%f", self.safeAreaInsets.top);
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.superview).offset(20 + self.safeAreaInsets.left);
        make.centerY.equalTo(self.iconImageView.superview).offset((self.safeAreaInsets.left > 0) ? 0 :(self.safeAreaInsets.top - 20) / 2);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(8);
        make.centerY.equalTo(self.iconImageView);
        make.right.equalTo(self.messageLabel.superview).offset(-20 - self.safeAreaInsets.right);
    }];
}

- (void)alertViewWithMessage:(NSString*)message withType:(SWDropdownAlertViewType)type{
    _settings = @[@{kSWDropdownAlertViewIconImage : @"IconSuccess",
                    kSWDropdownAlertViewBackgroundColor : @"#17a05e"},
                  @{kSWDropdownAlertViewIconImage : @"IconWarning",
                    kSWDropdownAlertViewBackgroundColor : @"#ff6d00"},
                  @{kSWDropdownAlertViewIconImage : @"IconError",
                    kSWDropdownAlertViewBackgroundColor : @"#ff3d00"},
                  ];
    self.alertViewType = type;
    
    CGRect frame = self.frame;
    frame.size.width = [UIScreen mainScreen].bounds.size.width + 1;
    frame.size.height = alertHeight;
    frame.origin.x = -1;
    self.frame = frame;
    
    if (!message.length) {
        switch (type) {
            case SWDropdownAlertViewTypeDone:
                message = @"执行成功";
                break;
            case SWDropdownAlertViewTypeWarning:
                message = @"未知警告";
                break;
            case SWDropdownAlertViewTypeError:
                message = @"未知错误";
                break;
            default:
                break;
        }
    }
    
    NSDictionary *setting = _settings[type];
    self.messageLabel.text = message;
    self.iconImageView.image = [UIImage imageNamed:setting[kSWDropdownAlertViewIconImage] inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
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
    self.duration = duration;
    
    self.animationDirection = SWDropdownAlertViewAnimationDirectionDrop;
    if (_animator.isRunning) {
        [_animator removeAllBehaviors];
    }
    
    self.completionBlock = completion;
    
    CGRect frame = self.frame;
    frame.origin.y -= frame.size.height;
    self.frame = frame;
    
    UIWindow *keyWindow = [self keyWindow];
    if (!keyWindow) {
        return;
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewDidClicked:)];
    
    _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _maskView.alpha = 0;
    _maskView.backgroundColor = [UIColor blackColor];
    [_maskView addGestureRecognizer:tapGestureRecognizer];
    
    [keyWindow addSubview:_maskView];
    [keyWindow addSubview:self];
    appeared = YES;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        UIVisualEffect *visualEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:visualEffect];
        blurView.frame = self.bounds;
        [self insertSubview:blurView atIndex:0];
    }
    [UIView animateWithDuration:0.25 animations:^{
        _maskView.alpha = 0.5;
    }];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView: keyWindow];
    _animator.delegate = self;
    [keyWindow setWindowLevel:UIWindowLevelStatusBar + 1];
    
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self]];
    [_animator addBehavior:gravity];
    
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self]];
    collision.translatesReferenceBoundsIntoBoundary = NO;
    [collision addBoundaryWithIdentifier:@"notificationEnd" fromPoint:CGPointMake(0, alertHeight + 1) toPoint:CGPointMake([[UIScreen mainScreen] bounds].size.width, alertHeight + 1)];
    [_animator addBehavior:collision];
    
    UIDynamicItemBehavior *elasticityBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self]];
    elasticityBehavior.elasticity = 0.35f;
    [_animator addBehavior:elasticityBehavior];
    
        //    __weak SWDropdownAlertView *weakSelf = self;
        //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        //        if (completion) {
        //            completion(_alertViewType);
        //        }
    
        //        if (duration > 0) {
        //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //                [weakSelf dismiss];
        //            });
        //        }
        //    });
}

- (void)dismiss {
    [self dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(SWDropdownAlertViewCompletion)completion{
    self.animationDirection = SWDropdownAlertViewAnimationDirectionBack;
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self]];
    gravity.gravityDirection = CGVectorMake(0, -1.5);
    [_animator removeAllBehaviors];
    @try {
        [_animator addBehavior:gravity];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
    
    
        //    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self]];
        //    collision.translatesReferenceBoundsIntoBoundary = NO;
        //    [collision addBoundaryWithIdentifier:@"notificationEnd" fromPoint:CGPointMake(0, -70) toPoint:CGPointMake([[UIScreen mainScreen] bounds].size.width, -70)];
        //    [_animator addBehavior:collision];
    
    __weak SWDropdownAlertView *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [_animator removeAllBehaviors];
        [weakSelf removeFromSuperview];
        BOOL hasSWDropdownAlertView = NO;
        UIWindow *keyWindow = [self keyWindow];
        if (!keyWindow) {
            return;
        }
        for (UIView *view in keyWindow.subviews) {
            if ([view isKindOfClass:[SWDropdownAlertView class]]) {
                hasSWDropdownAlertView = YES;
            }
        }
        
        if (!hasSWDropdownAlertView) {
            [keyWindow setWindowLevel:UIWindowLevelNormal];
        }
        appeared = NO;
        if (completion) {
            completion(_alertViewType);
        }
    });
    
    
    [UIView animateWithDuration:0.25 animations:^{
        _maskView.alpha = 0;
    } completion:^(BOOL finishied){
        [_maskView removeFromSuperview];
    }];
    
}

- (void)maskViewDidClicked:(UITapGestureRecognizer*)tapGesture{
    if (!_animator.isRunning) {
        [self dismiss];
    }
    
}


#pragma mark - UIDynamicAnimatorDelegate

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator{
    if (self.animationDirection == SWDropdownAlertViewAnimationDirectionBack) {
        [_animator removeAllBehaviors];
        [self removeFromSuperview];
        
        BOOL hasSWDropdownAlertView = NO;
        UIWindow *keyWindow = [self keyWindow];
        if (!keyWindow) {
            return;
        }
        for (UIView *view in keyWindow.subviews) {
            if ([view isKindOfClass:[SWDropdownAlertView class]]) {
                hasSWDropdownAlertView = YES;
            }
        }
        
        if (!hasSWDropdownAlertView) {
            [keyWindow setWindowLevel:UIWindowLevelNormal];
        }
        
        if (self.completionBlock) {
            self.completionBlock(self.alertViewType);
            self.completionBlock = nil;
        }
    }else{
        if (self.completionBlock) {
            self.completionBlock(self.alertViewType);
            self.completionBlock = nil;
        }
        if (self.duration > 0) {
            __weak SWDropdownAlertView *weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf dismiss];
            });
        }
        
    }
    
}

#pragma mark - Private
- (UIWindow *)keyWindow{
    UIWindow *keyWindow = nil;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    
    for (UIWindow *window in windows) {
        if ([window isMemberOfClass:[UIWindow class]]) {
            keyWindow = window;
        }
    }
    
    return keyWindow;
    
}
@end
