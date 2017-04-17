//
//  BlowToTheBall
//
//  Created by Negulus on 2/23/13.
//  Copyright (c) 2013 Negulus. All rights reserved.
//

#ifndef BlowToTheBall_menumain_h
#define BlowToTheBall_menumain_h

#import "game.h"

@interface MenuMain : Game
{
    GLuint Background;
    
    //Кнопки
    struct Button Button_Play;
    struct Button Button_Settings;
    struct Button Button_Back;
    struct Button Button_Sound_On;
    struct Button Button_Sound_Off;
    struct Button Button_Reset;
    struct Button Button_Help;
    
    //Текстуры
    struct Object Texture_Plate;
    struct Object Texture_Text_Main;
    struct Object Texture_Text_Settings;
    struct Object Texture_Text_Help;
    struct Object Texture_Help;
    
    //Таймеры
    struct Timer Timer_Menu;
}

-(id)init : (struct GameData*)data;
-(void)dealloc;
-(void)Update;
-(void)Draw;
-(void)Draw_Main;
-(void)Draw_Help;
-(void)Draw_Settings;
-(void)Touch_Begin : (float)x : (float)y;
-(void)Reset;
@end

#endif
