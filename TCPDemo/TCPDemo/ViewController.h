//
//  ViewController.h
//  TCPDemo
//
//  Created by qianfeng on 14-2-13.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"
@interface ViewController : UIViewController
<AsyncSocketDelegate,
UITextFieldDelegate,
UITextViewDelegate>
{
   
   IBOutlet UITextField *mIPField;
   IBOutlet UITextField *mContentFiled;
   IBOutlet UITextView *mTextView;
   AsyncSocket *mSendSocket;
   AsyncSocket *mRecevieSocket;
   NSMutableArray *mArray;
   
}
- (IBAction)connectToHost:(id)sender;
- (IBAction)sendMessage:(id)sender;





@end
