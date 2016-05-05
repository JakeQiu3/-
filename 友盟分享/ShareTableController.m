//
//  ShareTableController.m
//  友盟分享
//
//  Created by qsy on 15/9/5.
//  Copyright (c) 2015年 QSY. All rights reserved.
//

#import "ShareTableController.h"
#import "UMSocial.h"
#import "AboutViewController.h"

static NSString *const shareTableIdentifier = @"reuseIdentifier";

@interface ShareTableController ()<UMSocialUIDelegate,UIAlertViewDelegate>

@property (nonatomic, retain)NSArray *array;

@end

@implementation ShareTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = @[@"关于我们",@"分享",@"清除缓存"];
    self.array = array;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:shareTableIdentifier];
       // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shareTableIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}

//给cell添加点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    关于
    if (indexPath.row == 0) {
        AboutViewController *pVC = [[AboutViewController alloc] init];
        pVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:pVC animated:YES completion:^{
            
        }];
    }
//    分享
    if (indexPath.row == 1) {
        
    [UMSocialSnsService presentSnsIconSheetView:self
    appKey:@"717515489" shareText:@"友盟社会化分享让您快速实现分享等社会化功能，http://www.bbbb.com/"
    shareImage:[UIImage imageNamed:@"999"]
    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToFacebook,nil]
    delegate:self];
        
}
//    清除缓存
    if (indexPath.row == 2) {
        
        NSString *path=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path1=[path stringByAppendingPathComponent:@"/友盟分享/长尾理论.pdf"];//@"长尾理论.pdf"   @"友盟分享"
        NSLog(@"%@",path1);
        float size=[self fileSizeAtPath:path1];
        
        if(size == 0){
            [self showAlertView];
        }else{
            NSString *str = [NSString stringWithFormat:@"当前缓存为%.2fM 是否清除缓存", size];
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    }
}


//获取文件夹下的所有文件大小
- (float )folderSizeAtPath:(NSString*) folderPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}
//单个文件夹的大小
- (float) fileSizeAtPath:(NSString*) filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    long long singleFileSize = 0;
    if ([manager fileExistsAtPath:filePath]){
        singleFileSize = [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        return singleFileSize/(1024.0*1024.0);
    }
    return 0;
}
//size为0时,提示无内存可清理
-(void)showAlertView{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有可清除的内存" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {//确定按钮
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *path=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path1=[path stringByAppendingPathComponent:@"/友盟分享/长尾理论.pdf"];
        
        NSError *error;
        [fileManager removeItemAtPath:path1 error:&error];
        if ([fileManager fileExistsAtPath:path1]) {
            NSLog(@"移除失败");
        } else {
            NSLog(@"移除成功");
        }
    } else {
        return;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
