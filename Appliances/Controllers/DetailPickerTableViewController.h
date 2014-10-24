//
//  DetailPickerTableViewController.h
//  Appliances
//
//  Created by yekaiyu on 14-10-24.
//  Copyright (c) 2014年 yekaiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceEntity.h"

@class DetailPickerTableViewController;

@protocol didFinishDetailPickerDelegate <NSObject>

- (void)didFinishDetailPicker:(DetailPickerTableViewController *)controller WithVendorItem:(DeviceEntity *)vendor WithType:(NSString *)type;

@end

@interface DetailPickerTableViewController : UITableViewController

@property(nonatomic,weak) id<didFinishDetailPickerDelegate> delegate;

@property(nonatomic,strong) DeviceEntity* selectedDeviceEntity;

@property(nonatomic,strong) NSString* type;

@end
