//
//  Dane].m
//  Vitamio-Demo
//
//  Created by Аня Кайгородова on 31.03.14.
//  Copyright (c) 2014 yixia. All rights reserved.
//

#import "DateParser.h"
#import "MyCell.h"

@implementation DateParser
@synthesize array = _array;
@synthesize collectionView = _collectionView;
@synthesize responseData = _responseData;
@synthesize currIndex = _currIndex;
@synthesize recordList = _recordList;

-(id)init{
     self = [super init];
    if(self){
        self.responseData = [NSMutableData new];
        self.array = [NSMutableArray array];
    }
    return self;
}

-(void)dealloc{
    [_array release];
    [_collectionView release];
    [_responseData release];
    self.currIndex=nil;
    [super dealloc];
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
    self.currentElement = elementName;
    
    if ([elementName isEqualToString:@"item"]) {
        self.currentDic = [NSMutableDictionary dictionaryWithDictionary:attributeDict];
       // NSLog(@"Начат %@", [self.currentDic ]);
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"item"]){
        [self.array addObject:self.currentDic];
        self.currentDic = nil;
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [self.collectionView reloadData];
    if ([self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0]>0) {
        [self.collectionView.delegate collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
}

#pragma mark - NSURLConnectionDelegate

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    [connection release];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSString* result = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding] ;
    if([result isEqualToString: @"auth failed"]){
    }else{
        NSXMLParser *rssParser = [[NSXMLParser alloc] initWithData:self.responseData];
        rssParser.delegate = self;
        [rssParser parse];
        [rssParser release];
    }
    [result release];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"something very bad happened here");
}

-(NSInteger) numberOfSectionsInCollectionView: (UICollectionView*) collectionView
{
    return 1;
}
-(NSInteger) collectionView: (UICollectionView*) collectionView numberOfItemsInSection: (NSInteger) section
{
    return [self.array count];
}

-(UICollectionViewCell*) collectionView: (UICollectionView*) collectionView cellForItemAtIndexPath: (NSIndexPath*) indexPath
{
    
    
    static NSString *cellIdentifier = @"myCell";
    
    MyCell *cell = (MyCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
     NSString *nDate =[[self.array objectAtIndex:indexPath.row] objectForKey:@"id"];
   
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([nDate doubleValue] )];
    
    NSDateFormatter *dtfrm = [[NSDateFormatter alloc] init];
    NSLocale *ruLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
    [dtfrm setLocale:ruLocale];
    [dtfrm setDateFormat:@"dd"];
    cell.number.text = [dtfrm stringFromDate:date];
    [dtfrm setDateFormat:@"ccc"];
     cell.day.text = [dtfrm stringFromDate:date];
    if (self.currIndex&&indexPath.row==self.currIndex.row) {
        cell.layer.borderWidth = 2;
        cell.layer.borderColor = [ [UIColor blackColor] CGColor];
    }else{
        cell.layer.borderWidth = 0;
        cell.layer.borderColor = [ [UIColor whiteColor] CGColor];
    }
   
    [ruLocale release];
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic = [self.array objectAtIndex:indexPath.row];

    self.currIndex = indexPath;
    [self.collectionView reloadData];
    [self.recordList loadListForDate:[dic objectForKey:@"id"]];
}

@end
