//
//  DetailViewController.m
//  BleDemo
//
//  Created by 张天润 on 2019/11/26.
//

#import "DetailViewController.h"
#import "UIDevice+ZTR.h"
#import "BeDataModel.h"
#import <AudioToolbox/AudioToolbox.h>
#import <YYCache/YYCache.h>

@interface DetailViewController ()

@property (nonatomic, strong) BeDataModel *dataModel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *detailView;


@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *lastRSSI;
@property (nonatomic, strong) UILabel *numberOfRSSI;

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
    self.detailView = [[UIView alloc] initWithFrame:CGRectMake(0, BDV_NAVI_BAR_HEIGHT, BDV_Screen_Width, 200)];
    self.detailView.backgroundColor = UIColor.blackColor;
    [self buildDetailView];
    [self.view addSubview:self.detailView];
    self.textView= [[UITextView alloc] initWithFrame:CGRectMake(0, BDV_NAVI_BAR_HEIGHT + 200, BDV_Screen_Width, BDV_Screen_Height - BDV_NAVI_BAR_HEIGHT)];
    [self.view addSubview:self.textView];
    self.textView.font = [UIFont systemFontOfSize:15];
    [self buildText];
}

- (void)buildDetailView
{
    {
        UIView *beaconNameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BDV_Screen_Width, 40)];
        [self.detailView addSubview:beaconNameView];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BDV_Screen_Width, 20)];
        
        label1.text = @"Device Name: ";
        [beaconNameView addSubview:label1];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, BDV_Screen_Width, 20)];
        _nameLabel.text = self.dataModel.peripheral.name;
        [beaconNameView addSubview:_nameLabel];
        beaconNameView.layer.borderWidth = 0.5;
        beaconNameView.layer.borderColor = UIColor.whiteColor.CGColor;
    }
    
    // 2
    {
        UIView *beaconNameView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, BDV_Screen_Width, 40)];
        [self.detailView addSubview:beaconNameView];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BDV_Screen_Width, 20)];
        
        label1.text = @"UUID: ";
        [beaconNameView addSubview:label1];
        
        UILabel *uuidLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, BDV_Screen_Width, 20)];
        uuidLabel.text = self.dataModel.peripheral.identifier.UUIDString;
        [beaconNameView addSubview:uuidLabel];
        beaconNameView.layer.borderWidth = 0.5;
        beaconNameView.layer.borderColor = UIColor.whiteColor.CGColor;
    }
    
    {
        UIView *beaconNameView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, BDV_Screen_Width, 40)];
        [self.detailView addSubview:beaconNameView];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BDV_Screen_Width, 20)];
        
        label1.text = @"Last find date: ";
        [beaconNameView addSubview:label1];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, BDV_Screen_Width, 20)];
        _dateLabel.text = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSinceReferenceDate:([self.dataModel.dicData[@"kCBAdvDataTimestamp"] intValue] + 8 * 3600)]];
        [beaconNameView addSubview:_dateLabel];
        beaconNameView.layer.borderWidth = 0.5;
        beaconNameView.layer.borderColor = UIColor.whiteColor.CGColor;
    }
    
    {
        UIView *beaconNameView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, BDV_Screen_Width, 40)];
        [self.detailView addSubview:beaconNameView];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BDV_Screen_Width, 20)];
        
        label1.text = @"Number of RSSIs ";
        [beaconNameView addSubview:label1];
        
        _numberOfRSSI = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, BDV_Screen_Width, 20)];
        _numberOfRSSI.text = @(self.dataModel.RSSIs.count).stringValue;
        [beaconNameView addSubview:_numberOfRSSI];
        beaconNameView.layer.borderWidth = 0.5;
        beaconNameView.layer.borderColor = UIColor.whiteColor.CGColor;
    }
    
    {
        UIView *beaconNameView = [[UIView alloc] initWithFrame:CGRectMake(0, 160, BDV_Screen_Width, 40)];
        [self.detailView addSubview:beaconNameView];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BDV_Screen_Width, 20)];
        
        label1.text = @"RSSI after KGMM";
        [beaconNameView addSubview:label1];
        
        _lastRSSI = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, BDV_Screen_Width, 20)];
        _lastRSSI.text = [self getKGMMRSSI];
        [beaconNameView addSubview:_lastRSSI];
        beaconNameView.layer.borderWidth = 0.5;
        beaconNameView.layer.borderColor = UIColor.whiteColor.CGColor;
    }
    
}

- (NSString *)getKGMMRSSI
{
    CGFloat total = 0;
    for (NSNumber *number in self.dataModel.RSSIs) {
        total += ([number intValue]);
    }
    return [@(total / self.dataModel.RSSIs.count) stringValue];
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
    _dateLabel.text = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSinceReferenceDate:([self.dataModel.dicData[@"kCBAdvDataTimestamp"] intValue] + 8 * 3600)]];
    _numberOfRSSI.text = @(self.dataModel.RSSIs.count).stringValue;
    _lastRSSI.text = [self getKGMMRSSI];
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
