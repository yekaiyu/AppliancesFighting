//
//  APPRequestJSON.m
//  Appliances
//
//  Created by yekaiyu on 14-10-28.
//  Copyright (c) 2014年 yekaiyu. All rights reserved.
//

#import "APPRequestJSON.h"
#import "AFJSONRequestOperation.h"
#import "MBProgressHUD.h"
#import "LightDevicesEntity.h"

static NSOperationQueue* queue = nil;

@implementation APPRequestJSON{
    
    MBProgressHUD* HUD;
    
}


- (void)requestJSON:(NSString *)requestUrl completion:(RequestBlock)block
{
    self.isLoading = YES;
    
    NSURL* url = [self urlWithCategory:0 withRequestURL:requestUrl];
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
                                             self.isLoading = NO;
                                             block(YES);
                                             //[self hudWasHidden:self.HUD];
                                             //[self reloadData];
                                             
                                         } failure:^(NSURLRequest* request,NSURLResponse* response,NSError* error,id JSON){
                                             
                                             self.isLoading = NO;
                                             block(NO);
                                             [self showNetWorkError:error];
                                             NSLog(@"request fail... %@",error);
                                             
                                         }];
    
    
    
    operation.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",nil];
    
    
    queue = [[NSOperationQueue alloc] init];
    
    [queue addOperation:operation];
    
}

- (NSString *)getCurrentLanguage
{
    
    
    NSArray* languages = [NSLocale preferredLanguages];
    
    return [languages objectAtIndex:0];
    
}

- (void)showNetWorkError:(NSError *)error
{
    
    UIAlertView* alertView = [[UIAlertView alloc]
                              initWithTitle:@"Error" message:[NSString stringWithFormat:@"Network Error %@",error] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [alertView show];
    
}

-(NSURL *)urlWithCategory:(NSIndexPath *)indexPath withRequestURL:(NSString*)requestURL
{
    self.currentLanguage = [self getCurrentLanguage];
    
    //NSLog(@"language : %@", currentLanguage);
    
    NSString* urlString;
    switch (indexPath.row) {
        case 0:
            urlString = [NSString stringWithFormat:@"%@",requestURL];
            break;
            
    }
    
    return [NSURL URLWithString:urlString];
    
}

-(void)parseDictionary:(NSDictionary*)dictionary
{
    
    self.items = [[NSMutableArray alloc] initWithCapacity:[dictionary count]];
    
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
        
        [self.items addObject:lightEntity];
        
    }
    
}

-(void)showHUD:(UIViewController *)controller WithMBProgressHUDMode:(MBProgressHUDMode)hudMode
{
    
    HUD = [[MBProgressHUD alloc] initWithView:controller.navigationController.view];
    [controller.navigationController.view addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = hudMode;
    
    HUD.delegate = controller;
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


-(void)hideHUD:(UIViewController *)controller
{
    
    [HUD removeFromSuperview];
    HUD = nil;
    
}


@end
