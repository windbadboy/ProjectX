//
//  VCSecond.m
//  ProjectX
//
//  Created by ted on 16/7/11.
//  Copyright © 2016年 ted. All rights reserved.
//

#import "VCSecond.h"

@implementation VCSecond
{
    int isok;
    NSString *userid,*roleid;
        NSString *pbdate,*username,*rolename,*myweekday;
    NSMutableArray *mArray;
}

@synthesize currentElement;


-(void)viewDidLoad
{
    self.view.backgroundColor=[UIColor whiteColor];

    NSString *deleuserid=[self.mydelegate getuserid];
    //NSLog(@"deleuserid is %@",deleuserid);
    mArray=[NSMutableArray arrayWithCapacity:20];
    //p1视图位置,p2数据视图的风格

    
    NSString *webServiceBodyStr = [NSString stringWithFormat:
                                   @"<getrunningpbk xmlns=\"http://tempuri.org/\"><userid>%@</userid><roleid>%@</roleid></getrunningpbk>",_firstValue,@"2"];//这里是参数
    NSString *webServiceStr = [NSString stringWithFormat:
                               @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body />%@</soap:Envelope>",
                               webServiceBodyStr];//webService头
    
    
  //  NSLog(@"firstvalue is %@",_firstValue);
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://183.64.36.130:8090/webservice/webservice1.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [webServiceStr length]];
    
    //ad required headers to the request
    [theRequest addValue:@"183.64.36.130:8090" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/getrunningpbk" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [webServiceStr dataUsingEncoding:NSUTF8StringEncoding]];
   // NSLog(@"the firstvalue is %@",_firstValue);
    //initiate the request
    
    _connect=[NSURLConnection connectionWithRequest:theRequest delegate:self];
    _data=[[NSMutableData alloc] init];

}
//获取每组元素的个数(行数)
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //返回行数
    return [mArray count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //返回组数,最终行数:组数*行数
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellStr=@"cell";
    UITableViewCell* cell=[_tableView dequeueReusableCellWithIdentifier:cellStr];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellStr];
    }
    
    mydutyinfo *dutyinfo=[[mydutyinfo alloc]init];
   // NSLog(@"%@",[mArray count]);
    dutyinfo=[mArray objectAtIndex:indexPath.row];
        NSString* str=[NSString stringWithFormat:@"%@  %@   %@",dutyinfo.myusername,dutyinfo.myweekday,dutyinfo.mypbdate];
        cell.textLabel.text=str;
    //子标题
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",dutyinfo.myrolename];
    //图片
    NSString* str1=[NSString stringWithFormat:@"tabitem.png"];
    UIImage* image=[UIImage imageNamed:str1];
    UIImageView *iView=[[UIImageView alloc] initWithImage:image];
    cell.imageView.image=image;
   // NSLog(@"%@",mArray[0]);
        return cell;
    
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"选中单元格:%d,%d",indexPath.section,indexPath.row);
    
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
    if ([currentElement isEqualToString:@"username"]) {
        username=string;
        
        
        //    NSLog(@"isok is %i",isok+"");
    }
    if ([currentElement isEqualToString:@"rolename"]) {
        rolename=string;
        
        
        //    NSLog(@"isok is %i",isok+"");
    }
    if ([currentElement isEqualToString:@"myweekday"]) {
        myweekday=string;
        
        
        //    NSLog(@"isok is %i",isok+"");
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //  NSLog(@"Parsed Element : %@", currentElement);
    if ([elementName isEqualToString:@"mypbinfo"]) {

        
        
        //    NSLog(@"isok is %i",isok+"");

    mydutyinfo *dutyinfo=[[mydutyinfo alloc]init];
    dutyinfo.myuserid=userid;
    dutyinfo.myusername=username;
    dutyinfo.myrolename=rolename;
    dutyinfo.myweekday=myweekday;
    dutyinfo.mypbdate=pbdate;
    [mArray addObject:dutyinfo];
      //  NSLog(@"%@",[mArray description]);
        }
}
-(void)parserDidEndDocument:(NSXMLParser *)parser
{

 //    NSLog(@"%@",username);
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 40, 320, 536) style:UITableViewStylePlain];

    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
}
//每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
//标题
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"                           我的值班";
}
//头部高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}

@end
