//
//  MyProfileViewController.m
//  TestSkillz
//
//  Created by Alexandru Antonica on 3/20/16.
//  Copyright © 2016 Alexandru Antonica. All rights reserved.
//

#import "MyProfileViewController.h"
#import "AFHTTPSessionManager.h"
#import "NSString+MD5.h"

static NSString *kCurrentUser = @"kCurrentUser";
static NSString *ipAddres = @"http://192.168.0.103:8090/edit/";

@interface MyProfileViewController (){
    NSUserDefaults *defaults;
}

@end

@implementation MyProfileViewController

-(void)viewWillAppear:(BOOL)animated{

    [self updatePerson];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updatePerson];
    [self.myPic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(takePhoto:)]];
    

    [self.saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)saveAction:(UIButton*)button{
    [self updateDataBase];

}

-(void)updatePerson{
    if (!self.person) {
        if (!defaults)
            defaults = [NSUserDefaults standardUserDefaults];
        
        id saved = [defaults objectForKey:kCurrentUser];
        
        if(saved){
            NSArray *customObjectArray = [NSKeyedUnarchiver unarchiveObjectWithData: saved];
            self.person = [[Person alloc] initWithPerson:customObjectArray[0]];
        }
        
    }
    
    
    self.numeTF.text = self.person.nume;
    self.prenumeTF.text = self.person.prenume;
    self.telefonTF.text = self.person.nrTelefon;
    self.tags.text = [[self.person tagsString] stringByReplacingOccurrencesOfString:@";" withString:@" "];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
    
    self.numeTF.delegate = self;
    self.prenumeTF.delegate = self;
    self.telefonTF.delegate = self;
    self.tags.delegate = self;
    
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self.saveButton setEnabled:YES];

}

-(void)textViewDidEndEditing:(UITextView *)textView{
    [self.saveButton setEnabled:YES];

}


-(void)updateDataBase{
    
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    UIActivityIndicatorView *activInd = [[UIActivityIndicatorView alloc] init];
    [self.view addSubview:activInd];
    
    CGSize size = self.view.frame.size;
    [activInd setCenter:CGPointMake(size.width/2, size.height/2)];
    
    [activInd startAnimating];

    
    NSString *url = [NSString stringWithFormat:@"%@%ld?firstName=%@&password=%@&lastName=%@&phone=%@&tags=%@&picture=loki",
                     ipAddres,
                     (long)self.person.idNumber,
        self.prenumeTF.text,
                     [self.parolaTF.text MD5String],
                     self.numeTF.text,
                     self.telefonTF.text,
                     [self.tags.text stringByReplacingOccurrencesOfString:@" " withString:@";"]
                     ];
                     ;
    [self.view setUserInteractionEnabled:NO];
    
    
    
    
    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.view setUserInteractionEnabled:YES];
        [activInd stopAnimating];

        //Present Allert
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Success" message:@"The modifications were successfully commited!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
        [self.saveButton setEnabled:NO];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        //Present Allert
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"The modifications were not commited!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        [self.view setUserInteractionEnabled:YES];
        [activInd stopAnimating];
        NSLog(@"%@",error);
        
    }];
}


-(void)endEditing:(id)sender{
    
    [self.numeTF resignFirstResponder];
    [self.prenumeTF resignFirstResponder];
    [self.telefonTF resignFirstResponder];
    [self.parolaTF resignFirstResponder];
    [self.tags resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    self.person = nil;
}


- (void)takePhoto:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)selectPhoto:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
//    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
//    self.imageView.image = chosenImage;
//    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
@end
