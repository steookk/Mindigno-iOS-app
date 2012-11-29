//
//  MicroPostTests.m
//  Mindigno
//
//  Created by Enrico on 29/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "MicroPostTests.h"

@implementation MicroPostTests

- (void)setUp {
    [super setUp];
    
    // Set-up code here.
    micropost = [[MicroPost alloc] init];
    
    [micropost setTitle:@"Title"];
    [micropost setDescription:@"Description"];
    [micropost setCreatedAtText:@"Created 3 hours ago"];
    [micropost setIndignatiText:@"3 indignati found"];
    [micropost setSourceText:@"from corriere"];
    [micropost setIsLink:YES];
}

- (void)tearDown {
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExistence {
    STAssertNotNil(micropost, @"Error: micropost is nil");
}

- (void)testValues {
    
    STAssertEqualObjects([micropost title], @"Title", @"Error: title get error");
    STAssertEqualObjects([micropost description], @"Description", @"Error: get description");
    STAssertEqualObjects([micropost createdAtText], @"Created 3 hours ago", @"Error: get createdAtText");
    STAssertEqualObjects([micropost indignatiText], @"3 indignati found", @"Error: get indignatiText");
    STAssertEqualObjects([micropost sourceText], @"from corriere", @"Error: get sourceText");
    STAssertTrue([micropost isLink], @"Error: get isLink");
    STAssertNotNil([micropost getAllComments], @"Error: getAllComments is nil");
}

- (void) testHandleComments {

    STAssertTrue([micropost getNumberOfComments] == 0, @"Error: getNumberOfComments");
    
    [micropost addComment:@"Comment_1"];
    STAssertTrue([micropost getNumberOfComments] == 1, @"Error: addComment");
    
    [micropost addComment:@"Comment_2"];
    STAssertTrue([[micropost getAllComments] count] == 2, @"Error: getAllComments");
    
    [micropost removeAllComments];
    STAssertTrue([micropost getNumberOfComments] == 0, @"Error: removeAllComments");
}

@end
