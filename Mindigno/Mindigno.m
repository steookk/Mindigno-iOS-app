//
//  Mindigno.m
//  Mindigno
//
//  Created by Enrico on 13/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "Mindigno.h"
#import "LoginSignupVC.h"

@implementation Mindigno

@synthesize currentUser, idToUser_dictionary, baseURL, isLoggedUser;
@synthesize microPostsOfHome, microPostsOfFollowing;

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
        microPostsOfHome = [NSMutableArray array];
        microPostsOfFollowing = [NSMutableArray array];
        
        idToUser_dictionary = [NSMutableDictionary dictionary];
        
        [self checkAndUpdateIfUserIsLogged];
        //NSLog(@"USER LOGGED: %d", isLoggedUser);
    }
    
    return self;
}

///

- (BOOL) loginWithUser:(NSString*)user andPassword:(NSString*)password {

    BOOL loginOK = [JSONParserMainData startLoginWithUser:user andPassword:password];
    
    return loginOK;
}

- (SignupResponse*) signupWithName:(NSString*)name mail:(NSString*)mail password:(NSString*)password passwordConfirmation:(NSString*)passwordConfirmation {

    SignupResponse *response = [JSONParserMainData startSignupWithName:name mail:mail password:password passwordConfirmation:passwordConfirmation];

    return response;
}

- (BOOL) logout {

    BOOL logoutOK = [JSONParserMainData startLogout];
    
    if (logoutOK) {
        [currentUser removeAllMicroposts];
        [microPostsOfFollowing removeAllObjects];
    }
    
    return logoutOK;
}

///

- (BOOL) indignatiSulMicroPostConID:(NSString*)micropostID {
    
    BOOL indignatoOK = [JSONParserMainData startIndignatiSulMicroPostConID: micropostID];
    
    return indignatoOK;
}

- (BOOL) rimuoviIndignazioneSulMicroPostConID:(NSString*)micropostID {

    BOOL rimuoviIndignatoOK = [JSONParserMainData startRimuoviIndignazioneSulMicroPostConID: micropostID];
    
    return rimuoviIndignatoOK;
}

///

- (BOOL) followUserWithID:(NSString*)userID {

    BOOL followedOK = [JSONParserMainData startFollowUserWithID: userID];
    
    return followedOK;
}

- (BOOL) removeFollowedUserWithID:(NSString*)userID {

    BOOL rimuoviFollowedUserOK = [JSONParserMainData startRemoveFollowedUserWithID: userID];
    
    return rimuoviFollowedUserOK;
}

///

- (NSArray *) downloadMicroPosts {

    NSString *url = [URL_JSON_MICROPOST_TEST stringByAppendingPathComponent: @"users/home_hot_feed"];
    NSLog(@"downloadMicroPosts url: %@", url);
    
    NSMutableArray *microposts_to_return = [JSONParserMainData startDownloadFeedAtUrl:url thereIsUserField:NO];
    
    [microPostsOfHome removeAllObjects];
    [microPostsOfHome setArray: microposts_to_return];
    
    return microPostsOfHome;
}

- (NSArray *) downloadMoreOldMicroPosts {

    NSString *url = [URL_JSON_MICROPOST_TEST stringByAppendingPathComponent: [NSString stringWithFormat:@"users/home_hot_feed?from=%d", [microPostsOfHome count]]];
    NSLog(@"downloadMoreOldMicroPosts url: %@", url);
    
    NSMutableArray *microposts_to_return = [JSONParserMainData startDownloadFeedAtUrl:url thereIsUserField:NO];
    
    if (microposts_to_return != nil) {
        [microPostsOfHome addObjectsFromArray: microposts_to_return];
    }
    
    return microposts_to_return;
}

//

- (NSArray *) downloadMicroPostsOfFollowing {
    
    NSString *url = [[currentUser userUrl] stringByAppendingPathComponent:@"home_following_feed"];
    NSLog(@"downloadMicroPostsOfFollowing url: %@", url);
    
    NSMutableArray *microposts_to_return = [JSONParserMainData startDownloadFeedAtUrl:url thereIsUserField:NO];
    
    [microPostsOfFollowing removeAllObjects];
    [microPostsOfFollowing setArray: microposts_to_return];
    
    return microPostsOfFollowing;
}


- (NSArray *) downloadMoreOldMicroPostsOfFollowing {

    NSString *url = [[currentUser userUrl] stringByAppendingPathComponent: [NSString stringWithFormat:@"home_following_feed?from=%d", [microPostsOfFollowing count]]];
    NSLog(@"downloadMoreOldMicroPostsOfFollowing url: %@", url);
    
    NSMutableArray *microposts_to_return = [JSONParserMainData startDownloadFeedAtUrl:url thereIsUserField:NO];
    
    if (microposts_to_return != nil) {
        [microPostsOfFollowing addObjectsFromArray: microposts_to_return];
    }
    
    return microposts_to_return;
}

//

- (NSArray *) downloadMicroPostsOfUser:(User*)user {
    
    NSString *url = [user userUrl];
    NSLog(@"downloadMicroPostsOfUser url: %@", url);
    
    NSMutableArray *microposts_to_return = [JSONParserMainData startDownloadFeedAtUrl:url thereIsUserField:YES];
    [user setMicroposts:microposts_to_return];
    
    return [user microposts];
}

- (NSArray *) downloadMoreOldMicroPostsOfUser:(User*)user {

    NSString *url = [[user userUrl] stringByAppendingPathComponent: [NSString stringWithFormat:@"profile_feed?from=%d", [[user microposts] count]]];
    NSLog(@"downloadMoreOldMicroPostsOfUser url: %@", url);
    
    NSMutableArray *microposts_to_return = [JSONParserMainData startDownloadFeedAtUrl:url thereIsUserField:NO];
    
    if (microposts_to_return != nil) {
        [user addMicroposts: microposts_to_return];
    }
    
    return microposts_to_return;
}

///

- (void) downloadAllIndignatiForMicropost:(MicroPost*)micropost {

    [JSONParserMainData startDownloadAllIndignatiForMicropost: micropost];
}

///

- (void) addUsersFromJsonRoot:(NSArray*)users {
    
    for (NSDictionary *user_dictionary in users) {
        
        User *user = [[User alloc] initWithJsonRoot:user_dictionary];
        
        if ([idToUser_dictionary objectForKey: [user userID]] == nil) {
            [idToUser_dictionary setObject:user forKey: [user userID]];
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
