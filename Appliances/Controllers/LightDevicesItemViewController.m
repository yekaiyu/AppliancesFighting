//
//  LightDevicesItemViewController.m
//  Appliances
//
//  Created by yekaiyu on 14-10-20.
//  Copyright (c) 2014年 yekaiyu. All rights reserved.
//

#import "LightDevicesItemViewController.h"
#import "DevicesItemsTableViewCell.h"

@interface LightDevicesItemViewController ()

@end

@implementation LightDevicesItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DevicesItemsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceItemCell"];
    
    cell.itemName.text = @"BedRoom Light";
    
    cell.itemLoation.text = @"BedRoom";
    
    cell.itemStatus.text = @"off";
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:nil];
    
}

@end
