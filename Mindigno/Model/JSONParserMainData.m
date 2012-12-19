//
//  JsonParserMicroPost.m
//  Mindigno
//
//  Created by Enrico on 29/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "JSONParserMainData.h"
#import "JsonKeys.h"
#import "Mindigno.h"

@interface JSONParserMainData ()

@end

@implementation JSONParserMainData

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

//Return TRUE if it worked out (there is connection).
- (BOOL) startDownloadAndParsingJsonAtUrl:(NSString *)urlString {
    
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
    
    if (data != nil) {
        
        NSDictionary *root_dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        //
        
        //It must be done before of all
        [[Mindigno sharedMindigno] setBaseURL: [root_dictionary objectForKey: BASE_URL_KEY]];
        
        NSArray *users_array = [root_dictionary objectForKey: USERS_KEY];
        [[Mindigno sharedMindigno] addUsersFromJsonRoot: users_array];
        //
        
        NSString *current_user_id = [root_dictionary objectForKey: CURRENT_USER_KEY];
        User *current_user = [[Mindigno sharedMindigno] userWithId: current_user_id];
        [[Mindigno sharedMindigno] setCurrentUser: current_user];
        
        NSArray *feeds_array = [root_dictionary objectForKey: MICROPOSTS_KEY];
        [[Mindigno sharedMindigno] addMicroPostsFromJsonRoot: feeds_array];
        
        return YES;
    
    } else {
        NSLog(@"No connection: data is nil");
        
        return NO;
    }
}

@end
