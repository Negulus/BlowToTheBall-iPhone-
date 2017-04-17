//  BlowToTheBall
//
//  Created by Negulus on 2/23/13.
//  Copyright (c) 2013 Negulus. All rights reserved.
//

#ifndef BlowToTheBall_game_h
#define BlowToTheBall_game_h

#import <AVFoundation/AVFoundation.h>
#import <GLKit/GLKit.h>

#define BUFFER_OFFSET(i) ((char *)NULL + (i))


enum Actions
{
    Act_Select,
    Act_Help,
    Act_Settings,
    Act_Exit,
    Act_Null,
    Act_Win,
    Act_Loose,
    Act_Game_Begin,
    Act_Draw_GameMenu,
    Act_Help_1,
    Act_Help_2,
    Act_Help_3,
    Act_MainMenu,
    Act_GameMenu,
    Act_Next,
    Act_Restart,
    Act_Resume,
    Act_Return,
    Act_Sound,
    Act_MenuGameEnable,
    Act_Sound_Fan_Raise
};

enum Stats
{
    Stat_MenuMain,
    Stat_MenuSelect,
    Stat_MenuSettings,
    Stat_Start,
    Stat_Play,
    Stat_Win,
    Stat_Lose,
    Stat_Pause,
    Stat_Next,
    Stat_Null,
    Stat_Resume,
    Stat_Help
};

struct Object
{
    GLuint Texture;
    float Vertex[8];
    float Position[2];
};

struct Object_digit
{
    GLuint Texture[10];
    float Vertex[8];
    float Position[2];
    float Relative[2];
};

struct Button
{
    struct Object But;
    float Position[2];
    float Width;
    float Height;
    bool Touch;
};

struct LevelData
{
    float Position[2];
    int Score;
    int Stars;
    bool Used;
    bool Enable;
    bool Touch;
};

struct Timer
{
    double Time_Start;
    double Time_Set;
    enum Actions Action;
};

struct TimeSys
{
    double Time_Total;
    double Time_Elapsed;
    double Time_Last;
};

struct GameData
{
    struct TimeSys Time_Sys;
    int firm_id;
    float Game_Width;
    float Game_Height;
    GLKBaseEffect *effect;
    
    GLuint vertexArray;
    GLuint vertexBufferPos;
    GLuint vertexBufferTex;
    GLuint vertexBufferCol;
    GLKMatrix4 CameraMatrix;
    
    //Данные уровней
    struct LevelData *Level_Data;
    
    //Звуки
    AVAudioPlayer *Sound_Click;
    AVAudioPlayer *Sound_Fan;
    AVAudioPlayer *Sound_Star;
    AVAudioPlayer *Sound_Win;
    AVAudioPlayer *Sound_Lose;
    
    //Состояние игры
    int Status_Curent;
    int Status_Next;
    int Level_Count;
    int Score;
    int Stars;
    int Level;
    bool Sound;
    float Accel[3];
    float Draw_Scale;
};

@interface Game : NSObject
{
    //Переменные для графики
    GLuint Texture_Error;
    float Vertex_BG[8];
    float Vertex_Tex_Full[8];
    float Vertex_Col_Full[16];
    float Vertex_Col_tmp[16];
    
    struct GameData *Game_Data;
    
    int i;
    int j;
    int tmpi;
    long tmpl;
    bool tmpb;
    float tmpf;
    double tmpd;
}

-(id)init : (struct GameData*)data;

-(void)NewColor : (float*) color : (float) red : (float) green : (float) blue : (float) alpha;
-(void)CreateObject : (struct Object*)obj : (float)x : (float)y : (float)wdth : (float)hght : (GLuint)text;
-(void)CreateObjectDigit : (struct Object_digit*)obj : (float)x : (float)y : (float)wdth : (float)hght : (float) r_x : (float) r_y;
-(void)CreateButton : (struct Button*)obj : (float)x : (float)y : (float)wdth : (float)hght : (GLuint)text : (float)x_b : (float)y_b : (float)wdth_b : (float)hgth_b;

-(void)ResetLevelTouch;

-(void)TimerSet : (struct Timer*)sel : (float)set : (enum Actions)act;
-(bool)TimerGet : (struct Timer*)sel;

-(bool)Button_Touched : (struct Button*)sel : (float)x : (float)y;
-(bool)Location_Touched : (float)x : (float)y : (float)p_x : (float)p_y : (int)wdth : (int)hght;

-(GLuint)loadTexture : (NSString*)name;
-(void)Check_Data;
-(void)Reset_Data;
-(void)Save_Data;
-(bool)Load_Data;

-(void)BindBuffer : (float*)buf_pos : (float*)buf_tex : (float*)buf_col;
-(void)DrawBG : (GLuint*)texture;
-(void)DrawObject : (struct Object*)obj;
-(void)DrawObjectDigit : (struct Object_digit*)obj : (int) count : (int)num;
-(void)DrawButton : (struct Button*)obj;

-(AVAudioPlayer*)CreateSound : (NSString*)name : (int)loops;
@end


    /*
@protocol Game
@required
- (void)CreateObject : (struct Object*)obj : (float)x : (float)y : (float) o_x : (float) o_y : (float)width : (float)height : (GLuint)text : (float)rows : (float)cols;
- (void)CreateObjectDigit : (struct Object_digit*)obj : (float)width : (float)height : (float) r_x : (float) r_y;
- (void)TimerSet : (long)time : (long)set : (enum Actions)act;
- (void)TimerGet : (long)time;
- (GLuint)loadTexture : (NSString*)name;
@end
*/
#endif
