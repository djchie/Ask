
//
//  CameraViewController.m
//  Ask
//
//  Created by Dinh Ho on 4/4/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    


	// Do any additional setup after loading the view.
    
}

-(void)viewDidAppear:(BOOL)animated
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePicker animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)takePhoto:(id)sender
//{
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    picker.allowsEditing = YES;
//    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    
//    [self presentViewController:picker animated:YES completion:nil];
//}
//
//- (IBAction)selectPhoto:(id)sender
//{
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    picker.allowsEditing = YES;
//    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    
//    [self presentViewController:picker animated:YES completion:nil];
//}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //User took picture and pressed "Use Photo" button
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        //NSData send to next view through segue
        self.takenPicture = UIImagePNGRepresentation(editedImage);
        
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //User pressed cancel -> should move to next view as no picture option
    
}

@end
