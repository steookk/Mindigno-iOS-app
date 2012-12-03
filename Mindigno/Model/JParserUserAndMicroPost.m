//
//  JsonParserMicroPost.m
//  Mindigno
//
//  Created by Enrico on 29/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "JParserUserAndMicroPost.h"
#import "JsonKeys.h"

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
    
    user = [[User alloc] init];
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
    
    NSDictionary *user_dictionary = [root_dictionary objectForKey: USER_KEY];
    
    [user setUserID: [user_dictionary objectForKey: USER_ID_KEY]];
    [user setName: [user_dictionary objectForKey: USER_NAME_KEY]];
    [user setUrlAvatar: [user_dictionary objectForKey: USER_URL_AVATAR_KEY]];
    
    NSArray *feeds_array = [root_dictionary objectForKey: MICROPOSTS_KEY];
    
    for (NSDictionary *feed_dictionary in feeds_array) {
        
        MicroPost *microPost = [[MicroPost alloc] init];
        
        [microPost setCreatedAtText: [feed_dictionary objectForKey: MICROPOST_CREATED_AT_TEXT_KEY]];
        [microPost addComments: [feed_dictionary objectForKey: MICROPOST_COMMENTS_KEY]];
        //TODO: [microPost setDescription: [feed_dictionary objectForKey: MICROPOST_DESCRIPTION_KEY]];
        [microPost setIndignatiText: [feed_dictionary objectForKey: MICROPOST_INDIGNATI_TEXT_KEY]];
        [microPost setIsLink: [[feed_dictionary objectForKey: MICROPOST_IS_LINK_KEY] boolValue]];
        [microPost setMicropostID: [feed_dictionary objectForKey: MICROPOST_ID_KEY]];
        [microPost setSourceText: [feed_dictionary objectForKey: MICROPOST_SOURCE_TEXT_KEY]];
        [microPost setTitle: [feed_dictionary objectForKey: MICROPOST_TITLE]];
        
        //Add to list
        [microPosts addObject:microPost];
    }
}

@end
