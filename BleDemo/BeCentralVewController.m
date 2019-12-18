//
//  BeCentraliewController.m
//  BleDemo
//
//  Created by ztr on 15/9/7.
//  Copyright (c) 2015年 liuyanwei. All rights reserved.
//

#import "BeCentralVewController.h"
#import "BeDataModel.h"
#import "DetailViewController.h"
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "BePeripheralViewController.h"
#import "UIDevice+ZTR.h"

@interface BeCentralVewController () <UITableViewDelegate, UITableViewDataSource>
{
    //系统蓝牙设备管理对象，可以把他理解为主设备，通过他，可以去扫描和链接外设
    CBCentralManager *manager;
    UILabel *info;
    //用于保存被发现设备
    NSMutableArray *discoverPeripherals;
    NSString *lastString;
    DetailViewController *lastDetailVC;
}

@property (nonatomic, strong) NSMutableDictionary<NSString *, BeDataModel *> *dataModels;
@property (nonatomic, strong) UITableView *resultTableView;
@property (nonatomic, strong) NSMutableArray<NSString *> *uuidArray;
@property (nonatomic, strong) CBCentralManager *manager2;
@property (nonatomic, assign) BOOL needContinueRefresh;

@end

@implementation BeCentralVewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    manager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    RACSignal *timeSignal = [RACSignal interval:5.0f onScheduler:[RACScheduler mainThreadScheduler]];
    timeSignal = [timeSignal take:1000000000];
    [[timeSignal deliverOnMainThread] subscribeNext:^(id _Nullable x) {
        if (self.needContinueRefresh) {
            [manager stopScan];
            manager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
        }
    }];
    lastDetailVC = nil;
    self.dataModels = [[NSMutableDictionary alloc] init];
    self.uuidArray = [[NSMutableArray alloc] init];
    
    UIButton *refreshDataBtn = [UIButton new];
    [refreshDataBtn setTitle:@"refreshSearch" forState:UIControlStateNormal];
    @weakify(self);
    [[refreshDataBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [manager stopScan];
        manager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
        self.needContinueRefresh = NO;
    }];
    refreshDataBtn.backgroundColor = UIColor.systemPinkColor;
    
    UIButton *continueRefreshBtn = [UIButton new];
    [continueRefreshBtn setTitle:@"continueRefresh" forState:UIControlStateNormal];
    [[continueRefreshBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.needContinueRefresh = YES;
    }];
    continueRefreshBtn.backgroundColor = UIColor.systemGreenColor;
    
    

    
    
    
    
    self.resultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, BDV_NAVI_BAR_HEIGHT + 50, BDV_Screen_Width, BDV_Screen_Height - BDV_NAVI_BAR_HEIGHT - 50)
                                                        style:UITableViewStylePlain];
    self.resultTableView.dataSource = self;
    self.resultTableView.delegate = self;
    [self.resultTableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
    
    [self.view addSubview:self.resultTableView];
    [self.view addSubview:refreshDataBtn];
    [refreshDataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(BDV_NAVI_BAR_HEIGHT);
        make.bottom.mas_equalTo(self.resultTableView.mas_top);
        make.left.equalTo(self.view);
    }];
    
    [self.view addSubview:continueRefreshBtn];
    [continueRefreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(BDV_NAVI_BAR_HEIGHT);
        make.bottom.mas_equalTo(self.resultTableView.mas_top);
        make.left.mas_equalTo(refreshDataBtn.mas_right);
    }];
    
    
    
    
    UIButton *mapBtn = [UIButton new];
       [mapBtn setTitle:@"地图定位" forState:UIControlStateNormal];
       [[mapBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
           @strongify(self);
           BePeripheralViewController *vc = [[BePeripheralViewController alloc] init];
           [self.navigationController pushViewController:vc animated:YES];
       }];
       mapBtn.backgroundColor = UIColor.systemPurpleColor;
    [self.view addSubview:mapBtn];
     [mapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(BDV_NAVI_BAR_HEIGHT);
         make.bottom.mas_equalTo(self.resultTableView.mas_top);
         make.left.mas_equalTo(continueRefreshBtn.mas_right);
         make.right.mas_equalTo(self.view);
     }];
    
    
    
    
    /*
     设置主设备的委托,CBCentralManagerDelegate
     必须实现的：
     - (void)centralManagerDidUpdateState:(CBCentralManager
     *)central;//主设备状态改变的委托，在初始化CBCentralManager的适合会打开设备，只有当设备正确打开后才能使用 其他选择实现的委托中比较重要的：
     - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData
     RSSI:(NSNumber *)RSSI; //找到外设的委托
     - (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral;//连接外设成功的委托
     - (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;//外设连接失败的委托
     - (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;//断开外设的委托
     */
    
    //初始化并设置委托和线程队列，最好一个线程的参数可以为nil，默认会就main线程
    //    self.manager2 = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(1, 1)];
    //持有发现的设备,如果不持有设备会导致CBPeripheralDelegate方法不能正确回调
    discoverPeripherals = [[NSMutableArray alloc] init];
    //页面样式
    [self.view setBackgroundColor:[UIColor whiteColor]];
    



    //    info = [[UILabel alloc]initWithFrame:self.view.frame];
    //    [info setText:@"正在执行程序，请观察NSLog信息"];
    //    [info setTextAlignment:NSTextAlignmentCenter];
    //    [self.view addSubview:info];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    lastString = @"";
    lastDetailVC = nil;
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@">>>CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@">>>CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@">>>CBCentralManagerStateUnsupported");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@">>>CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@">>>CBCentralManagerStatePoweredOff");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@">>>CBCentralManagerStatePoweredOn");
            //开始扫描周围的外设
            /*
             第一个参数nil就是扫描周围所有的外设，扫描到外设后会进入
             - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary
             *)advertisementData RSSI:(NSNumber *)RSSI;
             */
            [central scanForPeripheralsWithServices:nil options:nil];
            
            break;
        default:
            break;
    }
}

//扫描到设备会进入方法
- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    NSLog(@"当扫描到设备:%@  信号强度:%@ 设备id:%@", peripheral.name, RSSI, peripheral.identifier);
    if (!peripheral.name) {
        return;
    }
    if (lastString.length > 0 && [[peripheral.identifier UUIDString] isEqualToString:lastString]) {
        [manager stopScan];
        manager  = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    }
    
    if (![self.dataModels objectForKey:[peripheral.identifier UUIDString]]) {
        BeDataModel *model = [[BeDataModel alloc] init];
        model.name = peripheral.name;
        model.uuid = [peripheral.identifier UUIDString];
        model.peripheral = peripheral;
        [model.RSSIs addObject:RSSI];
        [self.dataModels setValue:model forKey:[peripheral.identifier UUIDString]];
        [self.uuidArray addObject:[peripheral.identifier UUIDString]];
        [self.dataModels objectForKey:[peripheral.identifier UUIDString]].dicData = advertisementData;
    } else {
        [[self.dataModels objectForKey:[peripheral.identifier UUIDString]].RSSIs addObject:RSSI];
        [self.dataModels objectForKey:[peripheral.identifier UUIDString]].dicData = advertisementData;
    }
    //接下连接我们的测试设备，如果你没有设备，可以下载一个app叫lightbule的app去模拟一个设备
    //这里自己去设置下连接规则，我设置的是P开头的设备
    //    if ([peripheral.name hasPrefix:@"P"]){
    /*
     一个主设备最多能连7个外设，每个外设最多只能给一个主设备连接,连接成功，失败，断开会进入各自的委托
     - (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral;//连接外设成功的委托
     - (void)centra`lManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;//外设连接失败的委托
     - (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;//断开外设的委托
     */
    
    //找到的设备必须持有它，否则CBCentralManager中也不会保存peripheral，那么CBPeripheralDelegate中的方法也不会被调用！！
    //        [discoverPeripherals addObject:peripheral];
    //        [central connectPeripheral:peripheral options:nil];
    //    }
    
    if (lastString.length > 0 && [[peripheral.identifier UUIDString] isEqualToString:lastString]) {
        [lastDetailVC updateWithData:[self.dataModels objectForKey:lastString]];
        if ([self.dataModels objectForKey:lastString].RSSIs.count == 100) {
            [manager stopScan];
        }
    }
    
    [self.resultTableView reloadData];
//    NSLog(@"contentsize = %f",self.resultTableView.contentSize.height);
}


//连接到Peripherals-失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@">>>连接到名称为（%@）的设备-失败,原因:%@", [peripheral name], [error localizedDescription]);
}

// Peripherals断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@">>>外设连接断开连接 %@: %@\n", [peripheral name], [error localizedDescription]);
}
//连接到Peripherals-成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@">>>连接到名称为（%@）的设备-成功", peripheral.name);
    //设置的peripheral委托CBPeripheralDelegate
    //@interface ViewController : UIViewController<CBCentralManagerDelegate,CBPeripheralDelegate>
    [peripheral setDelegate:self];
    //扫描外设Services，成功后会进入方法：-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    [peripheral discoverServices:nil];
}


//扫描到Services
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    //  NSLog(@">>>扫描到服务：%@",peripheral.services);
    if (error) {
        NSLog(@">>>Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        return;
    }
    
    for (CBService *service in peripheral.services) {
        NSLog(@"%@", service.UUID);
        //扫描每个service的Characteristics，扫描到后会进入方法： -(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService
        //*)service error:(NSError *)error
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

//扫描到Characteristics
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error) {
        NSLog(@"error Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"service:%@ 的 Characteristic: %@", service.UUID, characteristic.UUID);
    }
    
    //获取Characteristic的值，读到数据会进入方法：-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic
    //*)characteristic error:(NSError *)error
    for (CBCharacteristic *characteristic in service.characteristics) {
        {
            [peripheral readValueForCharacteristic:characteristic];
        }
    }
    
    //搜索Characteristic的Descriptors，读到数据会进入方法：-(void)peripheral:(CBPeripheral *)peripheral
    // didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
    for (CBCharacteristic *characteristic in service.characteristics) {
        [peripheral discoverDescriptorsForCharacteristic:characteristic];
    }
}

//获取的charateristic的值
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    //打印出characteristic的UUID和值
    //!注意，value的类型是NSData，具体开发时，会根据外设协议制定的方式去解析数据
    NSLog(@"characteristic uuid:%@  value:%@", characteristic.UUID, characteristic.value);
}

//搜索到Characteristic的Descriptors
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    //打印出Characteristic和他的Descriptors
    NSLog(@"characteristic uuid:%@", characteristic.UUID);
    for (CBDescriptor *d in characteristic.descriptors) {
        NSLog(@"Descriptor uuid:%@", d.UUID);
    }
}
//获取到Descriptors的值
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    //打印出DescriptorsUUID 和value
    //这个descriptor都是对于characteristic的描述，一般都是字符串，所以这里我们转换成字符串去解析
    NSLog(@"characteristic uuid:%@  value:%@", [NSString stringWithFormat:@"%@", descriptor.UUID], descriptor.value);
}

//写数据
- (void)writeCharacteristic:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic value:(NSData *)value
{
    
    //打印出 characteristic
    //的权限，可以看到有很多种，这是一个NS_OPTIONS，就是可以同时用于好几个值，常见的有read，write，notify，indicate，知知道这几个基本就够用了，前连个是读写权限，后两个都是通知，两种不同的通知方式。
    /*
     typedef NS_OPTIONS(NSUInteger, CBCharacteristicProperties) {
     CBCharacteristicPropertyBroadcast												= 0x01,
     CBCharacteristicPropertyRead													= 0x02,
     CBCharacteristicPropertyWriteWithoutResponse									= 0x04,
     CBCharacteristicPropertyWrite													= 0x08,
     CBCharacteristicPropertyNotify													= 0x10,
     CBCharacteristicPropertyIndicate												= 0x20,
     CBCharacteristicPropertyAuthenticatedSignedWrites								= 0x40,
     CBCharacteristicPropertyExtendedProperties										= 0x80,
     CBCharacteristicPropertyNotifyEncryptionRequired NS_ENUM_AVAILABLE(NA, 6_0)		= 0x100,
     CBCharacteristicPropertyIndicateEncryptionRequired NS_ENUM_AVAILABLE(NA, 6_0)	= 0x200
     };
     
     */
    NSLog(@"%lu", (unsigned long) characteristic.properties);
    
    
    //只有 characteristic.properties 有write的权限才可以写
    if (characteristic.properties & CBCharacteristicPropertyWrite) {
        /*
         最好一个type参数可以为CBCharacteristicWriteWithResponse或type:CBCharacteristicWriteWithResponse,区别是是否会有反馈
         */
        [peripheral writeValue:value forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    } else {
        NSLog(@"该字段不可写！");
    }
}

//设置通知
- (void)notifyCharacteristic:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic
{
    //设置通知，数据通知会进入：didUpdateValueForCharacteristic方法
    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
}

//取消通知
- (void)cancelNotifyCharacteristic:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic
{
    
    [peripheral setNotifyValue:NO forCharacteristic:characteristic];
}

//停止扫描并断开连接
- (void)disconnectPeripheral:(CBCentralManager *)centralManager peripheral:(CBPeripheral *)peripheral
{
    //停止扫描
    [centralManager stopScan];
    //断开连接
    [centralManager cancelPeripheralConnection:peripheral];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-- tableView Delegate && DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    cell.textLabel.text = [self.dataModels objectForKey:self.uuidArray[indexPath.item]].name;
    cell.detailTextLabel.text = [[self.dataModels objectForKey:self.uuidArray[indexPath.item]] uuid];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *vc = [[DetailViewController alloc] initWithData:[self.dataModels objectForKey:self.uuidArray[indexPath.item]]];
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
    lastString = [self.dataModels objectForKey:self.uuidArray[indexPath.item]].uuid;
    lastDetailVC = vc;
    

    
}

@end
