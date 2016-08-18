//
//  PDLoading.h
//  PDLoadView
//
//  Created by Panda on 16/8/18.
//  Copyright © 2016年 FLZC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDLoading : UIView
/**
 *  显示加载动画
 */
- (void)showLoadingView;
/**
 *  关闭加载动画
 */
- (void)dismissLoadingView;
/**
 *  创建动画单例
 *
 *  @return iKYloadView
 */
+ (instancetype)shareLoadView;

/**
 *  显示加载动画(带毛玻璃效果)
 */
- (void)showLoadingViewWithBlur;

/**
 *  关闭加载动画(带毛玻璃效果)
 */
- (void)dismissLoadingViewWithBlur;

@end
