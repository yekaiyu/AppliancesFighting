//
//  AddLightItemViewController.h
//  Appliances
//
//  Created by yekaiyu on 14-10-21.
//  Copyright (c) 2014年 yekaiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailPickerTableViewController.h"

@class LightDevicesEntity;
@class AddLightItemViewController;

@protocol LightItemDetailViewControllerDelegate <NSObject>

- (void)itemDetailViewControllerDidCancel:(AddLightItemViewController *)controller;

- (void)itemDetailViewController:(AddLightItemViewController *)controller  didFinishEditingItem:(LightDevicesEntity *)item;

- (void)itemDetailViewController:(AddLightItemViewController *)controller didFinishAddedItem:(LightDevicesEntity *) item;

@end

@interface AddLightItemViewController : UITableViewController
                        <UIActionSheetDelegate,
                         UINavigationBarDelegate,
                         UIImagePickerControllerDelegate,
                         didFinishDetailPickerDelegate>

@property(nonatomic , weak) IBOutlet UITextField* nameField;

@property(nonatomic , weak) IBOutlet UITextField* locationField;

@property(nonatomic , weak) IBOutlet UITextView* simpleDescription;

@property(nonatomic , weak) IBOutlet UIImageView* lightItemImageView;

@property(nonatomic , weak) IBOutlet UILabel* vendorLabel;

@property(nonatomic , weak) IBOutlet UILabel* classLabel;

@property(nonatomic , weak) IBOutlet UILabel* modelLabel;

@property(nonatomic , weak) IBOutlet UILabel* driverLabel;

@property(nonatomic , weak) IBOutlet UILabel* functionalLabel;

@property(nonatomic , weak) id<LightItemDetailViewControllerDelegate> delegate;

@property(nonatomic , weak) LightDevicesEntity* editLightItem;

-(IBAction)addLightItemDone;

-(IBAction)cancel;

-(IBAction)openMenu;

@end
