//
//  ViewController.m
//  ProjectX
//
//  Created by ted on 16/6/30.
//  Copyright © 2016年 ted. All rights reserved.
//

#import "ViewController.h"

#import "NSString+MD5.h"
#import "VCSecond.h"
#import "VCThird.h"
#import "VCNotification.h"
@interface ViewController ()

@end

@implementation ViewController
{
    int isok;
    NSString *userid,*username;
    UIButton *checkbox;
}

@synthesize celsiusText,currentElement;

-(NSString*)getuserid
{
    return userid;
}
- (IBAction)sendX:(id)sender {
    
    [celsiusText resignFirstResponder];
    NSString *mypw=_pwfield.text;
    NSString *myuserid=_idfield.text;
    mypw=[mypw MD5String];
    //first create the soap envelope
 //   NSString *soapMessage=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body /><checklogin xmlns=\"http://tempuri.org/\"><userid>0392</userid><pwd>202cb962ac59075b964b07152d234b70</pwd></checklogin></soap:Envelope>",celsiusText.text];

    
    NSString *webServiceBodyStr = [NSString stringWithFormat:
                                   @"<checklogin xmlns=\"http://tempuri.org/\"><userid>%@</userid><pwd>%@</pwd></checklogin>",myuserid,mypw];//这里是参数
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
    [theRequest addValue: @"http://tempuri.org/checklogin" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [webServiceStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    
    _connect=[NSURLConnection connectionWithRequest:theRequest delegate:self];
    _data=[[NSMutableData alloc] init];
 

    
}
//如果有任何连接错误,调用此协议,进行错误的打印查看.
//P1:连接对象
//P2:错误信息
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error=%@",error);
}
//处理服务器响应码
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* res=(NSHTTPURLResponse*) response;
    if(res.statusCode==200)
    {
        NSLog(@"connect successfully!");
    [_data setLength:0];
    }
    else
        NSLog(@"The wrong code is %i",res.statusCode);
    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];

}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString* str=[[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
  //  NSLog(@"%@",str);
    //now parsing the xml
    
    NSData *myData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:myData];
    
    //setting delegate of XML parser to self
    xmlParser.delegate = self;
    
    // Run the parser
    @try{
        BOOL parsingResult = [xmlParser parse];
     //   NSLog(@"parsing result = %hhd",parsingResult);
    }
    @catch (NSException* exception)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Server Error" message:[exception reason] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if(isok==1)
    {
        NSString *logintips=[NSString stringWithFormat:@"欢迎登录,%@(%@)",username,userid];

        UIAlertView* alert1 = [[UIAlertView alloc]initWithTitle:@"提示" message:logintips delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert1 show];

        
    }
    else
    {

        
        UIAlertView* alert1 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名或密码不正确." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert1 show];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(isok==1)
    {
        if(checkbox.selected)
        {
        NSString *passWord=_tfPassword.text;
        NSUserDefaults *userpw=[NSUserDefaults standardUserDefaults];
        [userpw setObject:passWord forKey:@"userPassWord"];
        NSUserDefaults *userID=[NSUserDefaults standardUserDefaults];
        [userID setObject:userid forKey:@"userID"];
            NSUserDefaults *isrm=[NSUserDefaults standardUserDefaults];
            [isrm setObject:@"1" forKey:@"isrm"];

        }
        else
        {
            NSUserDefaults *isrm=[NSUserDefaults standardUserDefaults];
            [isrm setObject:@"0" forKey:@"isrm"];
        }
        MainFrame *mainView=[[MainFrame alloc]init];
            VCSecond *vcSecond=[[VCSecond alloc]init];
    VCThird *vcThrid=[[VCThird alloc]init];
        VCNotification *vcNotification=[[VCNotification alloc]init];
        vcNotification.title=@"通知";
        mainView.title=@"今日值班";
        vcSecond.title=@"我的值班";
        vcThrid.title=@"调班";
        vcSecond.firstValue=userid;
        //将self赋值给代理对象mydelegate
      //  vcSecond.view.backgroundColor=[UIColor whiteColor];
        vcSecond.mydelegate=self;
      //  vcSecond.view.backgroundColor=[UIColor whiteColor];
            UITabBarController* tbController=[[UITabBarController alloc]init];
        NSArray* arrayVC=[NSArray arrayWithObjects:mainView, vcSecond,vcNotification,vcThrid,nil];
        tbController.viewControllers=arrayVC;
        tbController.selectedIndex=0;
        tbController.tabBar.translucent=NO;
        
        [self presentViewController:tbController animated:YES completion:nil];
      //  [self.navigationController pushViewController:tbController animated:YES];
    }

}

//Implement the NSXmlParserDelegate methods
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:
(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    currentElement = elementName;
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    string=[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([currentElement isEqualToString:@"Isok"]) {
        if([string isEqualToString:@"true"])
        {
            isok=1;
        }
        else
        {
            isok=0;
        }
        

    //    NSLog(@"isok is %i",isok+"");
   }
    if ([currentElement isEqualToString:@"userid"]) {
        userid=string;

        
        //    NSLog(@"isok is %i",isok+"");
    }
    if ([currentElement isEqualToString:@"username"]) {
        username=string;

        
        //    NSLog(@"isok is %i",isok+"");
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
  //  NSLog(@"Parsed Element : %@", currentElement);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor whiteColor];
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"选项框.png"]];
    CGRect rx=[UIScreen mainScreen].bounds;
    imageView.frame=rx;
    [self.view addSubview:imageView];
   // UIImage *bgImage=[UIImage imageNamed:@"选项框.png"];
  //  self.view.backgroundColor=[UIColor colorWithPatternImage:bgImage];
    _lbUserName=[[UILabel alloc] init];
    _lbUserName.frame=CGRectMake(20, 180, 80, 40);
    _lbUserName.text=@"用户名";
    _lbUserName.font=[UIFont systemFontOfSize:15];
    _lbUserName.textAlignment=NSTextAlignmentLeft;
    
    
    _lbTitle=[[UILabel alloc] init];
    _lbTitle.frame=CGRectMake(40, 30, 320, 40);
    _lbTitle.text=@"十三院值班记录系统";
    _lbTitle.font=[UIFont systemFontOfSize:25];
    _lbTitle.textAlignment=NSTextAlignmentCenter;


    _lbPassword=[[UILabel alloc] init];
    _lbPassword.frame=CGRectMake(20, 290, 80, 40);
    _lbPassword.text=@"密码";
    _lbPassword.font=[UIFont systemFontOfSize:15];
    _lbPassword.textAlignment=NSTextAlignmentLeft;
    
    _tfUsername=[[UITextField alloc] init];
    _tfUsername.frame=CGRectMake(120, 180, 180, 40);
    _tfUsername.placeholder=@"输入工号或手机号";
    _tfUsername.borderStyle=UITextBorderStyleRoundedRect;
    _tfUsername.keyboardType=UIKeyboardTypeNumberPad;
    
    
    _tfPassword=[[UITextField alloc] init];
    _tfPassword.frame=CGRectMake(120, 270, 180, 40);
    _tfPassword.placeholder=@"输入密码";
    _tfPassword.borderStyle=UITextBorderStyleRoundedRect;
    _tfPassword.secureTextEntry=YES;
    
    _btLogin=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btLogin.frame=CGRectMake(310, 370, 80, 40);
    [_btLogin setTitle:@"登录" forState:UIControlStateNormal];
    [_btLogin addTarget:self action:@selector(pressLogin) forControlEvents:UIControlEventTouchUpInside];
    checkbox= [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect checkboxRect = CGRectMake(220,370,36,36);
    [checkbox setFrame:checkboxRect];
    [checkbox setImage:[UIImage imageNamed:@"checkbox_off.png"] forState:UIControlStateNormal];
    [checkbox setImage:[UIImage imageNamed:@"checkbox_on.png"] forState:UIControlStateSelected];
    [checkbox addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *rememberme=[[UILabel alloc]init];
    rememberme.frame=CGRectMake(256, 365, 60, 46);
    rememberme.text=@"记住我";
    NSUserDefaults *isrm=[NSUserDefaults standardUserDefaults];
    NSString *isrm1=[isrm objectForKey:@"isrm"];

    if([isrm1 isEqualToString:@"1"])
    {
                  //      NSLog(@"isrm1 value is %@",isrm1);
        checkbox.selected=true;
    NSUserDefaults *userpw=[NSUserDefaults standardUserDefaults];
    _tfPassword.text=[userpw objectForKey:@"userPassWord"];
    NSUserDefaults *userID=[NSUserDefaults standardUserDefaults];
    _tfUsername.text=[userID objectForKey:@"userID"];
    }


    
    
    
    [self.view addSubview:rememberme];
    [self.view addSubview:checkbox];
    [self.view addSubview:_lbUserName];
   // [self.view addSubview:_lbTitle];
    [self.view addSubview:_lbPassword];
    [self.view addSubview:_tfUsername];
    [self.view addSubview:_tfPassword];
        [self.view addSubview:_btLogin];
}
-(void)checkboxClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
}

-(void)pressLogin
{
    

    NSString *myuserid=_tfUsername.text;
    NSString *mypw=_tfPassword.text;
//    NSLog(@"plain pw is %@",mypw);
    mypw=[mypw MD5String];
    //first create the soap envelope
    //   NSString *soapMessage=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body /><checklogin xmlns=\"http://tempuri.org/\"><userid>0392</userid><pwd>202cb962ac59075b964b07152d234b70</pwd></checklogin></soap:Envelope>",celsiusText.text];
  //  NSLog(@"%@",mypw);
    
    NSString *webServiceBodyStr = [NSString stringWithFormat:
                                   @"<checklogin xmlns=\"http://tempuri.org/\"><userid>%@</userid><pwd>%@</pwd></checklogin>",myuserid,mypw];//这里是参数
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
    [theRequest addValue: @"http://tempuri.org/checklogin" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [webServiceStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    
    _connect=[NSURLConnection connectionWithRequest:theRequest delegate:self];
    _data=[[NSMutableData alloc] init];
}

//处理键盘收回
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_tfUsername resignFirstResponder];
    [_tfPassword resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
