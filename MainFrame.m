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
    NSString *pbdate,*username,*telshort;
    UILabel* lbltodayxzduty;
    UILabel* lbltodayduty;
}
@synthesize currentElement;
-(void)viewDidLoad{
 //   self.view.backgroundColor=[UIColor orangeColor];
    UITabBarItem* tabBarItem=[[UITabBarItem alloc]initWithTitle:@"今日信息" image:nil tag:101];
 //   tabBarItem.image=[UIImage imageNamed:@"tabitem.png"];
   // tabBarItem.badgeValue=@"2";
    self.tabBarItem=tabBarItem;
    self.view.backgroundColor=[UIColor whiteColor];
    lbltodayduty=[[UILabel alloc]init];
    lbltodayduty.frame=CGRectMake(130, 40, 180, 50);
    
    NSString *webServiceBodyStr = [NSString stringWithFormat:
                                   @"<gettodayduty xmlns=\"http://tempuri.org/\"></gettodayduty>"];//这里是参数
    NSString *webServiceStr = [NSString stringWithFormat:
                               @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body />%@</soap:Envelope>",
                               webServiceBodyStr];//webService头
    NSURL *url = [NSURL URLWithString:@"http://183.64.36.130:8090/webservice/webservice1.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [webServiceStr length]];
    
    //ad required headers to the request
    [theRequest addValue:@"183.64.36.130:8090" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/gettodayduty" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [webServiceStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    
    _connect=[NSURLConnection connectionWithRequest:theRequest delegate:self];
    _data=[[NSMutableData alloc] init];
    lbltodayxzduty=[[UILabel alloc]init];
    lbltodayxzduty.frame=CGRectMake(140, 70, 180, 50);
    [self.view addSubview:lbltodayxzduty];
    [self.view addSubview:lbltodayduty];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
        
        
        //    NSLog(@"isok is %i",isok+"");
    }
    if ([currentElement isEqualToString:@"telshort"]) {
        telshort=string;
        
        
        //    NSLog(@"isok is %i",isok+"");
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //  NSLog(@"Parsed Element : %@", currentElement);
}
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    lbltodayxzduty.text=[[NSString alloc]initWithFormat:@"%@(%@)",username,telshort];
    lbltodayduty.text=[[NSString alloc]initWithFormat:@"今日值班(%@)",pbdate];
                         
}

@end
