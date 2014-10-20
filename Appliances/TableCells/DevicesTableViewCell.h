//
//  DevicesTableViewCell.h
//  Appliances
//
//  Created by yekaiyu on 14-10-20.
//  Copyright (c) 2014年 yekaiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DevicesTableViewCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIImageView* deviceImage;

@property (nonatomic,weak) IBOutlet UILabel* deviceItemName;

@end
