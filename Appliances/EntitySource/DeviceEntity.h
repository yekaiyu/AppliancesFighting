//
//  VendorEntity.h
//  Appliances
//
//  Created by yekaiyu on 14-10-24.
//  Copyright (c) 2014年 yekaiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HardwareType: NSObject

@property(nonatomic,copy) NSString* vendor;

@property(nonatomic,copy) NSString* model;

@end

@interface DeviceEntity : NSObject

@property(nonatomic,copy) NSString* vendorId;

@property(nonatomic,copy) NSString* vendorName;

@property(nonatomic,copy) NSString* mfgSerialNumber;

@property(nonatomic,copy) NSString* vendorDescription;

@property(nonatomic,copy) NSString* classId;

@property(nonatomic,copy) NSString* className;

@property(nonatomic,copy) NSString* classDescription;

@property(nonatomic,copy) NSString*  ID;

@property(nonatomic,copy) NSString*  modelId;

@property(nonatomic,copy) NSString*  modelName;

@property(nonatomic,copy) NSString*  deviceClassId;

@property(nonatomic,copy) NSString*  deviceClassName;

@property(nonatomic,copy) NSString*  revision;

@property(nonatomic,copy) NSString*  factoryConfigure;

@property(nonatomic,copy) NSString*  userConfigure;

@property(nonatomic,copy) NSString*  deviceState;

@property(nonatomic,copy) NSString*  name;

@property(nonatomic,copy) NSString*  location;

@property(nonatomic,copy) NSString*  Description;

@property(nonatomic,copy) NSString*  driverId;

@property(nonatomic,copy) NSString*  defaultFunctionalDeviceIndex;

@property(nonatomic,copy) HardwareType *  hardwareType;

@end
