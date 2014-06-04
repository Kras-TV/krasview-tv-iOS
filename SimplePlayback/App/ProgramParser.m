//
//  ProgramParser.m
//  Vitamio-Demo
//
//  Created by Аня Кайгородова on 09.04.14.
//  Copyright (c) 2014 yixia. All rights reserved.
//

#import "ProgramParser.h"
#import "ProgramCell.h"
//#import "PlayerController.h"

@implementation ProgramParser

@synthesize responseData = _responseData;
@synthesize tableView = _tableView;
@synthesize array = _array;
@synthesize currentElement = _currentElement;
@synthesize currentDic = _currentDic;
@synthesize name = _name;
@synthesize time = _time;
@synthesize start = _start;
@synthesize record = _record;
@synthesize currentIndexPath = _currentIndexPath;
@synthesize list=_list;
@synthesize channelId = _channelId;
@synthesize percent = _percent;

-(id)init{
    self = [super init];
    if(self){
        self.responseData = [NSMutableData new];
        self.array = [NSMutableArray array];
    }
    return self;
}

-(void) dealloc{
    [_tableView release];
    [_responseData release];
    self.currentIndexPath = nil;
    self.channelId = nil;
    [super dealloc];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    ProgramCell *cell = [tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProgramCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if (cell) {
        NSDictionary *dic = [self.array objectAtIndex:indexPath.row];
       // cell.accessoryType = UITableViewCellAccessoryNone;
        cell.name.text = [dic objectForKey:@"name"];
        cell.time.text = [dic objectForKey:@"start"];
        if (![dic objectForKey:@"record"]) {
            cell.userInteractionEnabled=NO;
            cell.name.textColor = [UIColor lightGrayColor];
            cell.time.textColor = [UIColor lightGrayColor];
        }else{
            cell.userInteractionEnabled=YES;
            cell.name.textColor = [UIColor blackColor];
            cell.time.textColor = [UIColor blackColor];
        }
    }
    return cell;
}

#pragma mark - NSURLConnectionDelegate

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    
   // NSLog(@"connectionDidFinishLoading");
    
    [connection release];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSString* result = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding] ;
    if([result isEqualToString: @"auth failed"]){

    }else{
        self.array = nil;
        self.array = [NSMutableArray array];
        NSXMLParser *rssParser = [[NSXMLParser alloc] initWithData:self.responseData];
        rssParser.delegate = self;
        [rssParser parse];
        [rssParser release];
    }
    [result release];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // NSLog(@"connectionDidFinishLoading11");
    [self.responseData setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
   //  NSLog(@"connectionDidFinishLoading22");
    [self.responseData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"something very bad happened here");
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
        self.currentDic = [NSMutableDictionary dictionaryWithCapacity:2];
    }else if ([elementName isEqualToString:@"name"]){
        self.name = [NSMutableString string];
    }else if ([elementName isEqualToString:@"time"]){
        self.time = [NSMutableString string];
    }else if ([elementName isEqualToString:@"start"]){
        self.start = [NSMutableString string];
    }else if ([elementName isEqualToString:@"record"]){
        self.record = [NSMutableString string];
    }else if ([elementName isEqualToString:@"percent"]){
        self.percent = [NSMutableString string];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([self.currentElement isEqualToString:@"name"]) {
        [self.name appendString:string];
    }else if ([self.currentElement isEqualToString:@"time"]) {
        [self.time appendString:string];
    }else if ([self.currentElement isEqualToString:@"record"]) {
        [self.record appendString:string];
    }else if ([self.currentElement isEqualToString:@"start"]) {
        NSString *nDate = string;
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:([nDate doubleValue] )];
        
        NSDateFormatter *dtfrm = [[NSDateFormatter alloc] init];
        NSLocale *ruLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
        [dtfrm setLocale:ruLocale];
        //[dtfrm setTimeZone:[NSTimeZone systemTimeZone]];
        [dtfrm setDateFormat:@"HH:mm"];
        
        [self.start appendString:[dtfrm stringFromDate:date]];
        [dtfrm release];
    }else if ([self.currentElement isEqualToString:@"percent"]) {
        [self.percent appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"name"]) {
        [self.currentDic setObject:self.name forKey:@"name"];
        self.name = nil;
    }else if ([elementName isEqualToString:@"time"]) {
        [self.currentDic setObject:self.time forKey:@"time"];
        self.time = nil;
    }else if ([elementName isEqualToString:@"record"]) {
        [self.currentDic setObject:self.record forKey:@"record"];
        self.record = nil;
    }else if ([elementName isEqualToString:@"start"]) {
        [self.currentDic setObject:self.start forKey:@"start"];
        self.start = nil;
    }else if ([elementName isEqualToString:@"percent"]) {
        [self.currentDic setObject:self.percent forKey:@"percent"];
        self.percent = nil;
    }else if([elementName isEqualToString:@"item"]){
        [self.array addObject:self.currentDic];
        self.currentDic = nil;
        self.currentElement = nil;
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (self.tableView) {
        [self.tableView reloadData];
    }
    if (self.list&&[self.array count]>0) {
        [self.list finishDownload:[self.array objectAtIndex:0] withId:self.channelId];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.currentIndexPath = indexPath;
      //  NSDictionary *dic = [self.array objectAtIndex:indexPath.row];
        [self.recordList play];
}

#pragma mark - PlayerControllerDelegate

- (NSURL *)playCtrlGetCurrMediaTitle:(NSString **)title lastPlayPos:(long *)lastPlayPos
{
    NSDictionary *dic = [self.array objectAtIndex:self.currentIndexPath.row];
    return [NSURL URLWithString:[dic objectForKey:@"record"]];
   // return [NSURL URLWithString: @"http://media3.krasview.ru/download/cdc2b8eac1cb01c.mp4"];
}

- (NSURL *)playCtrlGetNextMediaTitle:(NSString **)title lastPlayPos:(long *)lastPlayPos
{
    NSInteger i = [self tableView:self.tableView numberOfRowsInSection:1];
    if(self.currentIndexPath.row >= i-1){
        self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    }else{
        self.currentIndexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row+1 inSection:1];
    }
	return [self playCtrlGetCurrMediaTitle:nil lastPlayPos:0];
}

- (NSURL *)playCtrlGetPrevMediaTitle:(NSString **)title lastPlayPos:(long *)lastPlayPos
{
    NSInteger i = [self tableView:self.tableView numberOfRowsInSection:1];
    if(self.currentIndexPath.row <=0 ){
        self.currentIndexPath = [NSIndexPath indexPathForRow:i-1 inSection:1];
    }else{
        self.currentIndexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row-1 inSection:1];
    }
    
	return [self playCtrlGetCurrMediaTitle:nil lastPlayPos:0];

}

- (NSString *)playCtrlGetCurrChannelTitle{
    return nil;
}

- (UIImage *)playCtrlGetCurrChannelImage{
    return nil;
}

- (NSString *)playCtrlGetCurrChannelId{
    return nil;
}


@end
