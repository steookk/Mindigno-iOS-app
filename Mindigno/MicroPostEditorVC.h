//
//  MicroPostEditorVC.h
//  Mindigno
//
//  Created by Enrico on 08/03/13.
//  Copyright (c) 2013 Enrico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MicroPost.h"
#import <GTKeyboardHelper/GTKeyboardHelper.h>

#define MAX_CHAR_TITOLO 109
#define MAX_CHAR_DESCRIZIONE 500

#define DEFAULT_TITOLO @"Scrivi il titolo della tua indignazione"
#define DEFAULT_DESCRIZIONE @"Descrivi più dettagliatamente la tua indignazione (opzionale)"

@interface MicroPostEditorVC : UIViewController <UITextViewDelegate> {

    IBOutlet UITextView *textViewTitolo;
    IBOutlet UITextView *textViewDescrizione;
    
    IBOutlet UILabel *labelCounterCharTitolo;
    IBOutlet UILabel *labelCounterCharDescrizione;
}

- (IBAction)done:(id)sender;
- (IBAction)goBack:(id)sender;

@end
