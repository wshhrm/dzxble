//
//  DetailViewController.h
//  BleDemo
//
//  Created by 张天润 on 2019/11/26.
//  Copyright © 2019 liuyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BeDataModel;

@interface DetailViewController : UIViewController

- (instancetype)initWithData:(BeDataModel *)data;

- (void)updateWithData:(BeDataModel *)data;

@end

NS_ASSUME_NONNULL_END
