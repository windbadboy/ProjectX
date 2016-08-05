//
//  VCNotification.m
//  ProjectX
//
//  Created by ted on 16/7/11.
//  Copyright © 2016年 ted. All rights reserved.
//

#import "VCNotification.h"

@implementation VCNotification
{
    NSString *sendtime,*username,*mytitle,*mybody;
    BOOL isOpen;
    NSString *notificationid;
        NSMutableArray *mArray;
    NSString *noteid;
    NSMutableString *str1,*str2;
    UIButton *checkbox;
}
@synthesize currentElement,firstValue;
-(void)resetfirstvalue:(NSString *)badgevalue
{
   // self.firstValue=badgevalue;
    self.tabBarItem.badgeValue=badgevalue;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[badgevalue intValue]];
    self.firstValue=badgevalue;
}


-(void)viewDidLoad{

    
    
    
    
    //存入sqlite数据库
    
    //从数据库中加载到viewtablecell
    
    
    
    
    
    
    

//    BOOL isClose=[noteDB close];
//    if(isClose)
//    {
//        NSLog(@"关闭数据库成功.");
//    }
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
      //  NSLog(@"didfinishLoading %@",[NSThread currentThread]);
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
    //    NSString* sendtime,username,notificationid,mytitle,mybody;
    string=[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([currentElement isEqualToString:@"sendtime"]) {
        
        sendtime=string;
        
        //    NSLog(@"isok is %i",isok+"");
    }
    if ([currentElement isEqualToString:@"username"]) {
        username=string;
        
        
        //    NSLog(@"isok is %i",isok+"");
    }
    if ([currentElement isEqualToString:@"mytitle"]) {

        [str1 appendString:string];
        
        
          //  NSLog(@"title is %@",mytitle);
    }
    if ([currentElement isEqualToString:@"mybody"]) {
        [str2 appendString:string];
                //    NSLog(@"body is %@",str2);

    }
    if ([currentElement isEqualToString:@"notificationid"]) {
        notificationid=string;
                   // NSLog(@"the note id is %@",string);
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //  NSLog(@"Parsed Element : %@", currentElement);
    if ([elementName isEqualToString:@"shownote"]) {

        if([noteid intValue]<[notificationid intValue])
        {
        if(isOpen)
        {

            //        NSString* strCreateTable=@"create table if not exists mynotification (id integer primary key autoincrement,notificationid integer,notificationtitle text,notificationbody text,username text,userid text,notificationtype integer,expiredtime integer,isread integer,senddate text)";
            NSString* strInert=[NSString stringWithFormat:@"insert into mynotification(notificationid,notificationtitle,notificationbody,username,isread,senddate) values(%@,'%@','%@','%@',%d,'%@')",notificationid,str1,str2,username,0,sendtime] ;
            BOOL isOK=[noteDB executeUpdate:strInert];
            if(isOK)
            {
             //   NSog(@"插入数据成功.");
                        str1=[[NSMutableString alloc]init];
                        str2=[[NSMutableString alloc]init];
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
    

    NSString* strQuery=@"select * from mynotification order by notificationid desc;";
    if(isOpen)
    {
        FMResultSet* result=[noteDB executeQuery:strQuery];

        while([result next])
        {
            noteinfo* mynoteinfo=[[noteinfo alloc]init];
            mynoteinfo.mytitle=[result stringForColumn:@"notificationtitle"];
            mynoteinfo.mybody=[result stringForColumn:@"notificationbody"];
            mynoteinfo.myusername=[result stringForColumn:@"username"];
            mynoteinfo.sendtime=[result stringForColumn:@"senddate"];
            mynoteinfo.notificationid=[result stringForColumn:@"notificationid"];
            mynoteinfo.isread=[result stringForColumn:@"isread"];
            [mArray addObject:mynoteinfo];
           //  noteinfo* mynoteinfo2=[[noteinfo alloc]init];
         //   mynoteinfo2=[mArray objectAtIndex:1];
            
          //  NSLog(@"db field is %@",mynoteinfo.mybody);
        }
    }
        BOOL isClose=[noteDB close];
        if(isClose)
        {
          //  NSLog(@"关闭数据库成功.");
        }
    
      //  NSLog(@"%@",username);
    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];

    
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
    
    noteinfo *mynoteinfo=[[noteinfo alloc]init];
   //  NSLog(@"%@",[mArray count]);
    mynoteinfo=[mArray objectAtIndex:indexPath.row];
               // NSLog(@"db field is %@",mynoteinfo.mytitle);
    NSString* str=[NSString stringWithFormat:@"%@  ",mynoteinfo.mytitle];
    cell.textLabel.text=str;
    //子标题
    NSString* str1;
    if([mynoteinfo.isread intValue]==0)
    {
    cell.detailTextLabel.text=[NSString stringWithFormat:@"发送者:%@(%@)         未读",mynoteinfo.myusername,mynoteinfo.sendtime];
            str1=[NSString stringWithFormat:@"fold.png"];
    }
    else
    {
    cell.detailTextLabel.text=[NSString stringWithFormat:@"发送者:%@(%@)         已读",mynoteinfo.myusername,mynoteinfo.sendtime];
            str1=[NSString stringWithFormat:@"unfold.png"];
    }
    //图片

    UIImage* image=[UIImage imageNamed:str1];
    UIImageView *iView=[[UIImageView alloc] initWithImage:image];
    cell.imageView.image=image;
    if(mynoteinfo.isread)
    {
        cell.textLabel.textColor=[UIColor blackColor];
    }
    else{
        cell.textLabel.textColor=[UIColor orangeColor];
    }
    
    // NSLog(@"%@",mArray[0]);
    return cell;
    
}

//tabview click event
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //  NSLog(@"选中单元格:%d,%d",indexPath.section,indexPath.row);
    DetailNote* dn=[[DetailNote alloc]init];
    noteinfo *mynoteinfo=[[noteinfo alloc]init];
    mynoteinfo=[mArray objectAtIndex:indexPath.row];
    dn.firstValue=mynoteinfo.notificationid;
    dn.delegate=self;
    dn.badgeValue=self.firstValue;
    dn.userid=self.userid;
    [self presentViewController:dn animated:YES completion:nil];
    //[self.navigationController pushViewController:dn animated:YES];
    
}
//每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
//标题
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"                                   通知";
}
-(void)viewDidAppear:(BOOL)animated
{
    checkbox=[UIButton buttonWithType:UIButtonTypeCustom];
    CGRect checkboxRect = CGRectMake(10, 30, 30, 20);
    // checkbox.frame=CGRectMake(10, 30, 30, 20);
    [checkbox setFrame:checkboxRect];
    [checkbox setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [checkbox setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateSelected];
    [checkbox addTarget:self action:@selector(checkboxClick) forControlEvents:UIControlEventTouchUpInside];
    UITabBarItem* tabBarItem=[[UITabBarItem alloc]initWithTitle:@"通知" image:nil tag:103];
    tabBarItem.image=[UIImage imageNamed:@"note.png"];
    if([self.firstValue intValue]==0)
    {
        tabBarItem.badgeValue=nil;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        //    NSLog(@"app icon test to 0");
    }
    else
    {
        tabBarItem.badgeValue=self.firstValue;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[self.firstValue intValue]];
        //    NSLog(@"app icon test tp %@",self.firstValue);
        
    }
    str1=[[NSMutableString alloc]init];
    str2=[[NSMutableString alloc]init];
    mytitle=@"";
    self.tabBarItem=tabBarItem;
    
    mArray=[NSMutableArray arrayWithCapacity:10];
    self.view.backgroundColor=[UIColor whiteColor];
    //NSHomeDirectory获取手机app沙盒路径
    NSString* strPath=[NSHomeDirectory() stringByAppendingString:@"/Documents/db01.db"];
    //创建并打开数据库
    //如果没有数据库,创建指定的数据库
    //如果有同名数据库,则打开数据库,加载数据库到内存
    noteDB=[FMDatabase databaseWithPath:strPath];
    if(noteDB!=nil)
    {
     //   NSLog(@"database created successfully.");
    }
    isOpen=[noteDB open];
    if(isOpen)
    {
      //  NSLog(@"打开数据库成功.");
        NSString* strCreateTable=@"create table if not exists mynotification (id integer primary key autoincrement,notificationid integer,notificationtitle text,notificationbody text,username text,userid text,notificationtype integer,expiredtime integer,isread integer,senddate text)";
        BOOL isCreate=[noteDB executeUpdate:strCreateTable];
        if(isCreate)
        {
            //   NSLog(@"数据表创建成功.");
            // NSString* strDelete=@"delete from mynotification;";
            //   [noteDB executeUpdate:strDelete];
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
    
    //通过webservice获取通知信息
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
    NSOperationQueue *operationQueue=[[NSOperationQueue alloc]init];
   // NSLog(@"didwillappear %@",[NSThread currentThread]);
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:operationQueue];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:theRequest];
    //execute
    [dataTask resume];
   // _connect=[NSURLConnection connectionWithRequest:theRequest delegate:self];
    _data=[[NSMutableData alloc] init];

}
-(void)checkboxClick
{
 //   NSLog(@"backbutton clicked.");
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
        NSString* str=[[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
        //  NSLog(@"%@",str);
        //now parsing the xml
       // NSLog(@"didCompleteWithError %@",[NSThread currentThread]);
        NSData *myData = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:myData];
        
        //setting delegate of XML parser to self
        xmlParser.delegate = self;
        
        // Run the parser
        @try{
            [xmlParser parse];
            //   NSLog(@"parsing result = %hhd",parsingResult);
        }
        @catch (NSException* exception)
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Server Error" message:[exception reason] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return;
        }
    }
}
-(void)updateUI
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 60, 420, 536) style:UITableViewStylePlain];
    [_tableView setSeparatorColor:[UIColor orangeColor]];    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:checkbox];
    [self.view addSubview:_tableView];
}
@end
