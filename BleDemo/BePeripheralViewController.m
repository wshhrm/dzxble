//
//  BePeripheralViewController.m
//  BleDemo
//
//  Created by ztr on 19/9/7.
//

#import "BePeripheralViewController.h"
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "UIDevice+ZTR.h"

@interface BePeripheralViewController()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *currentPoint;

@property (nonatomic, strong) NSArray *pointArrayX;
@property (nonatomic, strong) NSArray *pointArrayY;

@property (nonatomic, strong) NSMutableArray *lengthArray;

@property (nonatomic, assign) CGPoint centerPoint;

@end


@implementation BePeripheralViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self buildViews];
    [self buildBottomViews];
}

- (void)buildViews
{
    _backgroundView = [UIView new];
    [self.view addSubview:_backgroundView];
    self.backgroundView.frame = CGRectMake(0, BDV_NAVI_BAR_HEIGHT, BDV_Screen_Width, BDV_Screen_Width);
    self.backgroundView.backgroundColor = [UIColor colorWithRed:243.0f/255 green:244.0f/255 blue:245.0f/255 alpha:1];
    
    self.pointArrayX = @[@(0.0),@(0.1),@(0),@(0.5),@(0.5),@(0.9),@(1),@(1)];
    self.pointArrayY = @[@(0.0),@(0.5),@(1),@(0.1),@(0.9),@(0.5),@(1),@(0)];
//
//
//    [self.pointArray addObject:NSStringFromCGPoint(CGPointMake(0, 0))];
//    [self.pointArray addObject:NSStringFromCGPoint(CGPointMake(0.1, 0.5))];
//    [self.pointArray addObject:NSStringFromCGPoint(CGPointMake(0, 1))];
//    [self.pointArray addObject:NSStringFromCGPoint(CGPointMake(0.5, 0.1))];
//    [self.pointArray addObject:NSStringFromCGPoint(CGPointMake(0.5, 0.9))];
//    [self.pointArray addObject:NSStringFromCGPoint(CGPointMake(0.0, 0.5))];
//    [self.pointArray addObject:NSStringFromCGPoint(CGPointMake(1, 1))];
//    [self.pointArray addObject:NSStringFromCGPoint(CGPointMake(1, 0))];
    
    for (int i = 0 ; i < 8; i++) {
        CGFloat x = [self.pointArrayX[i] floatValue] * BDV_Screen_Width;
        CGFloat y = [self.pointArrayY[i] floatValue] * BDV_Screen_Width;
        x = x > 0 ? x:6;
        x = x < BDV_Screen_Width ? x : BDV_Screen_Width - 6 ;
        y = y > 0 ? y:6;
        y = y < BDV_Screen_Width ? y : BDV_Screen_Width - 6 ;
        UIImageView *label = [[UIImageView alloc] initWithFrame:CGRectMake(x - 6, y - 6, 12, 12)];
        label.layer.cornerRadius = 6.0f;
        label.clipsToBounds = YES;
        [label setImage:[UIImage imageNamed:@"beacon"]];
//        label.text = @" B";
        [self.backgroundView addSubview:label];
    }
    
    _currentPoint = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mobile"]];
    int x = arc4random() % (int)BDV_Screen_Width;
    int y = arc4random() % (int)BDV_Screen_Width;
    
    self.centerPoint = CGPointMake((x * 1.0) / BDV_Screen_Width, (y * 1.0) / BDV_Screen_Width);
    
    x = x > 0 ? x:12;
    x = x < BDV_Screen_Width ? x : BDV_Screen_Width - 12 ;
    y = y > 0 ? y:12;
    y = y < BDV_Screen_Width ? y : BDV_Screen_Width - 12 ;
    
    
    _currentPoint.frame = CGRectMake(x - 12, y - 12, 24, 24);
    [self.backgroundView addSubview:_currentPoint];
    
    NSString *string = @"XXXXXX";
    
    UILabel *label1 = [UILabel new];
    UILabel *label2 = [UILabel new];
    UILabel *label3 = [UILabel new];
    UILabel *label4 = [UILabel new];
    
    label1.text = string;
    label1.textColor = UIColor.blackColor;
    label1.font = [UIFont systemFontOfSize:8];
    
    label1.frame = CGRectMake(0, BDV_Screen_Width / 2 - 15, 40, 30);
    [self.backgroundView addSubview:label1];
    
    
    label2.text = string;
    label2.textColor = UIColor.blackColor;
    label2.font = [UIFont systemFontOfSize:8];
    
    label2.frame = CGRectMake(BDV_Screen_Width - 35, BDV_Screen_Width / 2 - 15, 40, 30);
    [self.backgroundView addSubview:label2];
    
    label3.text = string;
    label3.textColor = UIColor.blackColor;
    label3.font = [UIFont systemFontOfSize:8];
    label3.numberOfLines = 6;
    
    label3.frame = CGRectMake(BDV_Screen_Width / 2 - 3, 0, 6, 30);
    [self.backgroundView addSubview:label3];
    
    label4.text = string;
    label4.textColor = UIColor.blackColor;
    label4.font = [UIFont systemFontOfSize:8];
    label4.numberOfLines = 6;
    
    label4.frame = CGRectMake(BDV_Screen_Width / 2 - 3, BDV_Screen_Width - 30, 6, 30);
    [self.backgroundView addSubview:label4];
    
    
}

- (void)buildBottomViews
{
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, BDV_Screen_Width + BDV_NAVI_BAR_HEIGHT, BDV_Screen_Width, BDV_Screen_Height - BDV_Screen_Width - BDV_NAVI_BAR_HEIGHT)];
    self.bottomView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    [self.view addSubview:self.bottomView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BDV_Screen_Width, 20)];
    view.layer.borderColor = UIColor.blackColor.CGColor;
    view.layer.borderWidth = 1.f;
    [self.bottomView addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BDV_Screen_Width / 2, 20)];
    label.textColor = UIColor.blackColor;
    label.text = @"当前预测位置坐标";

    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(BDV_Screen_Width / 2, 0, BDV_Screen_Width / 2, 20)];
    label1.textColor = UIColor.blackColor;
    label1.text = [NSString stringWithFormat:@"(%f,%f)",self.currentPoint.frame.origin.x / BDV_Screen_Width * 10,10 - self.currentPoint.frame.origin.y / BDV_Screen_Width * 10];
    
    [view addSubview:label];
    [view addSubview:label1];
    
    CGFloat currentHeight = 20;
    
    _lengthArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 8; i++) {
        CGFloat length = sqrt((self.centerPoint.x - [self.pointArrayX[i] floatValue]) * (self.centerPoint.x - [self.pointArrayX[i] floatValue]) + (self.centerPoint.y - [self.pointArrayY[i] floatValue]) * (self.centerPoint.y - [self.pointArrayY[i] floatValue]));
        [self.lengthArray addObject:@(length)];
        
        UILabel *label = [UILabel new];
        label.textColor = UIColor.blackColor;
        label.text = [NSString stringWithFormat:@"距离beacon%d坐标(%.2f,%.2f)距离为    %.3fm",i+1,[self.pointArrayX[i] floatValue] * 10,(1 - [self.pointArrayY[i] floatValue]) * 10, length * 10];
        label.frame = CGRectMake(0, currentHeight, BDV_Screen_Width, 20);
        [self.bottomView addSubview:label];
        currentHeight += 20;
    }
    
    
    
}



@end
