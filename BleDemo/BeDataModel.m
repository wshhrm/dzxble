//
//  BeDataModel.m
//  BleDemo
//
//  Created by 张天润 on 2019/10/24.
//  Copyright © 2019 liuyanwei. All rights reserved.
//

#import "BeDataModel.h"

@implementation BeDataModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.RSSIs = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
