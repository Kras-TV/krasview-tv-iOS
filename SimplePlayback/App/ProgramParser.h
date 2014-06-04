//
//  ProgramParser.h
//  Vitamio-Demo
//
//  Created by Аня Кайгородова on 09.04.14.
//  Copyright (c) 2014 yixia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecordList.h"
#import "List.h"

@class RecordList;

@interface ProgramParser : NSObject<UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate, NSURLConnectionDelegate, PlayerControllerDelegate>

@property (nonatomic, assign) RecordList* recordList;
@property (nonatomic, assign) List* list;

@property (nonatomic, retain) NSString* channelId;

@property (nonatomic, retain) UITableView * tableView;
@property (nonatomic, retain) NSMutableData* responseData;

@property (nonatomic, retain) NSMutableArray* array;
@property (nonatomic, retain) NSString* currentElement;
@property (nonatomic, retain) NSMutableDictionary* currentDic;
@property (nonatomic, retain) NSMutableString* name;
@property (nonatomic, retain) NSMutableString* time;
@property (nonatomic, retain) NSMutableString* start;
@property (nonatomic, retain) NSMutableString* record;
@property (nonatomic, retain) NSMutableString* percent;

@property (nonatomic, retain) NSIndexPath *currentIndexPath;

@end
