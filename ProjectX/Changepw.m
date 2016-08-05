//
//  Changepw.m
//  ProjectX
//
//  Created by ted on 16/7/31.
//  Copyright © 2016年 ted. All rights reserved.
//

#import "Changepw.h"

@implementation Changepw
{
        UIButton *checkbox;
    int x;
}


-(void)viewDidLoad
{
    x=0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarOrientationChange)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    checkbox=[UIButton buttonWithType:UIButtonTypeCustom];
  //  CGRect checkboxRect = CGRectMake(10, 30, 30, 20);
    // checkbox.frame=CGRectMake(10, 30, 30, 20);
  //  [checkbox setFrame:checkboxRect];
    [checkbox setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [checkbox setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateSelected];
    [checkbox addTarget:self action:@selector(checkboxClick) forControlEvents:UIControlEventTouchUpInside];
    
    _lbPassword=[[UILabel alloc] init];
    _lbPassword.text=@"输入密码";
    _lbPassword.font=[UIFont systemFontOfSize:15];
    _lbPassword.textAlignment=NSTextAlignmentLeft;
    
    
    _lbPasswordrepeat=[[UILabel alloc] init];
    _lbPasswordrepeat.text=@"重复密码";
    _lbPasswordrepeat.font=[UIFont systemFontOfSize:15];
    _lbPasswordrepeat.textAlignment=NSTextAlignmentLeft;
    
    _tfPassword=[[UITextField alloc] init];
    _tfPassword.placeholder=@"输入密码";
    _tfPassword.borderStyle=UITextBorderStyleRoundedRect;
    _tfPassword.secureTextEntry=YES;
    
    
    _tfPasswordrepeat=[[UITextField alloc] init];
    _tfPasswordrepeat.placeholder=@"重复密码";
    _tfPasswordrepeat.borderStyle=UITextBorderStyleRoundedRect;
    _tfPasswordrepeat.secureTextEntry=YES;
    
    
    _btChangepw=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    //_btLogin.frame=CGRectMake(310, 370, 80, 40);
    
    
    [_btChangepw setTitle:@"修改" forState:UIControlStateNormal];
    [_btChangepw addTarget:self action:@selector(pressChange) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    [self.view addSubview:imageView];
    [self.view addSubview:_lbPasswordrepeat];
    [self.view addSubview:_lbPassword];
    [self.view addSubview:_tfPassword];
    [self.view addSubview:_tfPasswordrepeat];
    [self.view addSubview:checkbox];
    [self.view addSubview:_btChangepw];

    UIInterfaceOrientation orientation=[[UIApplication sharedApplication]statusBarOrientation];
    if(UIInterfaceOrientationIsLandscape(orientation))
    {
        NSLog(@"横屏.");
        [_lbPasswordrepeat mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.view).offset(20);
             make.width.equalTo(@80);
             make.height.equalTo(@50);
             make.top.equalTo(self.view).offset(140);
         }];
        
        [_lbPassword mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.view).offset(20);
             make.width.equalTo(@80);
             make.height.equalTo(@50);
             make.top.equalTo(self.view).offset(80);
         }];
        [_tfPasswordrepeat mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.view).offset(120);
             make.width.equalTo(@180);
             make.height.equalTo(@40);
             make.top.equalTo(self.view).offset(140);
         }];
        [_tfPassword mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.view).offset(120);
             make.width.equalTo(@180);
             make.height.equalTo(@40);
             make.top.equalTo(self.view).offset(80);
         }];
        [checkbox mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.view).offset(8);
             make.width.equalTo(@30);
             make.height.equalTo(@30);
             make.top.equalTo(self.view).offset(16);
         }];

        
    }
    else
    {
        [_lbPasswordrepeat mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.view).offset(20);
             make.width.equalTo(@80);
             make.height.equalTo(@50);
             make.top.equalTo(self.view).offset(280);
         }];
        
        [_lbPassword mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.view).offset(20);
             make.width.equalTo(@80);
             make.height.equalTo(@50);
             make.top.equalTo(self.view).offset(180);
         }];
        [_tfPasswordrepeat mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.view).offset(120);
             make.width.equalTo(@180);
             make.height.equalTo(@40);
             make.top.equalTo(self.view).offset(280);
         }];
        [_tfPassword mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.view).offset(120);
             make.width.equalTo(@180);
             make.height.equalTo(@40);
             make.top.equalTo(self.view).offset(180);
         }];
        [checkbox mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.view).offset(8);
             make.width.equalTo(@30);
             make.height.equalTo(@30);
             make.top.equalTo(self.view).offset(16);
         }];
    }
    
    
    [_btChangepw mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.right.equalTo(self.view).offset(-16);
         make.width.equalTo(@50);
         make.height.equalTo(@50);
         make.bottom.equalTo(self.view).offset(-50);
     }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.edges.equalTo(self.view);
     }];
    
    
}

-(void)pressChange
{
    if([_tfPassword.text isEqualToString:_tfPasswordrepeat.text])
    {

    NSString *mypw=_tfPassword.text;
    //    NSLog(@"plain pw is %@",mypw);
    mypw=[mypw MD5String];
    //first create the soap envelope
    //   NSString *soapMessage=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body /><checklogin xmlns=\"http://tempuri.org/\"><userid>0392</userid><pwd>202cb962ac59075b964b07152d234b70</pwd></checklogin></soap:Envelope>",celsiusText.text];
    //  NSLog(@"%@",mypw);
    
    NSString *webServiceBodyStr = [NSString stringWithFormat:
                                   @"<changepw xmlns=\"http://tempuri.org/\"><userid>%@</userid><pw>%@</pw></changepw>",self.userid,mypw];//这里是参数
    NSString *webServiceStr = [NSString stringWithFormat:
                               @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body />%@</soap:Envelope>",
                               webServiceBodyStr];//webService头
    
    
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://183.64.36.130:8090/webservice/webservice1.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [webServiceStr length]];
    
    //ad required headers to the request
    [theRequest addValue:@"183.64.36.130:8090" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/changepw" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [webServiceStr dataUsingEncoding:NSUTF8StringEncoding]];
    
        NSThread *newthread=[[NSThread alloc] initWithTarget:self selector:@selector(justdoit:) object:theRequest];
        [newthread start];
    }
    else
    {
        x=0;
        NSString *logintips=[NSString stringWithFormat:@"密码不一致,请核对."];
        
        UIAlertView* alert1 = [[UIAlertView alloc]initWithTitle:@"出现问题" message:logintips delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert1 show];
       // UIAlertAction* alert2=[UIAlertAction actionWithTitle:@"密码不一致,请核对" style:UIAlertActionStyleDestructive handler:nil];
        

    }
    
}
-(void)justdoit:(NSMutableURLRequest*)theRequest
{
    NSOperationQueue *operationQueue=[[NSOperationQueue alloc]init];
    // NSLog(@"didwillappear %@",[NSThread currentThread]);
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:operationQueue];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:theRequest];
    //execute
    [dataTask resume];
    // _connect=[NSURLConnection connectionWithRequest:theRequest delegate:self];
    _data=[[NSMutableData alloc] init];
}
-(void)statusBarOrientationChange
{
    UIInterfaceOrientation orientation=[[UIApplication sharedApplication]statusBarOrientation];
    if(UIInterfaceOrientationIsLandscape(orientation))
    {
        NSLog(@"横屏.");
        [_lbPasswordrepeat mas_remakeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.view).offset(20);
             make.width.equalTo(@80);
             make.height.equalTo(@50);
             make.top.equalTo(self.view).offset(140);
         }];
        
        [_lbPassword mas_remakeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.view).offset(20);
             make.width.equalTo(@80);
             make.height.equalTo(@50);
             make.top.equalTo(self.view).offset(80);
         }];
        [_tfPasswordrepeat mas_remakeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.view).offset(120);
             make.width.equalTo(@180);
             make.height.equalTo(@40);
             make.top.equalTo(self.view).offset(140);
         }];
        [_tfPassword mas_remakeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.view).offset(120);
             make.width.equalTo(@180);
             make.height.equalTo(@40);
             make.top.equalTo(self.view).offset(80);
         }];

        
    }
    else
    {
        [_lbPasswordrepeat mas_remakeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.view).offset(20);
             make.width.equalTo(@80);
             make.height.equalTo(@50);
             make.top.equalTo(self.view).offset(280);
         }];
        
        [_lbPassword mas_remakeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.view).offset(20);
             make.width.equalTo(@80);
             make.height.equalTo(@50);
             make.top.equalTo(self.view).offset(180);
         }];
        [_tfPasswordrepeat mas_remakeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.view).offset(120);
             make.width.equalTo(@180);
             make.height.equalTo(@40);
             make.top.equalTo(self.view).offset(280);
         }];
        [_tfPassword mas_remakeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.view).offset(120);
             make.width.equalTo(@180);
             make.height.equalTo(@40);
             make.top.equalTo(self.view).offset(180);
         }];

    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_tfPasswordrepeat resignFirstResponder];
    [_tfPassword resignFirstResponder];
}
-(void)checkboxClick
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    completionHandler(NSURLSessionResponseAllow);
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [_data appendData:data];
}
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if(error == nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            x=1;
            NSString *logintips=[NSString stringWithFormat:@"修改密码成功."];
            
            UIAlertView* alert1 = [[UIAlertView alloc]initWithTitle:@"提示" message:logintips delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert1 show];
        });
        

    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(x==1)
    {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}
@end
