//
//  DeviceManage.h
//  Appliances
//
//  Created by qiufawen on 10/12/14.
//  Copyright (c) 2014 yekaiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceEntity.h"
#import "NetService.h"

@interface DeviceManage : NSObject

//-(DeviceManage *)init;
+(DeviceManage *)sharedInstance;

-(BOOL)GetDevicesFromNet:(BOOL)fouce;
-(NSMutableArray*)GetDevices;
@end
