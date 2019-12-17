//
//  UIDevice+ZTR.h
//  BleDemo
//
//  Created by 张天润 on 2019/10/24.
//  Copyright © 2019 liuyanwei. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define BDV_Screen_Width         ([[UIScreen mainScreen] bounds].size.width)
#define BDV_Screen_Height        ([[UIScreen mainScreen] bounds].size.height)

#define BDV_ONLY_NAVI_BAR_HEIGHT (44)
#define BDV_STATUE_BAR_HEIGHT    ([UIDevice currentDevice].isIPhoneX ? 44.f : 20.f)
#define BDV_NAVI_BAR_HEIGHT      ([UIDevice currentDevice].isIPhoneX ? 88 : 64)

#define BDV_SAFE_INSET_TOP              ([UIDevice currentDevice].isIPhoneX ? 44 : 0)
#define BDV_SAFE_INSET_BOTTOM           ([UIDevice currentDevice].isIPhoneX ? 34 : 0)
#define BDV_SAFE_INSET_BOTTOM_LANDSCAPE ([UIDevice currentDevice].isIPhoneX ? 21 : 0)
#define BDV_SAFE_INSET                  (UIEdgeInsetsMake(BDV_SAFE_INSET_TOP, 0, BDV_SAFE_INSET_BOTTOM, 0))
#define BDV_SAFE_AREA_INSET             (UIEdgeInsetsMake(BDV_NAVI_BAR_HEIGHT, 0, BDV_SAFE_INSET_BOTTOM, 0))

#define BDV_IPHONEX_BOTTOM_FIX_SPACE            ([UIDevice currentDevice].isIPhoneX ? 34 : 0)
#define BDV_IPHONEX_BOTTOM_LANDSCAPE_FIX_SPACE  ([UIDevice currentDevice].isIPhoneX ? 21 : 0)
#define BDV_IPHONEX_TOP_FIX_SPACE               ([UIDevice currentDevice].isIPhoneX ? 44 : 0)

/** 每个产品必须在项目中定义自己的kBDVTabBarHeight */
FOUNDATION_EXTERN CGFloat kBDVTabBarHeight; // TabBar height
#define BDV_TAB_BAR_HEIGHT          (kBDVTabBarHeight)
#define BDV_TAB_SAFE_INSET_BOTTOM   (BDV_TAB_BAR_HEIGHT + BDV_SAFE_INSET_BOTTOM) // 带 TabBar 的 ViewController 安全区域高度
#define BDVIsIphoneX()  ([UIDevice currentDevice].isIPhoneX)

@interface UIDevice (ZTR)

@property (nonatomic, readonly, getter=isIPhoneX) BOOL iPhoneX; // 看代码，就是判断isIPhoneXSeries
@property (nonatomic, readonly, assign, getter=safeAreaInIOS11) UIEdgeInsets safeAreaInIOS11;

+ (BOOL)isIPhoneXSeries;
+ (BOOL)isIPhoneXR;
+ (BOOL)isIPhoneXS;
+ (BOOL)isIPhoneXSMax;
+ (BOOL)isIPhoneXSSeries;
+ (BOOL)isIPhone6AndLater;

@end

NS_ASSUME_NONNULL_END
