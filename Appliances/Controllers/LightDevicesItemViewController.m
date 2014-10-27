//
//  LightDevicesItemViewController.m
//  Appliances
//
//  Created by yekaiyu on 14-10-20.
//  Copyright (c) 2014年 yekaiyu. All rights reserved.
//

#import "LightDevicesItemViewController.h"
#import "DevicesItemsTableViewCell.h"
#import "AFJSONRequestOperation.h"
#import "LightDevicesEntity.h"
#import "AddLightItemViewController.h"


static NSOperationQueue* queue = nil;

@interface LightDevicesItemViewController ()

@end

@implementation LightDevicesItemViewController{
    
    NSMutableArray* items;
    BOOL isLoading;
    NSString* currentLanguage;
    NSString * DocumentsPath;
    
    MBProgressHUD *HUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    DocumentsPath = [paths objectAtIndex:0];
    
    [self requestJSON];
    
    if(isLoading){
        
        //[self showSpinner];
        [self showHud];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [items count];
    
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DevicesItemsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceItemCell"];
    
    LightDevicesEntity* item = [items objectAtIndex:indexPath.row];
    
    [self configDevicesItemsTableViewCell:cell withLigthItem:item];

    if(item.deviceState){

        cell.lightSwitch.on = NO;
    }else{
        cell.lightSwitch.on = YES;
    }
    return cell;
    
}

- (void)showSpinner
{
    
    UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    spinner.color = [UIColor blackColor];
    
    spinner.center = CGPointMake(CGRectGetMidX(self.tableView.bounds), CGRectGetMidY(self.tableView.bounds)/1.5f);
    
    spinner.tag = 1000;
    
    [self.view addSubview:spinner];
    
    [spinner startAnimating];
    
}

-(void)hideSpinner
{
    
    [[self.view viewWithTag:1000] removeFromSuperview];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"LightItemDetailSegue" sender:[items objectAtIndex:indexPath.row]];
    
    //[tableView deselectRowAtIndexPath:indexPath animated:nil];
    
}



- (void)itemDetailViewController:(AddLightItemViewController *)controller didFinishAddedItem:(LightDevicesEntity *)item
{
    
    int newRowIndex = (int)[items count];
    
    [items addObject:item];
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    
    NSArray* indexPaths = [NSArray arrayWithObject:indexPath];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)itemDetailViewController:(AddLightItemViewController *)controller didFinishEditingItem:(LightDevicesEntity *)item
{

    int index = (int)[items indexOfObject:item];
    
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

- (void)requestJSON
{
    isLoading = YES;
    
    NSURL* url = [self urlWithCategory:0];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    
    //basic authentication
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"jackding", @"pass"];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn]];
    
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
 
    AFJSONRequestOperation* operation = [AFJSONRequestOperation
                                         JSONRequestOperationWithRequest:request
                                         success:^(NSURLRequest* request,NSHTTPURLResponse* response,id JSON){
                                             
                                             [self parseDictionary:JSON];
                                             isLoading = NO;
                                             [self hudWasHidden:HUD];
                                             [self.tableView reloadData];
                                             
                                         } failure:^(NSURLRequest* request,NSURLResponse* response,NSError* error,id JSON){
                                             
                                             isLoading = NO;
                                             [self showNetWorkError:error];
                                             NSLog(@"request fail... %@",error);
                                             
                                         }];
    

    
    operation.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",nil];

    
    queue = [[NSOperationQueue alloc] init];
    
    [queue addOperation:operation];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [items removeObjectAtIndex:indexPath.row];
    
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


- (void)showNetWorkError:(NSError *)error
{
    
    UIAlertView* alertView = [[UIAlertView alloc]
                              initWithTitle:@"Error" message:[NSString stringWithFormat:@"Network Error %@",error] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [alertView show];
    
}

-(NSURL *)urlWithCategory:(NSIndexPath *)indexPath
{
    currentLanguage = [self getCurrentLanguage];
    
    //NSLog(@"language : %@", currentLanguage);
    
    NSString* urlString;
    switch (indexPath.row) {
        case 0:
            urlString = @"http://www.driverstack.com:8080/yunos/api/1.0/devices?userId=jackding";
            break;
            
    }
    
    return [NSURL URLWithString:urlString];
    
}


- (NSString *)getCurrentLanguage
{
    
    
    NSArray* languages = [NSLocale preferredLanguages];
    
    return [languages objectAtIndex:0];
    
}


-(void)parseDictionary:(NSDictionary*)dictionary
{
    
    items = [[NSMutableArray alloc] initWithCapacity:[dictionary count]];
    
    for (NSDictionary* resultDict in dictionary){
        
        LightDevicesEntity* lightEntity = [[LightDevicesEntity alloc] init];
        
        lightEntity.lightId = [resultDict objectForKey:@"id"];
        
        lightEntity.modelId = [resultDict objectForKey:@"modelId"];
        
        lightEntity.deviceClassId = [resultDict objectForKey:@"deviceClassId"];
        
        lightEntity.vendorId = [resultDict objectForKey:@"vendorId"];
        
        lightEntity.hardwareType = [resultDict objectForKey:@"hardwareType"];
        
        lightEntity.revision = [resultDict objectForKey:@"revision"];
        
        lightEntity.mfgSeriaNumber = [resultDict objectForKey:@"mfgSerialNumber"];
        
        lightEntity.factoryConfigure = [resultDict objectForKey:@"factoryConfigure"];
        
        lightEntity.userConfigure = [resultDict objectForKey:@"userConfigure"];
        
        lightEntity.deviceState = [resultDict objectForKey:@"deviceState"];
        
        lightEntity.name = [resultDict objectForKey:@"name"];
        
        lightEntity.location = [resultDict objectForKey:@"location"];
        
        lightEntity.itemDescription = [resultDict objectForKey:@"description"];
        
        lightEntity.itemDescription = [resultDict objectForKey:@"driverId"];
        
        lightEntity.defaultFunctionalDeviceIndex = (long)[resultDict objectForKey:@"defaultFunctionalDeviceIndex"];
        
        [items addObject:lightEntity];
        
    }
    
}

- (void)showHud
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    
    // myProgressTask uses the HUD instance to update progress
    [HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
}

- (void)myProgressTask {
    // This just increases the progress indicator in a loop
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        HUD.progress = progress;
        usleep(50000);
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    HUD = nil;
}

@end
