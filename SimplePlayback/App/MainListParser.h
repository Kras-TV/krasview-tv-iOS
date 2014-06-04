//
//  MainListParser.h
//  tv
//
//  Created by Аня Кайгородова on 03.06.14.
//  Copyright (c) 2014 VideoLAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "List.h"

@interface MainListParser : NSObject<NSXMLParserDelegate>

@property (nonatomic, assign) List* list;

@property (nonatomic, retain) NSString* currentElement;
@property (nonatomic, retain) NSMutableDictionary* currentDic;

@property (nonatomic, retain) NSMutableString* name;
@property (nonatomic, retain) NSMutableString* chanelId;
@property (nonatomic, retain) NSMutableString* uri;
@property (nonatomic, retain) NSMutableString* fav;
@property (nonatomic, retain) NSMutableString* image;

@end
