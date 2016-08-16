//
//  VCDutylogwrite.m
//  ProjectX
//
//  Created by ted on 16/8/16.
//  Copyright © 2016年 ted. All rights reserved.
//

#import "VCDutylogwrite.h"


@interface VCDutylogwrite ()

@end

@implementation VCDutylogwrite
{
        UIButton *checkbox;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView=[[UITableView alloc] init];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    self.view.backgroundColor=[UIColor whiteColor];
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make)
     {
         make.width.equalTo(self.view);
         make.left.equalTo(self.view);
         make.top.equalTo(self.view).offset(30);
         make.height.equalTo(self.view);
     }];
    checkbox=[UIButton buttonWithType:UIButtonTypeCustom];
    CGRect checkboxRect = CGRectMake(10, 30, 30, 20);
    // checkbox.frame=CGRectMake(10, 30, 30, 20);
    [checkbox setFrame:checkboxRect];
    [checkbox setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [checkbox setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateSelected];
    [checkbox addTarget:self action:@selector(checkboxClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:checkbox];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //返回行数
    return 2;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //返回组数,最终行数:组数*行数
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellStr=@"cell";
    VCtestCell* cell=[_tableView dequeueReusableCellWithIdentifier:cellStr];
    if(cell==nil)
    {
        cell=[[VCtestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    switch (indexPath.row) {
        case 0:
        {
            _data1 = [NSMutableArray arrayWithObjects: @"在岗情况",@"在岗", @"部分在岗", nil];
            _data2 = [NSMutableArray arrayWithObjects: @"着装",@"按规定着装", @"未按规定着装", nil];
            [cell setarray1:_data1 setarray2:_data2];
        }
            break;
        case 1:
        {
            _data1 = [NSMutableArray arrayWithObjects: @"危重处理",@"无特殊", @"存在问题", nil];
            _data2 = [NSMutableArray arrayWithObjects: @"服务态度",@"无不良反映", @"有投诉", nil];
            [cell setarray1:_data1 setarray2:_data2];
            break;
        }
            
        default:
            break;
    }

    
    return cell;
    
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}
//每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"填写值班日志";
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)checkboxClick
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
