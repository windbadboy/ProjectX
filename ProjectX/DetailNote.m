//
//  DetailNote.m
//  ProjectX
//
//  Created by ted on 16/7/21.
//  Copyright © 2016年 ted. All rights reserved.
//

#import "DetailNote.h"
@implementation DetailNote
{
        BOOL isOpen;
    noteinfo* mynoteinfo;
    NSString *username,*userid,*checktime;
            NSMutableArray *mArray;
}
@synthesize currentElement;
-(void)viewDidLoad
{
    
        mArray=[NSMutableArray arrayWithCapacity:20];
    
    
    
    
    
    
    
    
  //  [[self navigationController]popViewControllerAnimated:YES];
    
    UIButton *checkbox=[UIButton buttonWithType:UIButtonTypeCustom];
    CGRect checkboxRect = CGRectMake(10, 30, 30, 20);
   // checkbox.frame=CGRectMake(10, 30, 30, 20);
    [checkbox setFrame:checkboxRect];
    [checkbox setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [checkbox setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateSelected];
    [checkbox addTarget:self action:@selector(checkboxClick) forControlEvents:UIControlEventTouchUpInside];
    //[backButton setTitle:@"back" forState:UIControlStateNormal];
    //[backButton addTarget:self action:@selector(pressback) forControlEvents:UIControlEventTouchUpInside];
    UILabel *lbltitle=[[UILabel alloc]init];
    lbltitle.frame=CGRectMake(130, 40, 180, 50);
    UILabel *lblbody=[[UILabel alloc]init];
    //lblbody.lineBreakMode=NSLineBreakByWordWrapping;
    //lblbody.numberOfLines=0;
    //CGSize size=[lblbody sizeThatFits:CGSizeMake(lblbody.frame.size.width, MAXFLOAT)];
    //lblbody.frame=CGRectMake(lblbody.frame.origin.x, lblbody.frame.origin.y, lblbody.frame.size.width, size.height);
  //  lblbody.frame=CGRectMake(0, 70, 360, 200);
  //  lblbody.numberOfLines=0;
  //  lblbody.lineBreakMode=NSLineBreakByWordWrapping;
   // lblbody.textAlignment=NSTextAlignmentLeft;

    //  [lblbody alignTop];
    NSString* strPath=[NSHomeDirectory() stringByAppendingString:@"/Documents/db01.db"];    //创建并打开数据库
    //如果没有数据库,创建指定的数据库
    //如果有同名数据库,则打开数据库,加载数据库到内存
    noteDB=[FMDatabase databaseWithPath:strPath];
    if(noteDB!=nil)
    {
        NSLog(@"database created successfully.");
    }
    isOpen=[noteDB open];
    if(isOpen)
    {
     //   NSLog(@"打开数据库成功.");
        NSString* strCreateTable=@"create table if not exists mynotification (id integer primary key autoincrement,notificationid integer,notificationtitle text,notificationbody text,username text,userid text,notificationtype integer,expiredtime integer,isread integer,senddate text)";
        BOOL isCreate=[noteDB executeUpdate:strCreateTable];
        if(isCreate)
        {
           // NSLog(@"数据表创建成功.");
            NSString* strUpdate=[NSString stringWithFormat:@"update mynotification set isread=1 where notificationid=%@;",self.firstValue];
            BOOL ISDelete=[noteDB executeUpdate:strUpdate];
            if(ISDelete)
            {
    int mycount = [noteDB intForQuery:@"SELECT COUNT(*) FROM mynotification where isread=0"];
                if(mycount==0)
                {
                [self.delegate resetfirstvalue:nil];
                        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:mycount];
                }
                else
                {
                [self.delegate resetfirstvalue:[NSString stringWithFormat:@"%d",mycount]];
                                            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:mycount];
                }
                
          }
            NSString* strQuery=[NSString  stringWithFormat:@"select * from mynotification where notificationid=%@;",self.firstValue];
            if(isOpen)
            {
                FMResultSet* result=[noteDB executeQuery:strQuery];
                
                while([result next])
                {
                    mynoteinfo=[[noteinfo alloc]init];
                    mynoteinfo.mytitle=[result stringForColumn:@"notificationtitle"];
                    mynoteinfo.mybody=[result stringForColumn:@"notificationbody"];
                    mynoteinfo.myusername=[result stringForColumn:@"username"];
                    mynoteinfo.sendtime=[result stringForColumn:@"senddate"];
                    mynoteinfo.notificationid=[result stringForColumn:@"notificationid"];
                    mynoteinfo.isread=[result stringForColumn:@"isread"];
                    
                    //  noteinfo* mynoteinfo2=[[noteinfo alloc]init];
                    //   mynoteinfo2=[mArray objectAtIndex:1];
                
                      NSLog(@"db field is %@",mynoteinfo.mybody);
                }
                CGSize size = CGSizeMake(280, 180);
                UIFont *fonts = [UIFont systemFontOfSize:12.0];
                NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:fonts,NSFontAttributeName,nil];
              //  CGSize msgSie = [mynoteinfo.mybody sizeWithFont:fonts constrainedToSize:size lineBreakMode: NSLineBreakByCharWrapping];
                CGSize msgSie=[mynoteinfo.mybody boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
                UILabel *textLabel  = [[UILabel alloc] init];
                [textLabel setFont:[UIFont boldSystemFontOfSize:14]];
                lblbody.frame = CGRectMake(10,80, 380,msgSie.height*1.3);
                lblbody.lineBreakMode = nil;//实现文字多行显示
                lblbody.numberOfLines = 0;
                lbltitle.text=mynoteinfo.mytitle;
                lblbody.text=mynoteinfo.mybody;
                NSLog(@"mybody is %@",mynoteinfo.mybody);
                self.view.backgroundColor=[UIColor whiteColor];
                [self.view addSubview:lbltitle];
                [self.view addSubview:lblbody];

                [self.view addSubview:checkbox];

                NSString *webServiceBodyStr = [NSString stringWithFormat:
                                               @"<getchecklist xmlns=\"http://tempuri.org/\"><typeid>1</typeid><notificationid>%@</notificationid></getchecklist>",self.firstValue];//这里是参数
                NSString *webServiceStr = [NSString stringWithFormat:
                                           @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body />%@</soap:Envelope>",
                                           webServiceBodyStr];//webService头
                NSURL *url = [NSURL URLWithString:@"http://183.64.36.130:8090/webservice/webservice1.asmx"];
                NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
                NSString *msgLength = [NSString stringWithFormat:@"%d", [webServiceStr length]];
                
                //ad required headers to the request
                [theRequest addValue:@"183.64.36.130:8090" forHTTPHeaderField:@"Host"];
                [theRequest addValue: @"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
                [theRequest addValue: @"http://tempuri.org/getchecklist" forHTTPHeaderField:@"SOAPAction"];
                [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
                [theRequest setHTTPMethod:@"POST"];
                [theRequest setHTTPBody: [webServiceStr dataUsingEncoding:NSUTF8StringEncoding]];
                // NSLog(@"the firstvalue is %@",_firstValue);
                //initiate the request
                
                _connect=[NSURLConnection connectionWithRequest:theRequest delegate:self];
                _data=[[NSMutableData alloc] init];

                
            }
            BOOL isClose=[noteDB close];
            if(isClose)
            {
             //   NSLog(@"关闭数据库成功.");
            }
            
        }
        else
        {
           // NSLog(@"数据表创建失败");
        }
        
    }
}
-(void)checkboxClick
{
    NSLog(@"backbutton clicked.");
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:NO completion:nil];
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
    if ([currentElement isEqualToString:@"userid"]) {
        
        userid=string;
        
        //    NSLog(@"isok is %i",isok+"");
    }
    if ([currentElement isEqualToString:@"username"]) {
        username=string;
        
        
         //   NSLog(@"isok is %@",username);
    }
    if ([currentElement isEqualToString:@"checktime"]) {
        checktime=string;
        
        
        //    NSLog(@"isok is %i",isok+"");
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"loginresult"])
    {
        checklist *mychecklist=[[checklist alloc]init];
        mychecklist.username=username;
        mychecklist.userid=userid;
        mychecklist.checktime=checktime;
        [mArray addObject:mychecklist];

            

        //  NSLog(@"%@",[mArray description]);
    }
}
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 340, 420, 536) style:UITableViewStylePlain];
    [_tableView setSeparatorColor:[UIColor orangeColor]];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
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
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    
    checklist *mychecklist=[[checklist alloc]init];
    //  NSLog(@"%@",[mArray count]);
    mychecklist=[mArray objectAtIndex:indexPath.row];
   //  NSLog(@"db field is %@",mychecklist.username);
    NSString* str=[NSString stringWithFormat:@"%@(%@)    %@",mychecklist.username,mychecklist.userid,mychecklist.checktime];
    cell.textLabel.text=str;



    //图片
    

    
    // NSLog(@"%@",mArray[0]);
    return cell;
    
}

//tabview click event

//每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
//标题
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"                           已查看消息人员";
}

@end
