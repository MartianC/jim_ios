//
//  JXCustomSysNotificationViewController.m
//

#import "JXCustomSysNotificationViewController.h"
#import "NIMContactSelectViewController.h"
#import "JXCustomSysNotificationSender.h"
#import "UIAlertView+JXBlock.h"
#import "JXCustomNotificationDB.h"
#import "NSDictionary+JXJson.h"
#import "JXCustomNotificationObject.h"
#import "UIActionSheet+JXBlock.h"
#import "JXNotificationCenter.h"
#import "JXCustomSysNotificationSender.h"

#define FetchLimit 10
static NSString *reuseIdentifier = @"reuseIdentifier";

@interface JXCustomSysNotificationViewController ()<NIMContactSelectDelegate>

@property (nonatomic,strong) NSMutableArray *data;

@property (nonatomic,assign) NIMSessionType sendSessionType;

@property (nonatomic,strong) JXCustomSysNotificationSender *sender;

@end

@implementation JXCustomSysNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    JXCustomNotificationDB *db = [JXCustomNotificationDB sharedInstance];
    self.data = [[db fetchNotifications:nil limit:FetchLimit] mutableCopy];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [db markAllNotificationsAsRead];
    extern NSString *JXCustomNotificationCountChanged;
    [[NSNotificationCenter defaultCenter] postNotificationName:JXCustomNotificationCountChanged object:nil];
    
    _sender = [[JXCustomSysNotificationSender alloc] init];
}

- (void)setupNav{
    self.navigationItem.title = @"自定义系统通知";
    UIBarButtonItem *clearBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"清空"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(clearAll:)];
    
    UIBarButtonItem *addCustomNotiBarBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCustomNotification:)];
    
    self.navigationItem.rightBarButtonItems = @[clearBarBtnItem,addCustomNotiBarBtnItem];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger index = [indexPath row];
        JXCustomNotificationObject *notification = [self.data objectAtIndex:index];
        [self.data removeObjectAtIndex:index];
        JXCustomNotificationDB *db = [JXCustomNotificationDB sharedInstance];
        [db deleteNotification:notification];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    JXCustomNotificationObject *notification = [self.data objectAtIndex:[indexPath row]];
    NSString *content = notification.content;
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (data)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:nil];
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            NSString *text      = [dict jsonString:JXCustomContent];
            cell.textLabel.text = text;
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

#pragma mark - Action
- (void)addCustomNotification:(id)sender{
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"单聊",@"群组",@"超大群组", nil];
    __block NIMContactSelectViewController *vc;
    [sheet showInView:self.view completionHandler:^(NSInteger index) {
        switch (index) {
            case 0:{
                NIMContactFriendSelectConfig *config = [[NIMContactFriendSelectConfig alloc] init];
                vc = [[NIMContactSelectViewController alloc] initWithConfig:config];
                self.sendSessionType = NIMSessionTypeP2P;
                vc.delegate = self;
                break;
            }
            case 1:{
                NIMContactTeamSelectConfig *config = [[NIMContactTeamSelectConfig alloc] init];
                config.teamType = NIMKitTeamTypeNomal;
                vc = [[NIMContactSelectViewController alloc] initWithConfig:config];
                self.sendSessionType = NIMSessionTypeTeam;
                vc.delegate = self;
                break;
            }
            case 2:{
                NIMContactTeamSelectConfig *config = [[NIMContactTeamSelectConfig alloc] init];
                config.teamType = NIMKitTeamTypeSuper;
                vc = [[NIMContactSelectViewController alloc] initWithConfig:config];
                self.sendSessionType = NIMSessionTypeSuperTeam;
                vc.delegate = self;
                break;
            }
            default:
                return;
        }
        [vc show];
    }];
}

- (void)clearAll:(id)sender
{
    JXCustomNotificationDB *db = [JXCustomNotificationDB sharedInstance];
    [db deleteAllNotification];
    [self.data removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - NIMContactSelectDelegate
- (void)didFinishedSelect:(NSArray *)selectedContacts{
    NSString *selectId = selectedContacts.firstObject;
    if (!selectId.length) {
        return;
    }
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"" message:@"自定义发送内容" preferredStyle:UIAlertControllerStyleAlert];
    [vc addTextFieldWithConfigurationHandler:nil];
    __weak UIAlertController *wvc = vc;
    [[vc addAction:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *content = [wvc.textFields.firstObject.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        content = [content length] ? content : @"";
        NIMSession *session = [NIMSession session:selectId type:self.sendSessionType];
        [_sender sendCustomContent:content
                         toSession:session];
    }]
    addAction:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [vc show];
}

@end
