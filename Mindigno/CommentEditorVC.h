//
//  EditorVC.h
//  Mindigno
//
//  Created by Enrico on 18/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentEditorVC;

@protocol EditorVCDelegate <UITableViewDelegate>

@optional
- (BOOL)respondsToSelector:(SEL)aSelector;
- (void) textEditor:(CommentEditorVC*)editorVC hasDoneWithText:(NSString*)text;

@end

@interface CommentEditorVC : UIViewController <UITextViewDelegate> {

    id <EditorVCDelegate> __weak delegate;
    
    IBOutlet UITextView *textViewContent;
}

@property (nonatomic, weak) id <EditorVCDelegate> delegate;

- (IBAction)done:(id)sender;
- (IBAction)goBack:(id)sender;

@end
