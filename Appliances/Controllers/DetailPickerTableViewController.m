//
//  DetailPickerTableViewController.m
//  Appliances
//
//  Created by yekaiyu on 14-10-24.
//  Copyright (c) 2014年 yekaiyu. All rights reserved.
//

#import "DetailPickerTableViewController.h"
#import "NetService.h"
#import "DeviceEntity.h"

static NSOperationQueue* queue = nil;

@interface DetailPickerTableViewController ()

@end

@implementation DetailPickerTableViewController
{
    NSMutableArray *items;
    NSIndexPath *selectedIndexPath;
    BOOL isLoading;
    MBProgressHUD* HUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //todo for all detail info
    
    [self requestJSON];
    
    
    if(isLoading){
        
        [self showHud];
        
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [items count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    
    DeviceEntity *vendor = [items objectAtIndex:indexPath.row];
    
    //todo with a bug for choose;
    if([self.type isEqualToString:@"VendorPicker"]){
       
        cell.textLabel.text = vendor.vendorName;
        cell.detailTextLabel.text = vendor.vendorDescription;
        
    }else if ([self.type isEqualToString:@"ClassPicker"]){
    
        cell.textLabel.text = vendor.className;
        cell.detailTextLabel.text = vendor.classDescription;
    
    }else if ([self.type isEqualToString:@"ModelPicker"]){
    
    
    
    }else if ([self.type isEqualToString:@"DriverPicker"]){
    
    
    
    }else if ([self.type isEqualToString:@"FunctionalPicker"]){
            
            
            
    }
    
    if ([vendor.vendorId isEqualToString:self.selectedDeviceEntity.vendorId]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        selectedIndexPath = indexPath;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.delegate didFinishDetailPicker:self WithVendorItem:[items objectAtIndex:indexPath.row] WithType:self.type];
    
}

- (void)requestJSON
{
    isLoading = YES;
    
    NSURL* url = [self urlWithCategory];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    //basic authentication
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"dev", @"pass"];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn]];
    //NSLog(@"authValue:%@",authValue);
    
    [request valueForHTTPHeaderField:authValue];
    
//    AFJSONRequestOperation* operation = [AFJSONRequestOperation
//                                         JSONRequestOperationWithRequest:request
//                                         success:^(NSURLRequest* request,NSHTTPURLResponse* response,id JSON){
//                                             
//                                             [self parseDictionary:JSON];
//                                             
//                                             [self hudWasHidden:HUD];
//                                             isLoading = NO;
//                                      
//                                             [self.tableView reloadData];
//                                             
//                                         } failure:^(NSURLRequest* request,NSURLResponse* response,NSError* error,id JSON){
//                                             
//                                             isLoading = NO;
//                                         
//                                             NSLog(@"request fail... %@",error);
//                                             
//                                         }];
//    
//    
//    
//    operation.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",nil];
//    
//    queue = [[NSOperationQueue alloc] init];
//    
//    [queue addOperation:operation];
    
}

-(void)parseDictionary:(NSDictionary *)JSON
{
    items = [[NSMutableArray alloc] initWithCapacity:[JSON count]];
    
    if([self.type isEqualToString:@"VendorPicker"]){
        
        for(NSDictionary *resultDict in JSON){
            
            DeviceEntity* deviceEntity = [[DeviceEntity alloc] init];
            
            deviceEntity.vendorId = [resultDict objectForKey:@"id"];
            
            deviceEntity.vendorName = [resultDict objectForKey:@"shortName"];
            
            deviceEntity.vendorDescription = [resultDict objectForKey:@"description"];
            
            deviceEntity.name = [resultDict objectForKey:@"fullNameName"];
            
            [items addObject:deviceEntity];
            
        }
        
    }else if ([self.type isEqualToString:@"ClassPicker"]){
        
        for(NSDictionary *resultDict in JSON){
            
            DeviceEntity* deviceEntity = [[DeviceEntity alloc] init];
            
            deviceEntity.classId = [resultDict objectForKey:@"id"];
            
            deviceEntity.className = [resultDict objectForKey:@"name"];
            
            deviceEntity.classDescription = [resultDict objectForKey:@"description"];
            
            [items addObject:deviceEntity];
        }
        
    }else if ([self.type isEqualToString:@"ModelPicker"]){
        
        
        
    }else if ([self.type isEqualToString:@"DriverPicker"]){
        
        
        
    }else if ([self.type isEqualToString:@"FunctionalPicker"]){
        
        
        
    }
    
    
}

-(NSURL *)urlWithCategory
{
    
    NSString* urlString;
    
    NSArray* languages = [NSLocale preferredLanguages];
    
    NSString* currentLanguage = [languages objectAtIndex:0];
    
    
    if([self.type isEqualToString:@"VendorPicker"]){
        
        urlString = [NSString stringWithFormat:@"http://www.driverstack.com:8080/yunos/api/1.0/vendors?locale=%@", currentLanguage];
        
    }else if ([self.type isEqualToString:@"ClassPicker"]){
        
        if([currentLanguage isEqualToString:@"zh-Hans"]){
            
            currentLanguage = @"zh_CN";
        }
        
        urlString = [NSString stringWithFormat:@"http://www.driverstack.com:8080/yunos/api/1.0/deviceClasses?vendor=%@&locale=%@",self. selectedDeviceEntity.vendorId,currentLanguage];
        
    }else if ([self.type isEqualToString:@"ModelPicker"]){
        
      //  urlString = [NSString stringWithFormat:@"http://www.driverstack.com:8080/yunos/api/1.0/vendors?locale=%@", currentLanguage];
        
    }else if ([self.type isEqualToString:@"DriverPicker"]){
        
      //  urlString = [NSString stringWithFormat:@"http://www.driverstack.com:8080/yunos/api/1.0/vendors?locale=%@", currentLanguage];
        
    }else if ([self.type isEqualToString:@"FunctionalPicker"]){
        
       // urlString = [NSString stringWithFormat:@"http://www.driverstack.com:8080/yunos/api/1.0/vendors?locale=%@", currentLanguage];
        
    }
    
    return [NSURL URLWithString:urlString];
}

- (void)showHud
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
