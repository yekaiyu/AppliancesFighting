//
//  DeviceManage.m
//  Appliances
//
//  Created by qiufawen on 10/12/14.
//  Copyright (c) 2014 yekaiyu. All rights reserved.
//

#import "DeviceManage.h"

static DeviceManage * cDeviceManage = nil;

@interface DeviceManage()

@property(nonatomic) BOOL bGetDevice;
@property(nonatomic, copy) NSMutableArray * Devices;
@end

@implementation DeviceManage

-(DeviceManage *)init
{
    self = [super init];
    if (self) {
        _bGetDevice = FALSE;
        [_Devices init];
    }
    return self;
}
+(DeviceManage *)sharedInstance
{
    if (cDeviceManage == nil) {
        cDeviceManage = [DeviceManage alloc];
    }
    return cDeviceManage;
}

-(BOOL)GetDevicesFromNet:(BOOL)fouce
{
    if ([[NetService sharedInstance] isLogin]) {
        if (_bGetDevice && !fouce) {
            return TRUE;
        }
        else{
            NSArray * Devices = [[NetService sharedInstance] GetDevice];
            if (Devices == nil) {
                return FALSE;
            }else
            {
                _bGetDevice = Devices;
                return TRUE;
            }
        }
        
    }
    return FALSE;
}

-(void)ParseDevice:(NSDictionary*) Devices
{
    [_Devices removeAllObjects];
//    NSDictionary * dictionary = responseObject;
    
}
-(NSMutableArray*)GetDevices
{
    if (_bGetDevice) {
        return _Devices;
    }
    return nil;
}
@end
