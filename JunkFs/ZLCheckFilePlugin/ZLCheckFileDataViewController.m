//
//  ZLCheckFileDataViewController.m
//  ZLCheckFilePlugin
//
//  Created by 张磊 on 15-1-16.
//  Copyright (c) 2015年 com.zixue101.www. All rights reserved.
//

#import "ZLCheckFileDataViewController.h"
#import "ZLCheckInfo.h"
#import "ZLFile.h"

@interface ZLCheckFileDataViewController () <NSTableViewDataSource,NSTableViewDelegate,NSTextFieldDelegate>
@property (weak) IBOutlet NSTableView *tableView;
@property (strong,nonatomic) NSArray *datas;
- (IBAction)exportPlist:(id)sender;
@property (weak) IBOutlet NSSearchField *searchField;
@property (weak) IBOutlet NSView *makeView;
@property (weak) IBOutlet NSTextField *makeTextField;
- (IBAction)openUrl:(id)sender;

@end

@implementation ZLCheckFileDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
}

- (void)loadData
{
    [self.makeView setHidden:NO];
    __weak typeof(self)weakSelf = self;
    [[ZLCheckInfo sharedInstance] getFilesWithCallBack:^(NSArray *arr) {
        if (!arr.count) {
            [weakSelf.makeTextField setStringValue:@"您可能没有多余文件"];
        }else{
            weakSelf.datas = arr;
            [weakSelf.tableView reloadData];
            [weakSelf.makeView setHidden:YES];
        }
    }];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.datas.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSButton *btn = [[NSButton alloc] init];
    if (self.datas.count > row) {
        ZLFile *file = self.datas[row];
        btn.title = [[[ZLCheckInfo sharedInstance] workSpacePath] stringByAppendingPathComponent:file.filePath];
        btn.target = self;
        btn.action = @selector(clickButton:);
    }
    return btn;
}

- (void)clickButton:(NSButton *)btn{
    [self openFinderWithFilePath:btn.title];
}

- (void)controlTextDidChange:(NSNotification *)obj{
    self.datas = [[ZLCheckInfo sharedInstance] searchFilesWithText:[obj.object stringValue]];
    [self.tableView reloadData];
}

- (IBAction)exportPlist:(id)sender {
    [self openFinderWithFilePath:[[ZLCheckInfo sharedInstance] exportFilesInBundlePlist]];
}

#pragma mark - Open Finder
- (void)openFinderWithFilePath:(NSString *)path{
    if (!path.length) {
        return ;
    }

    NSString *open = [NSString stringWithFormat:@"open %@",path];
    const char *str = [open UTF8String];
    system([[open stringByDeletingLastPathComponent] UTF8String]);
    system(str);
}

- (IBAction)openUrl:(id)sender
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setMessage:@""];
    [panel setPrompt:@"OK"];
    [panel setCanChooseDirectories:YES];
    [panel setCanCreateDirectories:YES];
    [panel setCanChooseFiles:YES];
    NSString *path_all;
    NSInteger result = [panel runModal];
    if (result == NSFileHandlingPanelOKButton)
    {
        path_all = [[panel URL] path];
        [[ZLCheckInfo sharedInstance] setWorkSpacePath:path_all];
        
        [self loadData];
    }
}
@end
