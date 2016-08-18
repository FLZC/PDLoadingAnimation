//
//  PDLoading.m
//  PDLoadView
//
//  Created by Panda on 16/8/18.
//  Copyright © 2016年 FLZC. All rights reserved.
//

#import "PDLoading.h"
static CGFloat const KLoadingViewWidth = 70;
static CGFloat const KShapeLayerWidth = 40;
static CGFloat const KShapeLayerRadius = KShapeLayerWidth / 2;
static CGFloat const KShapelayerLineWidth = 2.5;
static CGFloat const KAnimationDurationTime = 1.5;
static CGFloat const KShapeLayerMargin = (KLoadingViewWidth - KShapeLayerWidth) / 2;
@implementation PDLoading{
    UIVisualEffectView *blurView;
    UIView * backView;
    BOOL isShowing;
}
- (void)awakeFromNib{
    [self setUI];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

+ (instancetype)shareLoadView{
    static PDLoading *loadView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loadView = [[PDLoading alloc] init];
    });
    return loadView;
}
- (void)setUI{
    
    backView = [[UIView alloc] init];
    
    /// 底部的灰色layer
    CAShapeLayer *bottomShapeLayer = [CAShapeLayer layer];
    bottomShapeLayer.strokeColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    bottomShapeLayer.fillColor = [UIColor clearColor].CGColor;
    bottomShapeLayer.lineWidth = KShapelayerLineWidth;
    //    bottomShapeLayer.lineDashPattern = @[@6,@3];
    bottomShapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(KShapeLayerMargin, 0, KShapeLayerWidth, KShapeLayerWidth) cornerRadius:KShapeLayerRadius].CGPath;
    [backView.layer addSublayer:bottomShapeLayer];
    
    /// 橘黄色的layer
    CAShapeLayer *ovalShapeLayer = [CAShapeLayer layer];
    ovalShapeLayer.strokeColor = [UIColor colorWithRed:0.984 green:0.153 blue:0.039 alpha:1.000].CGColor;
    ovalShapeLayer.fillColor = [UIColor clearColor].CGColor;
    ovalShapeLayer.lineWidth = KShapelayerLineWidth;
//    ovalShapeLayer.lineDashPattern = @[@6,@3];
    ovalShapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(KShapeLayerMargin, 0,KShapeLayerWidth, KShapeLayerWidth) cornerRadius:KShapeLayerRadius].CGPath;
    [backView.layer addSublayer:ovalShapeLayer];
    
    /// 起点动画
    CABasicAnimation * strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @(-1);
    strokeStartAnimation.toValue = @(1.0);
    
    /// 终点动画
    CABasicAnimation * strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @(0.0);
    strokeEndAnimation.toValue = @(1.0);
    
    /// 组合动画
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[strokeStartAnimation, strokeEndAnimation];
    animationGroup.duration = KAnimationDurationTime;
    animationGroup.repeatCount = CGFLOAT_MAX;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    [ovalShapeLayer addAnimation:animationGroup forKey:nil];
    
    
    UILabel *titleLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"正在加载...";
        label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0f];
        label.font = [UIFont systemFontOfSize:14];
        label.frame = CGRectMake(0, KShapeLayerWidth + 5, KLoadingViewWidth + 10, 20);
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [backView addSubview:titleLabel];
    [self addSubview:backView];
    
}

- (void)showLoadingView{
    if (isShowing) { // 如果没有退出动画，就不能继续添加
        return;
    }
    isShowing = YES;
    /// 拿到主窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    /// view的X
    CGFloat viewCenterX = CGRectGetWidth([UIScreen mainScreen].bounds) / 2;
    /// view的Y
    CGFloat viewCenterY = CGRectGetHeight([UIScreen mainScreen].bounds) / 2;
    
    self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds),  CGRectGetHeight([UIScreen mainScreen].bounds));
    
    backView.center = CGPointMake(viewCenterX, viewCenterY);
    
    // 添加到主窗口中
    [window addSubview:self];
}

- (void)dismissLoadingView{
    if (isShowing == NO) {
        return;
    }
    isShowing = NO;
    [self removeFromSuperview];
}

- (void)showLoadingViewWithBlur{
    if (isShowing) { // 如果没有退出动画，就不能继续添加
        return;
    }
    isShowing = YES;
    /// 拿到主窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    /// view的X
    CGFloat viewCenterX = CGRectGetWidth([UIScreen mainScreen].bounds) / 2;
    /// view的Y
    CGFloat viewCenterY = CGRectGetHeight([UIScreen mainScreen].bounds) / 2;
    
    self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds),  CGRectGetHeight([UIScreen mainScreen].bounds));
    backView.frame = CGRectMake(0, 0, KLoadingViewWidth, KLoadingViewWidth);
    backView.center = CGPointMake(viewCenterX, viewCenterY);
    /// 添加到主窗口中
    [window addSubview:self];
    
    blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    blurView.layer.cornerRadius = 10;
    blurView.layer.masksToBounds = YES;
    blurView.frame = CGRectMake(0, 0, 100, 100);
    blurView.center = CGPointMake(viewCenterX, viewCenterY);
    /// 添加毛玻璃效果
    [self insertSubview:blurView belowSubview:backView];
}

- (void)dismissLoadingViewWithBlur{
    if (isShowing == NO) {
        return;
    }
    isShowing = NO;
    [backView removeFromSuperview];
    [blurView removeFromSuperview];
    [self removeFromSuperview];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
