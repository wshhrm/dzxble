//
//  DetailViewController.m
//  BleDemo
//
//  Created by 张天润 on 2019/11/26.
//  Copyright © 2019 liuyanwei. All rights reserved.
//

#import "DetailViewController.h"
#import "UIDevice+ZTR.h"
#import "BeDataModel.h"
#import <AudioToolbox/AudioToolbox.h>
#import <YYCache/YYCache.h>

@interface DetailViewController ()

@property (nonatomic, strong) BeDataModel *dataModel;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation DetailViewController

- (instancetype)initWithData:(BeDataModel *)data
{
    self = [super init];
    if (self) {
        self.dataModel = data;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationController.title = self.dataModel.name;
    self.textView= [[UITextView alloc] initWithFrame:CGRectMake(0, BDV_NAVI_BAR_HEIGHT, BDV_Screen_Width, BDV_Screen_Height - BDV_NAVI_BAR_HEIGHT)];
    [self.view addSubview:self.textView];
    self.textView.font = [UIFont systemFontOfSize:15];
    [self buildText];
}

- (void)buildText
{
    NSString *text = @"";
    for (NSNumber *model in self.dataModel.RSSIs) {
        text = [text stringByAppendingString:[model stringValue]];
        text = [text stringByAppendingString:@"\n"];
    }
    self.textView.text = text;
    self.navigationItem.title = [self.dataModel.name stringByAppendingString:[NSString stringWithFormat:@" %lu",(unsigned long)self.dataModel.RSSIs.count]];
}

- (void)updateWithData:(BeDataModel *)data
{
    self.dataModel = data;
    [self buildText];
    if (data.RSSIs.count == 100) {
//        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//        pasteboard.string = self.textView.text;
        AudioServicesPlaySystemSound(1007);
        
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"finished" message:@"finish" preferredStyle:UIAlertControllerStyleAlert];
//
//        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
//        [window.rootViewController presentViewController:alert animated:YES completion:nil];
        YYCache *cache = [YYCache cacheWithName:@"ztr"];
        id number = [cache containsObjectForKey:@"number"] ? [cache objectForKey:@"number"] : @(0);
        NSInteger number1 = [(NSNumber *) number intValue];
        number1 = number1 + 1;
        
        CGFloat f = 0;
        for (NSNumber *number3 in self.dataModel.RSSIs) {
            f = f + [number3 floatValue];
        }
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[number stringValue]
                                                       message:[@(f / 100.0) stringValue]
                                                      delegate:nil
                                             cancelButtonTitle:@"cancle"
                                             otherButtonTitles:nil,nil];
        [alert show];
        
        [cache setObject:self.textView.text forKey:[@(number1) stringValue]];
        [cache setObject:@(number1) forKey:@"number"];
        NSLog(@"number1 = %ld",(long)number1);
    }
}




@end
