//
//  MainFrame.m
//  ProjectX
//
//  Created by ted on 16/7/10.
//  Copyright © 2016年 ted. All rights reserved.
//

#import "MainFrame.h"

@implementation MainFrame
{
    NSString *pbdate,*username,*telshort,*pbrole,*tel,*zyrs;
    UILabel* lbltodayxzduty;    //行政值班
    UILabel* lbltodaylcduty;    //临床值班
    UILabel* lblzyrs;           //住院人数
    UILabel* lbltodayduty;
    UIButton* checkbox;
    NSTimer *timer;
    NSMutableArray *mArray;
    int x;
    NSTimer *_timer;
}
@synthesize currentElement;
-(void)viewDidLoad{

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  //  [self dismissViewControllerAnimated:YES completion:nil];
}



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
      //  NSLog(@"connect successfully!");
        [_data setLength:0];
    }
    else
        NSLog(@"The wrong code is %li",(long)res.statusCode);
        
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
    
}
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:
(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    currentElement = elementName;
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    string=[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([currentElement isEqualToString:@"pbdate"]) {
        
        pbdate=string;
        
        //    NSLog(@"isok is %i",isok+"");
    }
    if ([currentElement isEqualToString:@"name"]) {
        username=string;
        
        
          //  NSLog(@"isok is %@",username);
    }
    if ([currentElement isEqualToString:@"telshort"]) {
        telshort=string;
        
        
        //    NSLog(@"isok is %i",isok+"");
    }
    if ([currentElement isEqualToString:@"tel"]) {
        tel=string;
        
        
        //    NSLog(@"isok is %i",isok+"");
    }
    if ([currentElement isEqualToString:@"pbrole"]) {
        pbrole=string;
        
        
          //  NSLog(@"isok is %@",pbrole);
    }
    if ([currentElement isEqualToString:@"zyrs"]) {
        zyrs=string;
        
    //    NSLog(@"thread is %@",[NSThread currentThread]);
    //    NSLog(@"zyrs is %@",zyrs);
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
//    if([elementName isEqualToString:@"Table"])
//    {
//    if([pbrole intValue]==2)
//    {
//    lbltodayxzduty.text=[[NSString alloc]initWithFormat:@"行政值班    %@(短号:%@)",username,telshort];
//    }
//    if([pbrole intValue]==3)
//    {
//    lbltodaylcduty.text=[[NSString alloc]initWithFormat:@"临床值班    %@(短号:%@)",username,telshort];
//    }
//    }
    

        //  NSLog(@"Parsed Element : %@", currentElement);
        if ([elementName isEqualToString:@"Table"]) {
            
            
            
            //    NSLog(@"isok is %i",isok+"");
         //   NSLog(@"x is is %d",x);
            if(x==1)
            {
         //       NSLog(@"hey 1");
            todayduty *dutyinfo=[[todayduty alloc]init];
            dutyinfo.username=username;
            dutyinfo.tel=tel;
            dutyinfo.pbrole=pbrole;
            dutyinfo.pbdate=pbdate;
            dutyinfo.telshort=telshort;
            [mArray addObject:dutyinfo];
                username=@"";
                tel=@"";
              //  pbdate=@"";
                telshort=@"";
                
            }

            //  NSLog(@"%@",[mArray description]);
        }
    
}
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
   // NSLog(@"before mainthread  %d",x);

        [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:YES];
  //  NSLog(@"after mainthread  %d",x);
        
}
-(void)myreactive {
    
  //  NSLog(@"active Again!!!");
    NSString *webServiceBodyStr = [NSString stringWithFormat:
                                   @"<gettodaydutybest xmlns=\"http://tempuri.org/\"></gettodaydutybest>"];//这里是参数
    NSString *webServiceStr = [NSString stringWithFormat:
                               @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body />%@</soap:Envelope>",
                               webServiceBodyStr];//webService头
    NSURL *url = [NSURL URLWithString:@"http://183.64.36.130:8090/webservice/webservice1.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [webServiceStr length]];
    
    //ad required headers to the request
    [theRequest addValue:@"183.64.36.130:8090" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/gettodaydutybest" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [webServiceStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    
    _connect=[NSURLConnection connectionWithRequest:theRequest delegate:self];
    _data=[[NSMutableData alloc] init];

    
  //  [self setNeedsFocusUpdate];
 //   self.view.backgroundColor=[UIColor orangeColor];
}
-(void)timerFire
{
    [self justdoit];
  //  NSLog(@"justtodi zyrs is %@",zyrs);
}
-(void)viewDidDisappear:(BOOL)animated
{
    [_timer invalidate];
    lblzyrs.text=@"";
}
-(void)justdoit
{
    _data=[[NSMutableData alloc] init];   
    _data2=[[NSMutableData alloc] init];
    NSMutableArray *operations=[NSMutableArray array];
    NSMutableURLRequest *therequest=[self getrequest:@"gettodaydutybest"];
    NSMutableURLRequest *therequest2=[self getrequest:@"gettodaypeople"];
    NSURLSession *urlSession = [NSURLSession sharedSession];
    NSOperation *operation =[NSBlockOperation blockOperationWithBlock:^{
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:therequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(data)
            {
                [_data appendData:data];
            }
            if(error==nil)
            {
           //     NSLog(@"current thread is %@",[NSThread currentThread]);
                x=1;
                
                NSString* str;
                str=[[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
                //        if([session.sessionDescription isEqualToString:@"1"])
                //        {
                //           str=[[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
                //    NSLog(@"%@",str);
                //        }
                //    else if([session.sessionDescription isEqualToString:@"2"])
                //    {
                //        str=[[NSString alloc] initWithData:_data2 encoding:NSUTF8StringEncoding];
                //        NSLog(@"%@",str);
                //    }
                //now parsing the xml
                // NSLog(@"didCompleteWithError %@",[NSThread currentThread]);
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
                
                
            }
        }];
        [dataTask resume];
    }];
    [operations addObject:operation];
    NSOperation *operation2 =[NSBlockOperation blockOperationWithBlock:^{
        NSURLSessionDataTask *dataTask2 = [[NSURLSession sharedSession] dataTaskWithRequest:therequest2 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(data)
            {
                [_data2 appendData:data];
            }
            if(error==nil)
            {
                x=2;
              //  NSLog(@"current thread is %@",[NSThread currentThread]);
                NSString* str;
                str=[[NSString alloc] initWithData:_data2 encoding:NSUTF8StringEncoding];
                
                //        if([session.sessionDescription isEqualToString:@"1"])
                //        {
                //           str=[[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
                //    NSLog(@"%@",str);
                //        }
                //    else if([session.sessionDescription isEqualToString:@"2"])
                //    {
                //        str=[[NSString alloc] initWithData:_data2 encoding:NSUTF8StringEncoding];
                //        NSLog(@"%@",str);
                //    }
                //now parsing the xml
                // NSLog(@"didCompleteWithError %@",[NSThread currentThread]);
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
                
                
            }
        }];
        [dataTask2 resume];
    }];
    [operations addObject:operation2];
    
    
    NSOperationQueue* _queue=[[NSOperationQueue alloc]init];
    _queue.maxConcurrentOperationCount=1;
    [_queue addOperations:operations waitUntilFinished:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
   // NSLog(@"viewDidAppear");

  //  [_timer fire];
    

        mArray=[NSMutableArray arrayWithCapacity:20];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(myreactive)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];
   // NSLog(@"viewDidAppear");
    //   self.view.backgroundColor=[UIColor orangeColor];
    UITabBarItem* tabBarItem=[[UITabBarItem alloc]initWithTitle:@"今日值班" image:nil tag:101];
    tabBarItem.image=[UIImage imageNamed:@"duty.png"];
    // tabBarItem.badgeValue=@"2";
    self.tabBarItem=tabBarItem;
    self.view.backgroundColor=[UIColor whiteColor];
    lbltodayduty=[[UILabel alloc]init];
  //  lbltodayduty.frame=CGRectMake(110, 60, 180, 50);
    
//    NSString *webServiceBodyStr = [NSString stringWithFormat:
//                                   @"<gettodaydutybest xmlns=\"http://tempuri.org/\"></gettodaydutybest>"];//这里是参数
//    NSString *webServiceStr = [NSString stringWithFormat:
//                               @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body />%@</soap:Envelope>",
//                               webServiceBodyStr];//webService头
//    NSURL *url = [NSURL URLWithString:@"http://183.64.36.130:8090/webservice/webservice1.asmx"];
//    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
//    NSString *msgLength = [NSString stringWithFormat:@"%d", [webServiceStr length]];
//    
//    //ad required headers to the request
//    [theRequest addValue:@"183.64.36.130:8090" forHTTPHeaderField:@"Host"];
//    [theRequest addValue: @"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    [theRequest addValue: @"http://tempuri.org/gettodaydutybest" forHTTPHeaderField:@"SOAPAction"];
//    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
//    [theRequest setHTTPMethod:@"POST"];
//    [theRequest setHTTPBody: [webServiceStr dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    //initiate the request
//    
//    _connect=[NSURLConnection connectionWithRequest:theRequest delegate:self];

//    NSArray* myarray1=[[NSArray alloc]initWithObjects:@"1",@"gettodaydutybest", nil];
//    NSArray* myarray2=[[NSArray alloc]initWithObjects:@"2",@"gettodaypeople", nil];
//    NSThread *thread1=[[NSThread alloc]initWithTarget:self selector:@selector(getsth1:) object:myarray1];
//    [thread1 start];
//    NSThread *thread2=[[NSThread alloc]initWithTarget:self selector:@selector(getsth1:) object:myarray2];
//
//    [thread2 start];
 //   [self getsth:1 para:@"gettodaydutybest"];
 //   [NSThread sleepForTimeInterval:2.0];
   // [self getsth:2 para:@"gettodaypeople"];


    
    
    lbltodayxzduty=[[UILabel alloc]init];   //行政值班
   // lbltodayxzduty.frame=CGRectMake(100, 120, 280, 50);
    UIImage* xzzb=[UIImage imageNamed:@"xzzb.png"];
    UIImageView* xzzbview=[[UIImageView alloc]init];
    xzzbview.image=xzzb;
 //   xzzbview.frame=CGRectMake(30, 125, 40, 40);
    lbltodaylcduty=[[UILabel alloc] init];
  //  lbltodaylcduty.frame=CGRectMake(100, 220, 280, 50);
    UIImage* lczb=[UIImage imageNamed:@"lczblogo.png"];
    UIImageView* lczbview=[[UIImageView alloc] init];
    lczbview.image=lczb;
 //    lczbview.frame=CGRectMake(30, 225, 40, 40);
    lblzyrs=[[UILabel alloc] init];
 //   lblzyrs.frame=CGRectMake(100, 250, 280, 50);
    
    UIImage* zyrsimage=[UIImage imageNamed:@"zyrs.png"];
    UIImageView* zyrsview=[[UIImageView alloc]init];
    zyrsview.image=zyrsimage;
    UIButton* _btChangepw=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btChangepw setTitle:@"修改密码" forState:UIControlStateNormal];
    [_btChangepw addTarget:self action:@selector(changepw) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    checkbox=[UIButton buttonWithType:UIButtonTypeCustom];
    CGRect checkboxRect = CGRectMake(10, 30, 30, 20);
    // checkbox.frame=CGRectMake(10, 30, 30, 20);
    [checkbox setFrame:checkboxRect];
    [checkbox setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [checkbox setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateSelected];
    [checkbox addTarget:self action:@selector(checkboxClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:xzzbview];
    [self.view addSubview:lczbview];
    [self.view addSubview:lbltodayxzduty];
    [self.view addSubview:lbltodayduty];
    [self.view addSubview:lbltodaylcduty];
    [self.view addSubview:checkbox];
    [self.view addSubview:lblzyrs];
    [self.view addSubview:zyrsview];
    [self.view addSubview:_btChangepw];
    
    [_btChangepw mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.view).offset(0);
         make.width.equalTo(@100);
         make.height.equalTo(@40);
         make.bottom.equalTo(self.view).offset(-32);
     }];
    
    [lbltodayduty mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.equalTo(self.view);
         make.width.equalTo(@200);
         make.height.equalTo(@40);
         make.top.equalTo(self.view).offset(50);
     }];
    
    [lbltodayxzduty mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.view).offset(70);
         make.width.equalTo(@200);
         make.height.equalTo(@40);
         make.top.equalTo(self.view).offset(100);
     }];
    [xzzbview mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.view).offset(16);
         make.width.equalTo(@40);
         make.height.equalTo(@40);
         make.top.equalTo(self.view).offset(100);
     }];
    [lbltodaylcduty mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.view).offset(70);
         make.width.equalTo(@200);
         make.height.equalTo(@40);
         make.top.equalTo(self.view).offset(180);
     }];
    [lczbview mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.view).offset(16);
         make.width.equalTo(@40);
         make.height.equalTo(@40);
         make.top.equalTo(self.view).offset(180);
     }];
    
    [lblzyrs mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.view).offset(70);
         make.width.equalTo(@200);
         make.height.equalTo(@40);
         make.top.equalTo(self.view).offset(260);
     }];
    [zyrsview mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.view).offset(16);
         make.width.equalTo(@40);
         make.height.equalTo(@40);
         make.top.equalTo(self.view).offset(260);
     }];
//    [lblzyrs mas_makeConstraints:^(MASConstraintMaker *make)
//     {
//         make.left.equalTo(self.view).offset(-16);
//         make.width.equalTo(@50);
//         make.height.equalTo(@50);
//         make.bottom.equalTo(self.view).offset(-100);
//     }];
    [self justdoit];
        _timer=[NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
}
-(void)getsth1:(NSArray*)a
{
    x=[[a objectAtIndex:0] intValue];


   // NSLog(@"whichone is %d",[[a objectAtIndex:0] intValue]);
     //   NSLog(@"current thread is %@",[a objectAtIndex:1]);
   // NSLog(@"%@",[NSThread currentThread]);

    
    //通过webservice获取通知信息
    NSString *webServiceBodyStr = [NSString stringWithFormat:
                                   @"<%@ xmlns=\"http://tempuri.org/\"></%@>",[a objectAtIndex:1],[a objectAtIndex:1]];//这里是参数
    NSString *webServiceStr = [NSString stringWithFormat:
                               @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body />%@</soap:Envelope>",
                               webServiceBodyStr];//webService头
    NSURL *url = [NSURL URLWithString:@"http://183.64.36.130:8090/webservice/webservice1.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [webServiceStr length]];
    
    //ad required headers to the request
    [theRequest addValue:@"183.64.36.130:8090" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: [NSString stringWithFormat:@"http://tempuri.org/%@",[a objectAtIndex:1]] forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [webServiceStr dataUsingEncoding:NSUTF8StringEncoding]];
    // NSLog(@"the firstvalue is %@",_firstValue);
    //initiate the request

    // NSLog(@"didwillappear %@",[NSThread currentThread]);
            NSOperationQueue *operationQueue=[[NSOperationQueue alloc]init];
    [operationQueue setMaxConcurrentOperationCount:2];
    NSURLSession*  session= [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:operationQueue];
    [session setSessionDescription:[NSString stringWithFormat:@"%d",x]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:theRequest];
 //   [dataTask setTaskDescription:[NSString stringWithFormat:@"%d",x]];
    
    //execute
    [dataTask resume];


    // _connect=[NSURLConnection connectionWithRequest:theRequest delegate:self];
     

    
}
//封装HTTP报头
-(NSMutableURLRequest*)getrequest:(NSString *)myrequest
{
    NSString *webServiceBodyStr = [NSString stringWithFormat:
                                   @"<%@ xmlns=\"http://tempuri.org/\"></%@>",myrequest,myrequest];//这里是参数
    NSString *webServiceStr = [NSString stringWithFormat:
                               @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body />%@</soap:Envelope>",
                               webServiceBodyStr];//webService头
    NSURL *url = [NSURL URLWithString:@"http://183.64.36.130:8090/webservice/webservice1.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [webServiceStr length]];
    
    //ad required headers to the request
    [theRequest addValue:@"183.64.36.130:8090" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: [NSString stringWithFormat:@"http://tempuri.org/%@",myrequest] forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [webServiceStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    return theRequest;
}

//暂时未用
-(void)getsth:(int)whichone para:(NSString *)whichpara
{
    x=whichone;
   // NSLog(@"whichone is %d",x);
    //通过webservice获取通知信息
    NSString *webServiceBodyStr = [NSString stringWithFormat:
                                   @"<%@ xmlns=\"http://tempuri.org/\"></%@>",whichpara,whichpara];//这里是参数
    NSString *webServiceStr = [NSString stringWithFormat:
                               @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body />%@</soap:Envelope>",
                               webServiceBodyStr];//webService头
    NSURL *url = [NSURL URLWithString:@"http://183.64.36.130:8090/webservice/webservice1.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [webServiceStr length]];
    
    //ad required headers to the request
    [theRequest addValue:@"183.64.36.130:8090" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: [NSString stringWithFormat:@"http://tempuri.org/%@",whichpara] forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [webServiceStr dataUsingEncoding:NSUTF8StringEncoding]];
    // NSLog(@"the firstvalue is %@",_firstValue);
    //initiate the request
              //      dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSOperationQueue *operationQueue=[[NSOperationQueue alloc]init];
    // NSLog(@"didwillappear %@",[NSThread currentThread]);
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:operationQueue];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:theRequest];
   // NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:theRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        dispatch_semaphore_signal(semaphore);
 //   }];
    //execute
    [dataTask resume];
    
                _data=[[NSMutableData alloc] init];
    // _connect=[NSURLConnection connectionWithRequest:theRequest delegate:self];

}


//记住我功能
-(void)checkboxClick
{
  //  NSLog(@"backbutton clicked.");
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
   // NSLog(@"willdisappear");
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    completionHandler(NSURLSessionResponseAllow);
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    
    
   // NSLog(@"datatask is %d",dataTask.taskIdentifier);
   // NSLog(@"current thread is %@",[NSThread currentThread]);
    [_lock lock];
        [_data appendData:data];
    [_lock unlock];
//    NSLog(@"sessiondescription is %@",session.sessionDescription);
//    if([session.sessionDescription isEqualToString:@"1"])
//    {
//    [_data appendData:data];
//    }
//    else if([session.sessionDescription isEqualToString:@"2"])
//    {
//        [_data2 appendData:data];
//    }
}
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if(error == nil)
    {
        NSString* str;
         str=[[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
//        if([session.sessionDescription isEqualToString:@"1"])
//        {
//           str=[[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",str);
//        }
//    else if([session.sessionDescription isEqualToString:@"2"])
//    {
//        str=[[NSString alloc] initWithData:_data2 encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",str);
//    }
        //now parsing the xml
        // NSLog(@"didCompleteWithError %@",[NSThread currentThread]);
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

    }
    else
    {
        NSLog(@"%@",error);
    }
}
-(void)updateUI
{
   // NSLog(@"x is %d",x);
    if(x==1)
    {
    lbltodayduty.text=[[NSString alloc]initWithFormat:@"今日值班(%@)",pbdate];
    int count=[mArray count];
     //   NSLog(@"%d",count);
    for(int i=0;i<count;i++)
    {
        todayduty *tempduty=[mArray objectAtIndex:i];
        if([tempduty.pbrole intValue]==2)
        {
            if([tempduty.telshort isEqualToString:@""])
            {
                lbltodayxzduty.text=[[NSString alloc]initWithFormat:@"%@(长号:%@)",tempduty.username,tempduty.tel];
            }
            else
            {
                lbltodayxzduty.text=[[NSString alloc]initWithFormat:@"%@(短号:%@)",tempduty.username,tempduty.telshort];
            }
        }
        if([tempduty.pbrole intValue]==3)
        {
            if([tempduty.telshort isEqualToString:@""])
            {
                lbltodaylcduty.text=[[NSString alloc]initWithFormat:@"%@(长号:%@)",tempduty.username,tempduty.tel];
            }
            else
            {
                lbltodaylcduty.text=[[NSString alloc]initWithFormat:@"%@(短号:%@)",tempduty.username,tempduty.telshort];
            }
        }
        
    }
    }
    else if(x==2)
    {
        lblzyrs.font=[UIFont systemFontOfSize:13];
        lblzyrs.text=[NSString stringWithFormat:@"住院人数:%@ 床占率:%.2f%%",zyrs,[zyrs floatValue]/509*100];
    }
   
}
-(void)changepw
{
 //   NSLog(@"in changepw");
    Changepw* changePW=[[Changepw alloc]init];
    
    changePW.userid=self.userid;
    [self presentViewController:changePW animated:YES completion:nil];
}
@end
