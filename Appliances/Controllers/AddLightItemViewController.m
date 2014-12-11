//
//  AddLightItemViewController.m
//  Appliances
//
//  Created by yekaiyu on 14-10-21.
//  Copyright (c) 2014年 yekaiyu. All rights reserved.
//

#import "AddLightItemViewController.h"
#import "LightDevicesEntity.h"
#import "LightDevicesItemViewController.h"

@implementation AddLightItemViewController{
    UIActionSheet* myActionSheet;
    NSString* filePath;
    NSString* DocumentsPath;
}

-(void) viewDidLoad
{
    
    [super viewDidLoad];
    
    [self configEditItemView];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    //[self.nameField becomeFirstResponder];
    
}

-(IBAction)cancel
{
    
    [self.delegate itemDetailViewControllerDidCancel:self];
}

-(IBAction)addLightItemDone
{
    
    if(self.editLightItem == nil){
    
        LightDevicesEntity* lightItem = [[LightDevicesEntity alloc] init];
    
        lightItem.name = self.nameField.text;
    
        lightItem.location = self.locationField.text;
    
        lightItem.Description= self.simpleDescription.text;
    
        [self.delegate itemDetailViewController:self didFinishAddedItem:lightItem];
    
        NSLog(@"addLightcalled %@",self.delegate);
        
    }else{
        
        NSLog(@"%@",self.editLightItem);
        
        self.editLightItem.name = self.nameField.text;
        
        self.editLightItem.location = self.locationField.text;
        
        self.editLightItem.Description = self.simpleDescription.text;
        
        self.editLightItem.lightImagePath = filePath;
        
        [self.delegate itemDetailViewController:self didFinishEditingItem:self.editLightItem];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DeviceEntity* deviceEntity = [[DeviceEntity alloc] init];
    
    deviceEntity.vendorId = self.editLightItem.vendorId;
    
    deviceEntity.classId = self.editLightItem.deviceClassId;
    
    DetailPickerTableViewController* picker = segue.destinationViewController;
    
    if([segue.identifier isEqualToString:@"VendorPicker"]){
        
        picker.delegate = self;
        
        picker.selectedDeviceEntity = deviceEntity;
        
        picker.type = segue.identifier;
        
    }else if ([segue.identifier isEqualToString:@"ClassPicker"]){
        
        
        picker.delegate = self;
        
        picker.selectedDeviceEntity = deviceEntity;
        
        picker.type = segue.identifier;
        
    }else if ([segue.identifier isEqualToString:@"ModelPicker"]){
        
//        DetailPickerTableViewController* picker = segue.destinationViewController;
//        picker.delegate = self;
//        picker.selectedName = self.vendorLabel.text;
//        picker.type = segue.identifier;
        
    }else if ([segue.identifier isEqualToString:@"DriverPicker"]){
        
//        DetailPickerTableViewController* picker = segue.destinationViewController;
//        picker.delegate = self;
//        picker.selectedName = self.vendorLabel.text;
//        picker.type = segue.identifier;
//        
    }else if ([segue.identifier isEqualToString:@"FunctionalPicker"]){
        
//        DetailPickerTableViewController* picker = segue.destinationViewController;
//        picker.delegate = self;
//        picker.selectedName = self.vendorLabel.text;
//        picker.type = segue.identifier;
    }
    
}

- (void)didFinishDetailPicker:(DetailPickerTableViewController *)controller WithVendorItem:(DeviceEntity*)vendorItem WithType:(NSString *)type
{
    
    if([type isEqualToString:@"VendorPicker"]){
        
        self.vendorLabel.text = vendorItem.vendorName;
        
    }else if ([type isEqualToString:@"ClassPicker"]){
        
        self.classLabel.text = vendorItem.className;
      
    }else if ([type isEqualToString:@"ModelPicker"]){
        
  
    }else if ([type isEqualToString:@"DriverPicker"]){
        
        
    }else if ([type isEqualToString:@"FunctionalPicker"]){
        
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)openMenu
{
    
    myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open Camera",@"Open Album", nil];
    
    [myActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self LocalPhoto];
            break;
    }
    
}

- (void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        
        picker.delegate = self;
        
        //picker.allowsEditing = YES;
        
        picker.sourceType = sourceType;
        
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"error" message:@"Can't open you camera." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        
        [self.view addSubview:alert];
        
        [alert show];
        
    }
    
}

-(void)LocalPhoto
{
    
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate = self;
    
    //picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:nil];

    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image60 = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        UIImage* image120 = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        image60 = [self getImageWithSiez:image120 size:CGSizeMake(60.f, 60.f)];
        
        image120 = [self getImageWithSiez:image120 size:CGSizeMake(110.f, 130.f)];
        
        NSData *data120;
        NSData *data60;
        if (UIImagePNGRepresentation(image120) == nil)
        {
            data60 = UIImageJPEGRepresentation(image60, 1.0);
            data120 = UIImageJPEGRepresentation(image120, 1.0);
        }
        else
        {
            data60 = UIImagePNGRepresentation(image60);
            data120 = UIImagePNGRepresentation(image120);
        }
        
        [self saveImage:data120 PickerController:picker StrSize:@"120"];
        [self saveImage:data60 PickerController:picker StrSize:@"60"];
        
        self.lightItemImageView.image = image60;
        
    }
    
}

-(void)saveImage:(NSData *)data PickerController:(UIImagePickerController *)picker StrSize:(NSString*)size
{
    
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    //NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];;
    
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:
                                   [NSString stringWithFormat: @"/%@_image_%@.png",self.editLightItem.ID,size]] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,
                [NSString stringWithFormat: @"/%@_image_%@.png",self.editLightItem.ID,size]];
    NSError* error;
    
    NSLog(@"File Path : %@",filePath);
    
    if(![data writeToFile:filePath options:NSDataWritingAtomic error:&error]){
        
        NSLog(@"Error write file: %@",error);
        
    }
    //关闭相册界面
    [picker dismissModalViewControllerAnimated:YES];
    
}

- (void)configEditItemView
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    DocumentsPath = [paths objectAtIndex:0];
    
    if(self.editLightItem != nil ){
        
        self.nameField.text = self.editLightItem.name;
        
        self.locationField.text = self.editLightItem.location;
        
        if(self.editLightItem.description == nil){
            
            self.simpleDescription.text = self.editLightItem.Description;
        }else{
            self.simpleDescription.text = @"";
        }
        
        NSDictionary* hardwareType = self.editLightItem.hardwareType;
        
        self.vendorLabel.text = [hardwareType objectForKey:@"vendor"];
        
        self.modelLabel.text = [hardwareType objectForKey:@"model"];
        
        self.classLabel.text = @"";
        
        self.driverLabel.text = @"";
        
        self.functionalLabel.text = @"";
        
        UIImage* image120 = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@_image_120.png",DocumentsPath,self.editLightItem.ID]];
        
        if(image120 !=nil){
            
            self.lightItemImageView.image = image120;
            
        }
        
        NSArray* array = [NSLocale preferredLanguages];
        
        NSString* current = [array objectAtIndex:0];
        
//        if([current isEqualToString:@"en"]){
            self.title = @"Edit Light";
//        }else{
//            
//            self.title = @"编辑电灯";
//        }
        
        
    }
    
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
