//
//  JsonParserMicroPost.m
//  Mindigno
//
//  Created by Enrico on 29/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "JParserUserAndMicroPost.h"

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
    
    NSDictionary *user_dictionary = [root_dictionary objectForKey:@"current_user"];
    
    [user setUserID: [user_dictionary objectForKey:@"user_id"]];
    [user setName: [user_dictionary objectForKey:@"name"]];
    [user setUrlAvatar: [user_dictionary objectForKey:@"avatar"]];
    
    NSArray *feeds_array = [root_dictionary objectForKey:@"feed"];
    
    for (NSDictionary *feed_dictionary in feeds_array) {
        
        MicroPost *microPost = [[MicroPost alloc] init];
        
        [microPost setCreatedAtText: [feed_dictionary objectForKey:@"created_at_text"]];
        [microPost addComments: [feed_dictionary objectForKey:@"default_comments"]];
        //TODO: [microPost setDescription: [feed_dictionary objectForKey:@"description"]];
        [microPost setIndignatiText: [feed_dictionary objectForKey:@"indignati_text"]];
        [microPost setIsLink: [[feed_dictionary objectForKey:@"islink"] boolValue]];
        [microPost setMicropostID: [feed_dictionary objectForKey:@"micropost_id"]];
        [microPost setSourceText: [feed_dictionary objectForKey:@"source_text"]];
        [microPost setTitle: [feed_dictionary objectForKey:@"title"]];
        
        //Add to list
        [microPosts addObject:microPost];
    }
}

@end
