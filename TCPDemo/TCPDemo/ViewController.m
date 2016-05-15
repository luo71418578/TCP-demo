//
//  ViewController.m
//  TCPDemo
//
//  Created by qianfeng on 14-2-13.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
   //文本域设置代理,为了回收键盘
   mIPField.delegate=self;
   mContentFiled.delegate=self;
   
   
	//初始化数组
   mArray =[[NSMutableArray alloc]init];
   
   //创建客户端对象
   mSendSocket=[[AsyncSocket alloc]initWithDelegate:self];
   //创建服务端对象
   mRecevieSocket=[[AsyncSocket alloc]initWithDelegate:self];
   
   //服务端,在5678端口监听有没有客户端进行连接
   [mRecevieSocket acceptOnPort:5678 error:nil];
}

//服务端监听到了有客户端  的连接请求,保存套接字,以便以后使用
-(void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
   NSLog(@"收到连接请求");
   //保存新生成的套接字
   [mArray addObject:newSocket];
   //继续监听客户端  发送信息
   [newSocket  readDataWithTimeout:-1 tag:0];
}

//连接成功调用
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
   NSLog(@"连接成功");
}

//监听到客户端  发送的消息
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
   NSLog(@"收到了消息");
   NSString *str=[[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]autorelease];
   mTextView.text=[NSString stringWithFormat:@"%@%@:%@",mTextView.text,sock.connectedHost,str];
   
   //继续监听
   [sock readDataWithTimeout:-1 tag:0];
}

//客户端
//按下按钮,连接到服务端
- (IBAction)connectToHost:(id)sender
{
   NSLog(@"连接");
   //如果已经连接,先断开
   if (mSendSocket.isConnected)
   {
      [mSendSocket disconnect];
   }
   //断开完后,再连接服务端
   //[mSendSocket connectToHost:mIPField.text onPort:5678 error:nil];
   [mSendSocket connectToHost:mIPField.text onPort:5678 withTimeout:30 error:nil];
}

//按下按钮,发送消息
- (IBAction)sendMessage:(id)sender
{
   //想要发送,要把字符串转成数据
   NSData *data=[mContentFiled.text dataUsingEncoding:NSUTF8StringEncoding];
   //然后发送
   [mSendSocket writeData:data withTimeout:30 tag:0];
   
   //发送完毕,显示数来
   mTextView.text=[NSString stringWithFormat:@"内容:%@\n",mContentFiled.text];
//mContentFiled.text=@"发送完毕,请重新发送";
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
   [textField resignFirstResponder];
   return YES;
}


//发出消息调用
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"-----------didWrite");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
   [mIPField release];
   [mContentFiled release];
   [mTextView release];
   [super dealloc];
}

@end
