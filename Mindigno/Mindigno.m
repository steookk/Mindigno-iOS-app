//
//  Mindigno.m
//  Mindigno
//
//  Created by Enrico on 13/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "Mindigno.h"
#import "JSONParserMainData.h"
#import "LoginSignupVC.h"

@implementation Mindigno

@synthesize currentUser, idToUser_dictionary, baseURL, isLoggedUser;
@synthesize microPosts, microPostsUser;

+ (id)sharedMindigno {
    static Mindigno *sharedMindigno = nil;

    @synchronized(self) {
        if (sharedMindigno == nil) {
            sharedMindigno = [[self alloc] init];
        }
    }
    return sharedMindigno;
}

- (BOOL) checkAndUpdateIfUserIsLogged {

    BOOL isLogged = NO;
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        
        if ([[cookie name] isEqualToString: @"remember_token"]) {
            
            if (![[cookie value] isEqualToString:@""]) {
                isLogged = YES;
            }
        }
    }
    
    isLoggedUser = isLogged;
    
    return isLogged;
}

- (id) init {
    self = [super init];
    if (self) {
        
        currentUser = nil;
        microPosts = [NSMutableArray array];
        microPostsUser = [NSMutableArray array];
        idToUser_dictionary = [NSMutableDictionary dictionary];
        
        [self checkAndUpdateIfUserIsLogged];
        //NSLog(@"USER LOGGED: %d", isLoggedUser);
    }
    
    return self;
}

///

- (NSArray *) downloadMicroPosts {

    NSString *url = [URL_JSON_MICROPOST_TEST stringByAppendingPathComponent: @"users/home_hot_feed"];
    NSLog(@"downloadMicroPosts url: %@", url);
    
    JSONParserMainData *jsonParser = [[JSONParserMainData alloc] init];
    NSMutableArray *microposts_to_return = [jsonParser startDownloadFeedAtUrl:url thereIsUserField:NO];
    
    [microPosts removeAllObjects];
    [microPosts setArray: microposts_to_return];
    
    return microPosts;
}

- (NSArray *) downloadMoreOldMicroPosts {

    NSString *url = [URL_JSON_MICROPOST_TEST stringByAppendingPathComponent: [NSString stringWithFormat:@"users/home_hot_feed?from=%d", [microPosts count]]];
    
    JSONParserMainData *jsonParser = [[JSONParserMainData alloc] init];
    NSMutableArray *microposts_to_return = [jsonParser startDownloadFeedAtUrl:url thereIsUserField:NO];
    
    if (microposts_to_return != nil) {
        [microPosts addObjectsFromArray: microposts_to_return];
    }
    
    return microposts_to_return;
}

- (NSArray *) downloadMicroPostsOfUser:(User*)user {
    
    NSString *url = [user userUrl];
    NSLog(@"downloadMicroPostsOfUser url: %@", url);
    
    JSONParserMainData *jsonParser = [[JSONParserMainData alloc] init];
    NSMutableArray *microposts_to_return = [jsonParser startDownloadFeedAtUrl:url thereIsUserField:YES];
    
    [microPostsUser removeAllObjects];
    [microPostsUser setArray: microposts_to_return];
    
    return microPostsUser;
}

- (NSArray *) downloadMoreOldMicroPostsOfUser:(User*)user {

    NSString *url = [[user userUrl] stringByAppendingPathComponent: [NSString stringWithFormat:@"profile_feed?from=%d", [microPostsUser count]]];
    NSLog(@"downloadMoreOldMicroPostsOfUser url: %@", url);
    
    JSONParserMainData *jsonParser = [[JSONParserMainData alloc] init];
    NSMutableArray *microposts_to_return = [jsonParser startDownloadFeedAtUrl:url thereIsUserField:NO];
    
    if (microposts_to_return != nil) {
        [microPostsUser addObjectsFromArray: microposts_to_return];
    }
    
    return microposts_to_return;
}

- (void) addUsersFromJsonRoot:(NSArray*)users {
    
    for (NSDictionary *user_dictionary in users) {
        
        User *user = [[User alloc] initWithJsonRoot:user_dictionary];
        
        if ([idToUser_dictionary objectForKey: [user userID]] == nil) {
            [idToUser_dictionary setObject:user forKey: [user userID]];
        
        } else {
            
            User *existentUser = [idToUser_dictionary objectForKey: [user userID]];
            [existentUser setInfoWithJsonRoot: user_dictionary];
            
            //[idToUser_dictionary setObject:user forKey: [user userID]];
        }
    }
}

- (User*) userWithId:(NSString*)userId {
    User *retUser = [idToUser_dictionary objectForKey: userId];
    
    return retUser;
}

- (void) shareInfoOnViewController:(UIViewController*)controller {
    
    [self shareInfoOnViewController:controller withText:@"I just shared this from my App" imageName:@"Icon.png" url:@"http://www.bronron.com"];
}

- (void) shareInfoOnViewController:(UIViewController*)controller withText:(NSString*)text imageName:(NSString*)image url:(NSString*)url {

    NSString *textToShare = text;
    UIImage *imageToShare;
    if (image != nil) {
        imageToShare = [UIImage imageNamed: image];
    } else {
        imageToShare = [UIImage imageNamed: @"Icon.png"];
    }
    
    NSURL *urlToShare = [NSURL URLWithString: url];
    
    NSArray *activityItems = @[textToShare, imageToShare, urlToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities: nil];
    
    //This is an array of excluded activities to appear on the UIActivityViewController
    activityVC.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    
    [controller presentViewController:activityVC animated:YES completion:nil];
}

- (NSString*) getStringUrlFromStringPath:(NSString*)path {
    return [baseURL stringByAppendingPathComponent:path];
}

- (UIViewController *) apriModaleLogin {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:[NSBundle mainBundle]];
    
    UINavigationController *navController = (UINavigationController *)[storyboard instantiateInitialViewController];
    //LoginSignupVC *loginSignupVC = (LoginSignupVC *)[navController topViewController];
    
    return navController;
}

@end
