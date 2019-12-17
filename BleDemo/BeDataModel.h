//
//  BeDataModel.h
//  BleDemo
//
//  Created by 张天润 on 2019/10/24.
//  Copyright © 2019 liuyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BeDataModel : NSObject

@property (nonatomic, strong) NSMutableArray <NSNumber *> *RSSIs;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *uuid;

@end

NS_ASSUME_NONNULL_END
