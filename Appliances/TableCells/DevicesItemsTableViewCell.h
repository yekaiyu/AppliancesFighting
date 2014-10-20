//
//  DevicesItemsTableViewCell.h
//  Appliances
//
//  Created by yekaiyu on 14-10-20.
//  Copyright (c) 2014年 yekaiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DevicesItemsTableViewCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel* itemName;

@property (nonatomic,weak) IBOutlet UILabel* itemLoation;

@property (nonatomic,weak) IBOutlet UILabel* itemStatus;

@end
