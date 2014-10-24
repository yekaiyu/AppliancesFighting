//
//  VendorEntity.h
//  Appliances
//
//  Created by yekaiyu on 14-10-24.
//  Copyright (c) 2014年 yekaiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceEntity : NSObject

@property(nonatomic,copy) NSString* vendorId;

@property(nonatomic,copy) NSString* vendorShortName;

@property(nonatomic,copy) NSString* vendorFullName;

@property(nonatomic,copy) NSString* vendorDescription;

@property(nonatomic,copy) NSString* classId;

@property(nonatomic,copy) NSString* className;

@property(nonatomic,copy) NSString* classDescription;

@end
