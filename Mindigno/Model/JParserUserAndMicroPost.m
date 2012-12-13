//
//  JsonParserMicroPost.m
//  Mindigno
//
//  Created by Enrico on 29/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "JParserUserAndMicroPost.h"
#import "JsonKeys.h"
#import "Mindigno.h"

@interface JParserUserAndMicroPost ()

@end

@implementation JParserUserAndMicroPost

@synthesize user, microPosts;

- (id)init {
    self = [super init];
    if (self) {
        microPosts = [NSMutableArray array];
    }
    
    return self;
}

- (void) startDownloadAndParsingJsonAtUrl:(NSString *)urlString {
    
    [microPosts removeAllObjects];
    
    //
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    //Necessary for request to server
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //
    
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];

    //
    
    //For debug
    //NSString *textJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", textJson);
    
    NSDictionary *root_dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    //It must be done before of all
    NSArray *users_array = [root_dictionary objectForKey: USERS_KEY];
    [[Mindigno sharedMindigno] addUsersFromJsonRoot: users_array];
    
    NSString *current_user_id = [root_dictionary objectForKey: CURRENT_USER_KEY];
    user = [[Mindigno sharedMindigno] userWithId: current_user_id];
    
    NSArray *feeds_array = [root_dictionary objectForKey: MICROPOSTS_KEY];
    
    for (NSDictionary *feed_dictionary in feeds_array) {
        
        MicroPost *microPost = [[MicroPost alloc] initWithJsonRoot: feed_dictionary];
        
        //Add to list
        [microPosts addObject:microPost];
    }
}

@end
