//
//  ViewController.m
//  BleDemo
//
//  Created by ZTELiuyw on 15/8/13.
//  Copyright (c) 2015年 liuyanwei. All rights reserved.
//

#import "ViewController.h"
#import "BeCentralVewController.h"
#import "BePeripheralViewController.h"
#import <YYCache/YYCache.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController (){

}

@property (nonatomic,strong) NSString *numberString;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CFAbsoluteTime time = CFAbsoluteTimeGetCurrent();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"123123123 = @f",CFAbsoluteTimeGetCurrent() - time);
    });
    
    
    
}

- (IBAction)clearcache:(UIButton *)sender {
    YYCache *cache = [YYCache cacheWithName:@"ztr"];
    [cache removeAllObjects];
}

- (IBAction)button:(id)sender {
    [self.view endEditing:YES];
    NSInteger number = [_numberString intValue];
    YYCache *cache = [YYCache cacheWithName:@"ztr"];
    
    if ([cache containsObjectForKey:[@(number) stringValue]]) {
        NSString *string = [cache objectForKey:[@(number) stringValue]];
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = string;
        AudioServicesPlaySystemSound(1007);
        
    }
    
}

- (IBAction)number:(UITextField *)sender {
    _numberString = sender.text;
}

- (IBAction)beCentral:(id)sender {
    BeCentralVewController *vc = [[BeCentralVewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)bePeripheral:(id)sender {
    BePeripheralViewController *vc = [[BePeripheralViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
