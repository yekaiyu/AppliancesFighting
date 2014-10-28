//
//  LightDevicesItemViewController.m
//  Appliances
//
//  Created by yekaiyu on 14-10-20.
//  Copyright (c) 2014年 yekaiyu. All rights reserved.
//

#import "LightDevicesItemViewController.h"
#import "DevicesItemsTableViewCell.h"
#import "LightDevicesEntity.h"
#import "AddLightItemViewController.h"
#import "APPRequestJSON.h"

static NSOperationQueue* queue = nil;

@interface LightDevicesItemViewController ()

@end

@implementation LightDevicesItemViewController{
    //NSMutableArray* items;
    NSString * DocumentsPath;
    APPRequestJSON* requestJSON;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    DocumentsPath = [paths objectAtIndex:0];
    
    requestJSON = [[APPRequestJSON alloc]init];
    
    [requestJSON requestJSON:@"http://www.driverstack.com:8080/yunos/api/1.0/devices?userId=jackding" completion:^(BOOL success) {
        if(success){
            [requestJSON hideHUD:self];
            [self.tableView reloadData];
        }
    }];
    
    if(requestJSON.isLoading){
        
        //[self showSpinner];
        [requestJSON showHUD:self WithMBProgressHUDMode:MBProgressHUDModeDeterminateHorizontalBar];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [requestJSON.items count];
    
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DevicesItemsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceItemCell"];
    
    LightDevicesEntity* item = [requestJSON.items objectAtIndex:indexPath.row];
    
    [self configDevicesItemsTableViewCell:cell withLigthItem:item];

    if(item.deviceState){

        cell.lightSwitch.on = NO;
    }else{
        cell.lightSwitch.on = YES;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"LightItemDetailSegue" sender:[requestJSON.items objectAtIndex:indexPath.row]];
    
    //[tableView deselectRowAtIndexPath:indexPath animated:nil];
    
}



- (void)itemDetailViewController:(AddLightItemViewController *)controller didFinishAddedItem:(LightDevicesEntity *)item
{
    
    int newRowIndex = (int)[requestJSON.items count];
    
    [requestJSON.items addObject:item];
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    
    NSArray* indexPaths = [NSArray arrayWithObject:indexPath];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)itemDetailViewController:(AddLightItemViewController *)controller didFinishEditingItem:(LightDevicesEntity *)item
{

    int index = (int)[requestJSON.items indexOfObject:item];
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    DevicesItemsTableViewCell* cell = (DevicesItemsTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    [self configDevicesItemsTableViewCell:cell withLigthItem:item];
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)configDevicesItemsTableViewCell:(DevicesItemsTableViewCell *)lightCell withLigthItem:(LightDevicesEntity *) item
{
    
    lightCell.itemName.text = item.name;
    
    lightCell.itemLoation.text = item.location;
    
    lightCell.lightSwitch.on = NO;
    
    lightCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TableCellGradient"]];
    
    //todo
    UIImage* image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@_image_60.png",DocumentsPath,item.lightId]];
        
    if(item.lightImagePath != nil){
       
        lightCell.imageView.image = [self getImageWithSiez:[UIImage imageWithContentsOfFile:item.lightImagePath] size:CGSizeMake(60.0f , 60.0f)];
   
        //lightCell.imageView.image = [UIImage imageWithContentsOfFile:item.lightImagePath];

    }else if (image != nil){
        
        lightCell.imageView.image = [self getImageWithSiez:image size:CGSizeMake(60.0f , 60.0f)];;
        
    }else{
        
        lightCell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
    }
}

- (void)itemDetailViewControllerDidCancel:(AddLightItemViewController *)controller
{
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"AddLightSegue"]){
        
        UINavigationController* controller = segue.destinationViewController;
        
        AddLightItemViewController* addController = (AddLightItemViewController *)controller.topViewController;
        
        addController.delegate = self;
        
    }else if ([segue.identifier isEqualToString:@"LightItemDetailSegue"]){
        
        UINavigationController* controller = segue.destinationViewController;
        
        AddLightItemViewController* addController = (AddLightItemViewController *)controller.topViewController;
        
        addController.delegate = self;
        
        addController.editLightItem = sender;
        
    }
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [requestJSON.items removeObjectAtIndex:indexPath.row];
    
    NSArray* indexPaths = [NSArray arrayWithObject:indexPath];
    
    [self removeFileForPath:(NSIndexPath *)indexPath];
    
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
 
}

- (void)removeFileForPath:(NSIndexPath *)indexPath
{
    //todo cant delete file...
    
//    LightDevicesEntity* item = [items objectAtIndex:indexPath.row];
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//
//    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
//    
//    NSError* error;
//    
//    if(![fileManager removeItemAtPath:[NSString stringWithFormat:@"%@_image_60.png",item.lightId] error:&error]){
//        
//        NSLog(@"removeFile fail...%@",error);
//    }
//    
//    if(![fileManager removeItemAtPath:[NSString stringWithFormat:@"%@_image_120.png",item.lightId]  error:&error]){
//        
//        NSLog(@"removeFile fail...%@",error);
//    }
    
}

-(UIImage *)getImageWithSiez:(UIImage *)img size:(CGSize)size
{
    
    UIGraphicsBeginImageContext(size);
    
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsPopContext();
    
    return scaledImage;
    
}
@end
