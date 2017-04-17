//
//  BlowToTheBall
//
//  Created by Negulus on 2/23/13.
//  Copyright (c) 2013 Negulus. All rights reserved.
//

#ifndef BlowToTheBall_menuselect_h
#define BlowToTheBall_menuselect_h

#import "game.h"

@interface MenuSelect : Game
{
    GLuint Background;
    
    //Текстуры кнопок
    struct Object Tile_BG;
    struct Object_digit Tile_Digit;
    
    struct Object Tile_Stars_0;
    struct Object Tile_Stars_1;
    struct Object Tile_Stars_2;
    struct Object Tile_Stars_3;
    
    struct Object Texture_Plate;
    struct Object Texture_Text_Select;
    
    struct Button Button_Back;
    
    //Таймеры
    struct Timer Timer_Select;
    
    //Системные переменные
    float Position_tmp[2];
    int k;
}

-(id)init : (struct GameData*)data;
-(void)dealloc;
-(void)Touch_Begin : (float)x : (float)y;
-(void)Update;
-(void)Draw;
@end

#endif
