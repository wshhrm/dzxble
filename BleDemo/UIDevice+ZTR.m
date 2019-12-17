//
//  UIDevice+ZTR.m
//  BleDemo
//
//  Created by 张天润 on 2019/10/24.
//  Copyright © 2019 liuyanwei. All rights reserved.
//

#import "UIDevice+ZTR.h"
#import <objc/runtime.h>
#import <sys/utsname.h>
#define FLOAT_ZERO                      0.00001f
#define FLOAT_EQUAL_ZERO(a)             (fabs(a) <= FLOAT_ZERO)
#define FLOAT_EQUAL_TO(a, b)            FLOAT_EQUAL_ZERO((a) - (b))

@implementation UIDevice (ZTR)

- (BOOL)containsIphoneX
{
    BOOL isIPhoneX = NO;
    // iphone x/xs     375 * 812 pt   @3x
    // iphone xs max   414 * 896 pt   @3x
    // iphone xr       414 * 896 pt   @2x
    CGFloat height = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    if (FLOAT_EQUAL_TO(height, 812.f) || FLOAT_EQUAL_TO(height, 896.f)) {
        isIPhoneX = YES;
    }
    return isIPhoneX;
}

- (BOOL)isIPhoneX
{
    NSNumber *isIPhoneX = objc_getAssociatedObject(self, _cmd);
    if (isIPhoneX == nil) {
        isIPhoneX = @([self containsIphoneX]);
        objc_setAssociatedObject(self, _cmd, isIPhoneX, OBJC_ASSOCIATION_ASSIGN);
    }
    return [isIPhoneX boolValue];
}

@end
