//
//  TableSyncProtocol.h
//  tv
//
//  Created by Аня Кайгородова on 22.05.14.
//  Copyright (c) 2014 VideoLAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TableSyncProtocol <NSObject>

- (void)dataLoadFinishing;
- (void)dataParsingIsFinished;

@end
