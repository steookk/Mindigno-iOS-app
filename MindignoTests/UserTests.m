//
//  MindignoTests.m
//  MindignoTests
//
//  Created by Enrico on 28/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "UserTests.h"

@implementation UserTests

- (void)setUp {
    [super setUp];
    
    // Set-up code here.
    user = [[User alloc] init];
    
    [user setName:@"Enrico"];
    [user setUrlAvatar:@"fileAvatar.png"];
}

- (void)tearDown {
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExistence {
    STAssertNotNil(user, @"Error: user is nil");
}

- (void)testValues {
    
    STAssertEqualObjects([user name], @"Enrico", @"Error: get name");
    STAssertEqualObjects([user urlAvatar], @"fileAvatar.png", @"Error: get urlAvatar");
}

@end
