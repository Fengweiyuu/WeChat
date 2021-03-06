//
//  ZNBAddChatMessageController.m
//  ZNBCos
//
//  Created by mac on 2017/5/25.
//  Copyright © 2017年 CoderZNBmm. All rights reserved.
//

#import "ZNBAddChatMessageController.h"

@interface ZNBAddChatMessageController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UILabel *indicateLabel;

@end

@implementation ZNBAddChatMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.indicateLabel.text = self.conversationModel.from;
    [self setupNav];
}
- (IBAction)switchClick:(UISwitch *)sender {
    if (sender.isOn) {
        self.indicateLabel.text = self.conversationModel.from;
    }else {
        self.indicateLabel.text = self.conversationModel.to;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupNav {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveImageText)];
}

- (void)saveImageText {
    RLMRealm *realm = [RLMRealm defaultRealm];
    ZNBChatConversationModel *model = [ZNBChatConversationModel objectForPrimaryKey:self.conversationModel.conversationID];
    NSDate *date = [NSDate date];
    NSString *messageID = [NSString stringWithFormat:@"%f",[date timeIntervalSince1970]];
    ZNBChatMessageModel *messageModel = [[ZNBChatMessageModel alloc] init];
    messageModel.messageID = messageID;
    messageModel.messageContent = self.textView.text;
    messageModel.conversationID = model.conversationID;
    messageModel.userType = self.switchBtn.isOn?0:1;
    [realm transactionWithBlock:^{
        [model.messageArr addObject:messageModel];
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.textView endEditing:YES];
    [self.textView resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textView endEditing:YES];
    [self.textView resignFirstResponder];
}
@end
