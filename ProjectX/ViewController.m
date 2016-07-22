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
     NSString *sendtime,*mytitle,*mybody;
    NSString *notificationid;
    NSMutableArray *mArray;
    NSString *noteid;
    BOOL isOpen;
    int getnote;
        NSMutableString *strtitle,*strbody;
}

@synthesize celsiusText,currentElement;

-(NSString*)getuserid
{
    return userid;
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
   //     NSLog(@"connect successfully!");
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
        //getnote==0表示第一次登陆验证,==1表示已经验证成功,需要读取xml通知
        if(getnote==0)
        {
        NSString *logintips=[NSString stringWithFormat:@"欢迎登录,%@(%@)",username,userid];

        UIAlertView* alert1 = [[UIAlertView alloc]initWithTitle:@"提示" message:logintips delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert1 show];
        }
        else
        {
            
        }

        
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
  //  VCThird *vcThrid=[[VCThird alloc]init];
        vcNotification=[[VCNotification alloc]init];
        
    //    vcThrid.title=@"调班";

        vcSecond.firstValue=userid;
        vcNotification.userid=userid;
        //将self赋值给代理对象mydelegate
       // vcSecond.view.backgroundColor=[UIColor whiteColor];
        vcSecond.mydelegate=self;
        //vcNotification.view.backgroundColor=[UIColor whiteColor];
        UITabBarItem* tabBarItem=[[UITabBarItem alloc]initWithTitle:@"我的值班" image:nil tag:102];
        tabBarItem.image=[UIImage imageNamed:@"clock.png"];
        vcSecond.tabBarItem=tabBarItem;
        UITabBarItem* tabBarItem2=[[UITabBarItem alloc]initWithTitle:@"通知" image:nil tag:103];
        tabBarItem2.image=[UIImage imageNamed:@"note.png"];
     tabBarItem2.image=[UIImage imageNamed:@"note.png"];
        vcNotification.tabBarItem=tabBarItem2;

            UITabBarController* tbController=[[UITabBarController alloc]init];
        NSArray* arrayVC=[NSArray arrayWithObjects:mainView, vcSecond,vcNotification,nil];
        tbController.viewControllers=arrayVC;
       // tbController.selectedIndex=0;
        tbController.tabBar.translucent=NO;
        [tbController setDelegate:self];
        
        getnote=1;
    //    [self.navigationController pushViewController:tbController animated:YES];
        [self presentViewController:tbController animated:YES completion:nil];
        //  [self.navigationController pushViewController:tbController animated:YES];
        NSString *webServiceBodyStr = [NSString stringWithFormat:
                                       @"<getnotification xmlns=\"http://tempuri.org/\"></getnotification>"];//这里是参数
        NSString *webServiceStr = [NSString stringWithFormat:
                                   @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body />%@</soap:Envelope>",
                                   webServiceBodyStr];//webService头
        NSURL *url = [NSURL URLWithString:@"http://183.64.36.130:8090/webservice/webservice1.asmx"];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *msgLength = [NSString stringWithFormat:@"%d", [webServiceStr length]];
        
        //ad required headers to the request
        [theRequest addValue:@"183.64.36.130:8090" forHTTPHeaderField:@"Host"];
        [theRequest addValue: @"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [theRequest addValue: @"http://tempuri.org/getnotification" forHTTPHeaderField:@"SOAPAction"];
        [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setHTTPBody: [webServiceStr dataUsingEncoding:NSUTF8StringEncoding]];
        // NSLog(@"the firstvalue is %@",_firstValue);
        //initiate the request
        
        _connect=[NSURLConnection connectionWithRequest:theRequest delegate:self];
        _data=[[NSMutableData alloc] init];
        
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
    if ([currentElement isEqualToString:@"sendtime"]) {
        
        sendtime=string;
        
        //    NSLog(@"isok is %i",isok+"");
    }
    if ([currentElement isEqualToString:@"mytitle"]) {
                [strtitle appendString:string];
        
        
        //    NSLog(@"isok is %i",isok+"");
    }
    if ([currentElement isEqualToString:@"mybody"]) {
        [strbody appendString:string];
     //   NSLog(@"body is %@",strbody);
        
    }
    if ([currentElement isEqualToString:@"notificationid"]) {
        notificationid=string;
        //  NSLog(@"the note id is %@",string);
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"shownote"]) {
        
        if([noteid intValue]<[notificationid intValue])
        {
            if(isOpen)
            {
                
                //        NSString* strCreateTable=@"create table if not exists mynotification (id integer primary key autoincrement,notificationid integer,notificationtitle text,notificationbody text,username text,userid text,notificationtype integer,expiredtime integer,isread integer,senddate text)";
                NSString* strInert=[NSString stringWithFormat:@"insert into mynotification(notificationid,notificationtitle,notificationbody,username,isread,senddate) values(%@,'%@','%@','%@',%d,'%@')",notificationid,strtitle,strbody,username,0,sendtime] ;
                BOOL isOK=[noteDB executeUpdate:strInert];
                if(isOK)
                {
                  //  NSLog(@"插入数据成功.");
                    strtitle=[[NSMutableString alloc]init];
                    strbody=[[NSMutableString alloc]init];
                    
                }
                else
                {
                    NSLog(@"插入数据失败.");
                }
            }
            
            
        }
        //  NSLog(@"%@",[mArray description]);
    }
}
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
if(getnote==1)
{
    int mycount = [noteDB intForQuery:@"SELECT COUNT(*) FROM mynotification where isread=0"];
    if(mycount==0)
    {
        vcNotification.tabBarItem.badgeValue=nil;
    }
    else
    {
    vcNotification.tabBarItem.badgeValue=[[NSString alloc]initWithFormat:@"%d",mycount];
    //    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
      //  localNotification.applicationIconBadgeNumber = mycount;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:mycount];
    }
    vcNotification.firstValue=[[NSString alloc]initWithFormat:@"%d",mycount];
    BOOL isClose=[noteDB close];
    if(isClose)
    {
    //    NSLog(@"关闭数据库成功.");
    }
}
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    strtitle=[[NSMutableString alloc]init];
    strbody=[[NSMutableString alloc]init];
    self.view.backgroundColor=[UIColor whiteColor];
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
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
    getnote=0;
    //NSHomeDirectory获取手机app沙盒路径
    NSString* strPath=[NSHomeDirectory() stringByAppendingString:@"/Documents/db01.db"];
    //创建并打开数据库
    //如果没有数据库,创建指定的数据库
    //如果有同名数据库,则打开数据库,加载数据库到内存
    noteDB=[FMDatabase databaseWithPath:strPath];
    if(noteDB!=nil)
    {
       // NSLog(@"database created successfully.");
    }
    isOpen=[noteDB open];
    if(isOpen)
    {
      //  NSLog(@"打开数据库成功.");
        NSString* strCreateTable=@"create table if not exists mynotification (id integer primary key autoincrement,notificationid integer,notificationtitle text,notificationbody text,username text,userid text,notificationtype integer,expiredtime integer,isread integer,senddate text)";
        BOOL isCreate=[noteDB executeUpdate:strCreateTable];
        if(isCreate)
        {
          //  NSLog(@"数据表创建成功.");
            // NSString* strDelete=@"delete from mynotification;";
            // [noteDB executeUpdate:strDelete];
            NSString* strQuery=@"select * from mynotification order by notificationid desc limit 0,1;";
            FMResultSet* result=[noteDB executeQuery:strQuery];
            while([result next])
            {
                noteid=[result stringForColumn:@"notificationid"];
                // NSLog(@"noteid is %@",noteid);
            }
            
            
        }
        else
        {
            NSLog(@"数据表创建失败");
        }
        
    }

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

//切换分栏时触发.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //indexoftab表示第几个分栏,0,1,2
NSUInteger indexOfTab = [tabBarController.viewControllers indexOfObject:viewController];
  //  NSLog(@"Tab index = %u", (int)indexOfTab);
}

@end
