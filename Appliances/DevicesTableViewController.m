//
//  DevicesTableViewController.m
//  Appliances
//
//  Created by yekaiyu on 14-10-20.
//  Copyright (c) 2014年 yekaiyu. All rights reserved.
//

#import "DevicesTableViewController.h"
#import "DevicesTableViewCell.h"
#import "AFNetworking.h"
#import "LightDevicesEntity.h"
#import "LightDevicesItemViewController.h"

static NSOperationQueue* queue = nil;

@interface DevicesTableViewController (){
    
    NSMutableArray* lightItems;
    BOOL * bDevices;
}

@end

@implementation DevicesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:nil];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationItem.leftBarButtonItem.hidden = YES;
    [self.navigationController.navigationItem hidesBackButton];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController.navigationItem hidesBackButton];
}
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
    
}

@end
