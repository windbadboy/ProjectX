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
    NSString *pbdate,*username,*telshort,*pbrole,*tel;
    UILabel* lbltodayxzduty;    //行政值班
    UILabel* lbltodaylcduty;    //临床值班
    UILabel* lbltodayduty;
    UIButton* checkbox;
    NSTimer *timer;
    NSMutableArray *mArray;
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
        NSLog(@"connect successfully!");
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
        
        
            NSLog(@"isok is %@",username);
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
        
        
            NSLog(@"isok is %@",pbrole);
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
            
            todayduty *dutyinfo=[[todayduty alloc]init];
            dutyinfo.username=username;
            dutyinfo.tel=tel;
            dutyinfo.pbrole=pbrole;
            dutyinfo.pbdate=pbdate;
            dutyinfo.telshort=telshort;
            [mArray addObject:dutyinfo];
            //  NSLog(@"%@",[mArray description]);
        }
    
}
-(void)parserDidEndDocument:(NSXMLParser *)parser
{

    lbltodayduty.text=[[NSString alloc]initWithFormat:@"今日值班(%@)",pbdate];
    int count=[mArray count];
    NSLog(@"count is %d",count);
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
-(void)viewDidAppear:(BOOL)animated
{
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
    lbltodayduty.frame=CGRectMake(110, 60, 180, 50);
    
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
    lbltodayxzduty=[[UILabel alloc]init];   //行政值班
    lbltodayxzduty.frame=CGRectMake(100, 120, 280, 50);
    UIImage* xzzb=[UIImage imageNamed:@"xzzb.png"];
    UIImageView* xzzbview=[[UIImageView alloc]init];
    xzzbview.image=xzzb;
    xzzbview.frame=CGRectMake(30, 125, 40, 40);
    lbltodaylcduty=[[UILabel alloc] init];
    lbltodaylcduty.frame=CGRectMake(100, 220, 280, 50);
    UIImage* lczb=[UIImage imageNamed:@"lczblogo.png"];
    UIImageView* lczbview=[[UIImageView alloc] init];
    lczbview.image=lczb;
     lczbview.frame=CGRectMake(30, 225, 40, 40);
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
}
-(void)checkboxClick
{
    NSLog(@"backbutton clicked.");
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"willdisappear");
}
@end
