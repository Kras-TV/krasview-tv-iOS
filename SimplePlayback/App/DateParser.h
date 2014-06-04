//
//  Dane].h
//  Vitamio-Demo
//
//  Created by Аня Кайгородова on 31.03.14.
//  Copyright (c) 2014 yixia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecordList.h"

@class RecordList;

@interface DateParser : NSObject<NSXMLParserDelegate, NSURLConnectionDelegate,UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, retain) NSMutableData* responseData;

@property (nonatomic, retain) NSMutableArray* array;

@property (nonatomic, retain) NSString* currentElement;
@property (nonatomic, retain) NSMutableDictionary* currentDic;

@property (nonatomic, retain) UICollectionView* collectionView;

@property (nonatomic, retain) NSIndexPath* currIndex;

@property (nonatomic, assign) RecordList* recordList;

@end
