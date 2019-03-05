//
//  ViewController.m
//  tableview拖拽功能
//
//  Created by mx1614 on 2/20/19.
//  Copyright © 2019 ludy. All rights reserved.
//

#import "ViewController.h"
#define CustomTableViewDragType @"CustomTableViewDragType"

@interface ViewController()<NSTableViewDataSource, NSTableViewDelegate>
@property (weak) IBOutlet NSTableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, assign) NSInteger originIndex;
@end

@implementation ViewController

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray<NSRunningApplication *> *apps = [[NSWorkspace sharedWorkspace] runningApplications];
    for (NSRunningApplication *app in apps) {
        [self.dataArr addObject:app.localizedName];
    }
    [self.tableview reloadData];
    [self.tableview registerForDraggedTypes:[NSArray arrayWithObject:CustomTableViewDragType]];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return _dataArr.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return _dataArr[row];
}

- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id<NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation
{
    return NSDragOperationMove;
}

- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
    [pboard declareTypes:[NSArray arrayWithObject:CustomTableViewDragType] owner:self];
    [pboard setData:data forType:CustomTableViewDragType];
    self.originIndex = rowIndexes.firstIndex;
    return YES;
}

- (BOOL)tableView:(NSTableView *)tableView acceptDrop:(id<NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation
{
    id obj = self.dataArr[self.originIndex];
    [self.dataArr insertObject:obj atIndex:row];
    if (self.originIndex < row) {
        [self.dataArr removeObjectAtIndex:self.originIndex];
    }else{
        [self.dataArr removeObjectAtIndex:self.originIndex + 1];
    }
   
    return YES;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
