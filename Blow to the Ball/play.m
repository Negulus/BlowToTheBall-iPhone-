//
//  BlowToTheBall
//
//  Created by Negulus on 2/23/13.
//  Copyright (c) 2013 Negulus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "play.h"

@implementation Play
-(id)init : (struct GameData*)data
{
    self = [super init : data];
    if (self)
    {
        touch = false;
        
        //Инициалзация главных точек игры
        Position_Game[0] = 320;//Center[0];
        Position_Game[1] = 328;
        
        //Загрузка объектов
        Texture_Error = [self loadTexture:@"error"];
        Background = [self loadTexture:@"background"];
        
        Graph_on = [self loadTexture:@"graph"];
        Graph_off = [self loadTexture:@"graph_off"];
        
        if (Game_Data->Game_Height > 1000)
            tmpf = (Game_Data->Game_Height - 500);
        else
            tmpf = (Game_Data->Game_Height - 476);
        
        [self CreateObject: &Vent : /*(Center[0] - 272)*/48 : tmpf : 512 : 512 : [self loadTexture:@"vent"]];
        
        Position_Start[0] = 320;//Center[0];
        Position_Start[1] = tmpf + 174;
        
        [self CreateObject: &Post_G : Vent.Position[0] : Vent.Position[1] : 128 : 64 : [self loadTexture:@"post_green"]];
        [self CreateObject: &Post_Y : Vent.Position[0] : Vent.Position[1] : 128 : 64 : [self loadTexture:@"post_yellow"]];
        [self CreateObject: &Post_R : Vent.Position[0] : Vent.Position[1] : 128 : 64 : [self loadTexture:@"post_red"]];
        [self CreateObject: &Timer_Obj : 34 : (Vent.Position[1] + 64) : 128 : 64 : [self loadTexture:@"timer_bg"]];
        [self CreateObject: &Record : 24 : 20 : 256 : 64 : [self loadTexture:@"record"]];
        [self CreateObject: &Score : 410 : Record.Position[1] : 256 : 64 : [self loadTexture:@"score"]];
        [self CreateObject: &Graph_L : Timer_Obj.Position[0] : (Timer_Obj.Position[1] + 84) : 128 : 256 : Graph_off];
        [self CreateObject: &Graph_R : (512 - Graph_L.Position[0]) : (Graph_L.Position[1]) : 128 : 256 : Graph_off];
        [self CreateObject: &Arrow_BG : /*(Center[0] - 256)*/64 : 100 : 512 : 32 : [self loadTexture:@"arrow_bg"]];
        [self CreateObject: &Arrow : Arrow_BG.Position[0] : Arrow_BG.Position[1] : 512 : 32 : [self loadTexture:@"arrow"]];
        [self CreateObject: &Zone : (Position_Game[0] - 256) : (Position_Game[1] - 256) : 512 : 512 : [self loadTexture:@"zone"]];
        [self CreateButton: &Button_Pause : 16 : 134 : 128 : 128 : [self loadTexture:@"button_pause"] : 0 : 0 : 128 : 128];
        [self CreateObject: &Star : 0 : 0 : 64 : 64 : [self loadTexture:@"star"]];
        Star.Vertex[0] = -32;
        Star.Vertex[1] = -32;
        Star.Vertex[2] = 32;
        Star.Vertex[3] = -32;
        Star.Vertex[4] = -32;
        Star.Vertex[5] = 32;
        Star.Vertex[6] = 32;
        Star.Vertex[7] = 32;
        
        [self CreateObjectDigit : &Timer_Digit : (Timer_Obj.Position[0] + 8) : Timer_Obj.Position[1] : 32 : 64 : 40 : 0];
        Timer_Digit.Texture[0] = [self loadTexture:@"timer_0"];
        Timer_Digit.Texture[1] = [self loadTexture:@"timer_1"];
        Timer_Digit.Texture[2] = [self loadTexture:@"timer_2"];
        Timer_Digit.Texture[3] = [self loadTexture:@"timer_3"];
        Timer_Digit.Texture[4] = [self loadTexture:@"timer_4"];
        Timer_Digit.Texture[5] = [self loadTexture:@"timer_5"];
        Timer_Digit.Texture[6] = [self loadTexture:@"timer_6"];
        Timer_Digit.Texture[7] = [self loadTexture:@"timer_7"];
        Timer_Digit.Texture[8] = [self loadTexture:@"timer_8"];
        Timer_Digit.Texture[9] = [self loadTexture:@"timer_9"];
        
        [self CreateObjectDigit : &Score_Digit : (Score.Position[0] + 104) : Score.Position[1] : 64 : 64 : 30 : 0];
        Score_Digit.Texture[0] = [self loadTexture:@"score_0"];
        Score_Digit.Texture[1] = [self loadTexture:@"score_1"];
        Score_Digit.Texture[2] = [self loadTexture:@"score_2"];
        Score_Digit.Texture[3] = [self loadTexture:@"score_3"];
        Score_Digit.Texture[4] = [self loadTexture:@"score_4"];
        Score_Digit.Texture[5] = [self loadTexture:@"score_5"];
        Score_Digit.Texture[6] = [self loadTexture:@"score_6"];
        Score_Digit.Texture[7] = [self loadTexture:@"score_7"];
        Score_Digit.Texture[8] = [self loadTexture:@"score_8"];
        Score_Digit.Texture[9] = [self loadTexture:@"score_9"];
        
        [self CreateObjectDigit : &Record_Digit : (Record.Position[0] + 134) : Record.Position[1] : 64 : 64 : 30 : 0];
        Record_Digit.Texture[0] = Score_Digit.Texture[0];
        Record_Digit.Texture[1] = Score_Digit.Texture[1];
        Record_Digit.Texture[2] = Score_Digit.Texture[2];
        Record_Digit.Texture[3] = Score_Digit.Texture[3];
        Record_Digit.Texture[4] = Score_Digit.Texture[4];
        Record_Digit.Texture[5] = Score_Digit.Texture[5];
        Record_Digit.Texture[6] = Score_Digit.Texture[6];
        Record_Digit.Texture[7] = Score_Digit.Texture[7];
        Record_Digit.Texture[8] = Score_Digit.Texture[8];
        Record_Digit.Texture[9] = Score_Digit.Texture[9];

        
        Ball_Origin[0] = 32;
        Ball_Origin[1] = 32;
        Ball_Speed[0] = 0;
        Ball_Speed[1] = 0;
        [self CreateObject: &Ball : Position_Start[0] : Position_Start[1] : 64 : 64 : [self loadTexture:@"ball"]];
        
        //Загрузка уровня
        Game_Level = [[GameLevel alloc] init : Game_Data : Position_Game];
        
        if (Game_Level->Amplitude_en)
            Graph_R.Texture = Graph_on;
        
        if (Game_Level->Wind_en)
            Graph_L.Texture = Graph_on;
        
        //Загрузка табличек помощи
        if (Game_Data->Level == 0)
        {
            [self CreateObject: &Help_Plate_1.Obj : /*(Center[0] - 80)*/240 : (Position_Game[1] + 100) : 512 : 256 : [self loadTexture:@"help_tapscreen"]];
            [self CreateObject: &Help_Plate_2.Obj : (Position_Game[0] - 256) : (Position_Game[1] - 128) : 512 : 256 : [self loadTexture:@"help_zone"]];
            [self CreateObject: &Help_Plate_3.Obj : 16 : (Vent.Position[1] + 80) : 256 : 256 : [self loadTexture:@"help_timer"]];
        }
        
        if (Game_Data->Level == 1)
        {
            [self CreateObject: &Help_Plate_1.Obj : (Position_Game[0] - 256) : (Position_Game[1] - 64) : 512 : 128 : [self loadTexture:@"help_stars"]];
        }
        
        if (Game_Data->Level == 3)
        {
            [self CreateObject: &Help_Plate_1.Obj : (Position_Game[0] - 256) : (Position_Game[1] - 128) : 512 : 256 : [self loadTexture:@"help_rotate"]];
        }
        
        if (Game_Data->Level == 6)
        {
            [self CreateObject: &Help_Plate_1.Obj : (Graph_L.Position[0] - 120) : (Graph_L.Position[1] - 220) : 512 : 256 : [self loadTexture:@"help_graph_wind"]];
            [self CreateObject: &Help_Plate_2.Obj : /*(Center[0] - 90)*/230 : (Arrow.Position[1] - 40) : 512 : 256 : [self loadTexture:@"help_wind"]];
        }
        
        if (Game_Data->Level == 10)
        {
            [self CreateObject: &Help_Plate_1.Obj : (Graph_R.Position[0] - 250) : (Graph_R.Position[1] - 220) : 512 : 256 : [self loadTexture:@"help_graph_fan"]];
        }
        
        //Инициализация игрового меню
        Menu_Game = [[MenuGame alloc] init : Game_Data];
        
        //Таймер возврата
        [self CreateObject: &Texture_Return_1 : (Position_Game[0] - 128) : (Position_Game[1] - 128) : 256 : 256 : [self loadTexture:@"return_1"]];
        [self CreateObject: &Texture_Return_2 : Texture_Return_1.Position[0] : Texture_Return_1.Position[1] : 256 : 256 : [self loadTexture:@"return_2"]];
        [self CreateObject: &Texture_Return_3 : Texture_Return_1.Position[0] : Texture_Return_1.Position[1] : 256 : 256 : [self loadTexture:@"return_3"]];
        Return_En = false;
        Return_Time = 0;
        Return_Timer = 0.5f;
        
        //Переменные для звуков
        Sound_Fan_Volume = 0.65f;
        Sound_Fan_Run = false;
        Sound_Fan_Start = 0;
        
        //Инициализация и обнуление других переменных
        Game_Wait = false;
        Game_Begin = false;
        Game_Start = false;
        Game_Run = false;
        Game_End = false;
        Draw_Win = false;
        Game_Data->Score = 0;
        Timer_Play.Action = Act_Null;
        Time_Left = (int)Game_Level->Time_Life;
	}
	return self;
}

-(void)Touch_Begin : (float)x : (float)y
{
    if (Game_Data->Status_Curent == Stat_Pause || Game_Data->Status_Curent == Stat_Win || Game_Data->Status_Curent == Stat_Lose)
        [Menu_Game Touch_Begin: x : y];
    else
    {
        if (Game_Begin && [self Button_Touched : &Button_Pause : x : y])
        {
            Game_Data->Status_Next = Stat_Pause;
        }
        else
        {
            touch = true;
        }
    }
}

-(void)Touch_End
{
    touch = false;
}

-(void)UpdatePlay
{
    //Первая загрузка
    if (!Game_Wait)
    {
        if (Game_Data->Sound)
        {
            if (Game_Data->Sound_Fan)
            {
                Game_Data->Sound_Fan.volume = Sound_Fan_Volume;
                [Game_Data->Sound_Fan play];
                Sound_Fan_Start = Game_Data->Time_Sys.Time_Total;
            }
        }
        
        [self TimerSet : &Timer_Play : 0.5f : Act_Game_Begin];
        Game_Wait = true;
        
        if (Game_Data->Level == 0)
        {
            [self Help_Start: &Help_Plate_1 : 1.0f : true : true];
            [self Help_Start: &Help_Plate_2 : 1.0f : true : true];
            [self Help_Start: &Help_Plate_3 : 1.0f : true : true];
        }
        else if (Game_Data->Level == 1)
        {
            [self Help_Start: &Help_Plate_1 : 1.0f : true : true];
        }
        else if (Game_Data->Level == 3)
        {
            [self Help_Start: &Help_Plate_1 : 1.0f : true : true];
        }
        else if (Game_Data->Level == 6)
        {
            [self Help_Start: &Help_Plate_1 : 1.0f : true : true];
            [self Help_Start: &Help_Plate_2 : 1.0f : true : true];
        }
        else if (Game_Data->Level == 10)
        {
            [self Help_Start: &Help_Plate_1 : 1.0f : true : true];
        }
    }
    
    //Начало игры после отсчёта таймера
    if (Game_Begin)
    {
        if (touch)
        {
            if (Game_Data->Sound_Fan)
                Game_Data->Sound_Fan.volume = Sound_Fan_Volume + 0.35f;
            //Влияние амплитуды
            if (Game_Level->Amplitude_en)
                Ball_Speed[1] -= (23 + (10 * Game_Level->Amplitude.CurValue)) * Game_Data->Time_Sys.Time_Elapsed;
            else
                Ball_Speed[1] -= 23 * Game_Data->Time_Sys.Time_Elapsed;
            
            Game_Start = true;
            
            //Вывод табличек помощи
            if (Game_Data->Level == 0)
            {
                [self Help_Stop: &Help_Plate_1];
                [self Help_Stop: &Help_Plate_2];
                [self Help_Stop: &Help_Plate_3];
            }
            else if (Game_Data->Level == 1)
            {
                [self Help_Stop: &Help_Plate_1];
            }
            else if (Game_Data->Level== 3)
            {
                [self Help_Stop: &Help_Plate_1];
            }
            else if (Game_Data->Level == 6)
            {
                [self Help_Stop: &Help_Plate_1];
                [self Help_Stop: &Help_Plate_2];
            }
            else if (Game_Data->Level == 10)
            {
                [self Help_Stop: &Help_Plate_1];
            }
        }
        else
        {
            if (Game_Data->Sound_Fan)
                Game_Data->Sound_Fan.volume = Sound_Fan_Volume;
        }
    }
    
    //Начало работы системы
    if (Game_Start && !Game_End)
    {
        //Влияние ветра
        if (Game_Level->Wind_en)
            Ball_Speed[0] += Game_Data->Time_Sys.Time_Elapsed * Game_Level->Wind.CurValue * 4.0f;
        
        //Влияние акселлерометра
        if (Game_Level->Accel_en)
        {
            Ball_Speed[0] += Game_Data->Time_Sys.Time_Elapsed * 12.8f * Game_Data->Accel[0];
            Ball_Speed[1] += Game_Data->Time_Sys.Time_Elapsed * 12.8f * (1 - fabs(Game_Data->Accel[0]));
        }
        else
        {
            Ball_Speed[1] += Game_Data->Time_Sys.Time_Elapsed * 12.8f;
        }
         
        //Изменение позиции
        Ball.Position[0] += Ball_Speed[0] * Game_Data->Time_Sys.Time_Elapsed * 60;
        Ball.Position[1] += Ball_Speed[1] * Game_Data->Time_Sys.Time_Elapsed * 60;
            
        //Проигрышь при попадании шарика за пределы экрана
        if (Ball.Position[0] < 0 || Ball.Position[1] < 0 || Ball.Position[0] > Game_Data->Game_Width || Ball.Position[1] > Game_Data->Game_Height)
        {
            Game_End = true;
            Game_Data->Status_Next = Stat_Lose;
        }
            
        //Расстояние от центра зоны до шарика
        tmpi = sqrt(pow(Ball.Position[0] - Position_Game[0], 2) + pow(Ball.Position[1] - Position_Game[1], 2));
            
        //Если игра началась
        if (Game_Run)
        {
            //Проигрышь при выходе шарика за пределы зоны
            if (tmpi > 175)
            {
                Game_End = true;
                Game_Data->Status_Next  = Stat_Lose;
            }
            
            //Обновление звёздочек
            tmpd = Game_Data->Time_Sys.Time_Total - GameStartTime;
            for (i = 0; i < Game_Level->Star_Count; i++)
            {
                if ([Game_Level StarUpdate: &Game_Level->Star[i] : tmpd : Ball.Position[0] : Ball.Position[1]])
                {
                    if (Game_Data->Sound)
                    {
                        if (Game_Data->Sound_Star)
                        {
                            if (Game_Data->Sound_Star.isPlaying)
                            {
                                [Game_Data->Sound_Star stop];
                            }
                            [Game_Data->Sound_Star play];
                        }
                    }
                    Game_Level->Star[i].Take = true;
                    Game_Data->Score += Game_Level->Star[i].Score;
                }
            }
                
            //выигрышь по истечении времени уровня
            if ([Game_Level Update])
            {
                Game_End = true;
                Draw_Win = true;
                Game_Data->Status_Next  = Stat_Win;
            }
                
            //Обновление таймера обратного отсчёта
            Time_Left = Game_Level->Time_Life - (int)(Game_Data->Time_Sys.Time_Total - GameStartTime);
            if (Time_Left < 0)
                Time_Left = 0;
        }
        else
        {
            //Начать игру если шарик внутри зоны
            if (tmpi < 160)
            {
                Game_Run = true;
                [Game_Level Start];
                GameStartTime = Game_Data->Time_Sys.Time_Total;
            }
        }
    }
    
    //Обновление графиков
    [Game_Level GraphLineUpdate : &Game_Level->Amplitude];
    [Game_Level GraphLineUpdate : &Game_Level->Wind];
    
    if ([self TimerGet: &Timer_Play])
    {
        switch (Timer_Play.Action)
        {
            case Act_Game_Begin:
                Game_Begin = true;
                break;
            default:
                Timer_Play.Action = Act_Null;
            break;
        }
        Timer_Play.Action = Act_Null;
    }
    
    //Обновление табличек помощи
    if (Game_Data->Level == 0 || Game_Data->Level == 1 || Game_Data->Level == 3 || Game_Data->Level == 6 || Game_Data->Level == 10)
        [self Help_Update: &Help_Plate_1];
    if (Game_Data->Level == 0 || Game_Data->Level == 6)
        [self Help_Update: &Help_Plate_2];
    if (Game_Data->Level == 0)
        [self Help_Update: &Help_Plate_3];

    //Обновление таймеров звуков
    if (Game_Data->Sound)
    {
        if (Game_Data->Sound_Fan)
        {
            if (!Sound_Fan_Run)
            {
                Sound_Fan_Volume = (Game_Data->Time_Sys.Time_Total - Sound_Fan_Start) * 0.65f;
                if (Sound_Fan_Volume > 0.65f)
                {
                    Sound_Fan_Volume = 0.65f;
                    Sound_Fan_Run = true;
                }
                else if (Sound_Fan_Volume < 0)
                    Sound_Fan_Volume = 0;
                Game_Data->Sound_Fan.volume = Sound_Fan_Volume;
            }
        }
    }
}

-(void)Update
{
    if (Game_Data->Status_Curent == Stat_Play)
    {
        if (Return_En)
        {
            if (Timer_Play.Action == Act_Null)
                [self TimerSet : &Timer_Play : Return_Timer : Act_Return];
            
            if ([self TimerGet: &Timer_Play])
            {
                switch (Timer_Play.Action)
                {
                    case Act_Return:
                        Return_Time--;
                        if (Return_Time <= 0)
                        {
                            Return_En = false;
                            GameStartTime = GameStartTime + (Game_Data->Time_Sys.Time_Total - GamePauseTime);
                            Game_Level->Amplitude.LastTime = Game_Level->Amplitude.LastTime + (Game_Data->Time_Sys.Time_Total - GamePauseTime);
                            Game_Level->Wind.LastTime = Game_Level->Wind.LastTime + (Game_Data->Time_Sys.Time_Total - GamePauseTime);
                            Game_Level->Time_Start = GameStartTime;
                            Ball_Speed[0] *= 0.2f;
                            Ball_Speed[1] *= 0.2f;
                        }
                        break;
                    default:
                        break;
                }
                Timer_Play.Action = Act_Null;
            }
        }
        else
        {
            [self UpdatePlay];
        }
    }
    else
    {
        [Menu_Game Update];
    }
}

-(void)Draw
{
    [self DrawBG : &Background];
    [self DrawObject: &Vent];
    
    if (Game_Wait && !Game_Begin && !Game_End)
        [self DrawObject: &Post_R];
    else if (!Game_Run && !Game_End)
        [self DrawObject: &Post_Y];
    else if (!Game_End)
        [self DrawObject: &Post_G];
    else if (Draw_Win)
    {
        [self DrawObject: &Post_R];
        [self DrawObject: &Post_G];
        [self DrawObject: &Post_Y];
    }
    else
    {
        [self DrawObject: &Post_R];
        [self DrawObject: &Post_Y];
    }
    
    [self DrawObject: &Record];
    [self DrawObjectDigit : &Record_Digit : 3 : Game_Data->Level_Data[Game_Data->Level].Score];
    
    [self DrawObject: &Score];
    [self DrawObjectDigit : &Score_Digit : 3 : Game_Data->Score];
    
    [self DrawObject: &Timer_Obj];
    [self DrawObjectDigit : &Timer_Digit : 3 : Time_Left];
    
    [self DrawObject: &Graph_L];
    [self DrawObject: &Graph_R];
    
    [self DrawGraph];
    [self DrawArrow];
    
    [self DrawObject: &Zone];
    
    [self DrawObjectLocal: &Button_Pause.But : 0.5f];
    
    //Вывод звёздочек
    for (i = 0; i < Game_Level->Star_Count; i++)
    {
        if (Game_Level->Star[i].Enable_Draw)
        {
            [self NewColor: Vertex_Col_tmp : 1.0f : 1.0f : 1.0f : Game_Level->Star[i].Opacity];
            [self BindBuffer : Star.Vertex : Vertex_Tex_Full : Vertex_Col_tmp];
            
            Game_Data->effect.texture2d0.name = Star.Texture;
            Game_Data->effect.transform.modelviewMatrix = GLKMatrix4Translate(Game_Data->CameraMatrix, Game_Level->Star[i].Position[0], Game_Level->Star[i].Position[1], 0);
            Game_Data->effect.transform.modelviewMatrix = GLKMatrix4Scale(Game_Data->effect.transform.modelviewMatrix, Game_Level->Star[i].Scale, Game_Level->Star[i].Scale, 1);
            [Game_Data->effect prepareToDraw];

            glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        }
    }
    
    //Рисование табличек помощи
    if (Game_Data->Level == 0 || Game_Data->Level == 1 || Game_Data->Level == 3 || Game_Data->Level == 6 || Game_Data->Level == 10)
    {
        if (Help_Plate_1.Enable)
            [self DrawObjectLocal: &Help_Plate_1.Obj : Help_Plate_1.Opacity];
    }
    if (Game_Data->Level == 0 || Game_Data->Level == 6)
    {
        if (Help_Plate_2.Enable)
            [self DrawObjectLocal: &Help_Plate_2.Obj : Help_Plate_2.Opacity];
    }
    if (Game_Data->Level == 0)
    {
        if (Help_Plate_3.Enable)
            [self DrawObjectLocal: &Help_Plate_3.Obj : Help_Plate_3.Opacity];
    }
    
    //Вывод шарика
    [self BindBuffer : Ball.Vertex : Vertex_Tex_Full : Vertex_Col_Full];
    
    Game_Data->effect.texture2d0.name = Ball.Texture;
    Game_Data->effect.transform.modelviewMatrix = GLKMatrix4Translate(Game_Data->CameraMatrix, (Ball.Position[0] - Ball_Origin[0]), (Ball.Position[1] - Ball_Origin[1]), 0);
    [Game_Data->effect prepareToDraw];

    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    if (Game_Data->Status_Curent == Stat_Pause || Game_Data->Status_Curent == Stat_Win || Game_Data->Status_Curent == Stat_Lose)
        [Menu_Game Draw];
    
    //Таймер возврата
    if (Return_En)
    {
        if (Game_Data->Status_Curent == Stat_Play)
        {
            if (Return_Time == 3)
                [self DrawObject: &Texture_Return_3];
            else if (Return_Time == 2)
                [self DrawObject: &Texture_Return_2];
            else if (Return_Time == 1)
                [self DrawObject: &Texture_Return_1];
        }
    }
}

-(void)DrawObjectLocal : (struct Object*)obj : (float)opacity
{
    [self NewColor: Vertex_Col_tmp : 1.0f : 1.0f : 1.0f : opacity];
    [self BindBuffer : obj->Vertex : Vertex_Tex_Full : Vertex_Col_tmp];
    
    Game_Data->effect.texture2d0.name = obj->Texture;
    Game_Data->effect.transform.modelviewMatrix = GLKMatrix4Translate(Game_Data->CameraMatrix, obj->Position[0], obj->Position[1], 0);
    [Game_Data->effect prepareToDraw];

    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

-(void)DrawGraph
{
    //Рисование графика
    if (Game_Level->Amplitude_en)
    {
        glLineWidth(2.0f);
        glBindBuffer(GL_ARRAY_BUFFER, Game_Data->vertexBufferTex);
        glBufferData(GL_ARRAY_BUFFER, sizeof(Vertex_Tex_Full), Vertex_Tex_Full, GL_STATIC_DRAW);
        glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
        glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 8, 0);
        
        glBindBuffer(GL_ARRAY_BUFFER, Game_Data->vertexBufferCol);
        glBufferData(GL_ARRAY_BUFFER, sizeof(Vertex_Col_Full), Vertex_Col_Full, GL_STATIC_DRAW);
        glEnableVertexAttribArray(GLKVertexAttribColor);
        glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 16, 0);
        
        Game_Data->effect.texture2d0.name = 0;
        Game_Data->effect.transform.modelviewMatrix = GLKMatrix4Translate(Game_Data->CameraMatrix, Graph_R.Position[0], Graph_R.Position[1], 0);
        [Game_Data->effect prepareToDraw];
        
        if (Game_Level->Amplitude.GraphCountUp > 0)
        {
            glBindVertexArrayOES(Game_Data->vertexArray);
            glBindBuffer(GL_ARRAY_BUFFER, Game_Data->vertexBufferPos);
            glBufferData(GL_ARRAY_BUFFER, sizeof(Game_Level->Amplitude.GraphUp), Game_Level->Amplitude.GraphUp, GL_STATIC_DRAW);
            glEnableVertexAttribArray(GLKVertexAttribPosition);
            glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 8, 0);
            glDrawElements(GL_LINES, (Game_Level->Amplitude.GraphCountUp * 2), GL_UNSIGNED_INT, Game_Level->Graph_Indices);
        }
        
        if (Game_Level->Amplitude.GraphCountDown > 0)
        {
            glBindVertexArrayOES(Game_Data->vertexArray);
            glBindBuffer(GL_ARRAY_BUFFER, Game_Data->vertexBufferPos);
            glBufferData(GL_ARRAY_BUFFER, sizeof(Game_Level->Amplitude.GraphDown), Game_Level->Amplitude.GraphDown, GL_STATIC_DRAW);
            glEnableVertexAttribArray(GLKVertexAttribPosition);
            glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 8, 0);
            glDrawElements(GL_LINES, (Game_Level->Amplitude.GraphCountDown * 2), GL_UNSIGNED_INT, Game_Level->Graph_Indices);
        }
    }
    
    if (Game_Level->Wind_en)
    {
        glLineWidth(2.0f);
        glBindBuffer(GL_ARRAY_BUFFER, Game_Data->vertexBufferTex);
        glBufferData(GL_ARRAY_BUFFER, sizeof(Vertex_Tex_Full), Vertex_Tex_Full, GL_STATIC_DRAW);
        glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
        glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 8, 0);

        glBindBuffer(GL_ARRAY_BUFFER, Game_Data->vertexBufferCol);
        glBufferData(GL_ARRAY_BUFFER, sizeof(Vertex_Col_Full), Vertex_Col_Full, GL_STATIC_DRAW);
        glEnableVertexAttribArray(GLKVertexAttribColor);
        glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 16, 0);

        Game_Data->effect.texture2d0.name = 0;
        Game_Data->effect.transform.modelviewMatrix = GLKMatrix4Translate(Game_Data->CameraMatrix, Graph_L.Position[0], Graph_L.Position[1], 0);
        [Game_Data->effect prepareToDraw];
        
        if (Game_Level->Wind.GraphCountUp > 0)
        {            
            glBindVertexArrayOES(Game_Data->vertexArray);
            glBindBuffer(GL_ARRAY_BUFFER, Game_Data->vertexBufferPos);
            glBufferData(GL_ARRAY_BUFFER, sizeof(Game_Level->Wind.GraphUp), Game_Level->Wind.GraphUp, GL_STATIC_DRAW);
            glEnableVertexAttribArray(GLKVertexAttribPosition);
            glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 8, 0);
            glDrawElements(GL_LINES, (Game_Level->Wind.GraphCountUp * 2), GL_UNSIGNED_INT, Game_Level->Graph_Indices);
        }
        
        if (Game_Level->Wind.GraphCountDown > 0)
        {
            glBindVertexArrayOES(Game_Data->vertexArray);
            glBindBuffer(GL_ARRAY_BUFFER, Game_Data->vertexBufferPos);
            glBufferData(GL_ARRAY_BUFFER, sizeof(Game_Level->Wind.GraphDown), Game_Level->Wind.GraphDown, GL_STATIC_DRAW);
            glEnableVertexAttribArray(GLKVertexAttribPosition);
            glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 8, 0);
            glDrawElements(GL_LINES, (Game_Level->Wind.GraphCountDown * 2), GL_UNSIGNED_INT, Game_Level->Graph_Indices);
        }
    }
}


//Рисование стрелок
-(void)DrawArrow
{
    if (Game_Level->Wind_en)
    {
        [self DrawObject: &Arrow_BG];

        Vertex_tmp[0] = 0;
        Vertex_tmp[1] = 0;
        Vertex_tmp[2] = Game_Level->Wind.CurValue * 190;
        Vertex_tmp[3] = 0;
        Vertex_tmp[4] = 0;
        Vertex_tmp[5] = 32;
        Vertex_tmp[6] = Vertex_tmp[2];
        Vertex_tmp[7] = Vertex_tmp[5];
            
        Vertex_tmp_2[0] = 0.5f;
        Vertex_tmp_2[1] = 0;
        Vertex_tmp_2[2] = 0.5 + Game_Level->Wind.CurValue * (190.0f/512.0f);
        Vertex_tmp_2[3] = 0;
        Vertex_tmp_2[4] = Vertex_tmp_2[0];
        Vertex_tmp_2[5] = 1.0f;
        Vertex_tmp_2[6] = Vertex_tmp_2[2];
        Vertex_tmp_2[7] = 1.0f;
            
        Position_tmp[0] = 320;//Center[0];
        Position_tmp[1] = Arrow.Position[1] - 1;
        
        [self BindBuffer : Vertex_tmp : Vertex_tmp_2 : Vertex_Col_Full];
        
        Game_Data->effect.texture2d0.name = Arrow.Texture;
        Game_Data->effect.transform.modelviewMatrix = GLKMatrix4Translate(Game_Data->CameraMatrix, Position_tmp[0], Position_tmp[1], 0);
        [Game_Data->effect prepareToDraw];
        
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    }
}

-(void)Help_Start : (struct HelpPlate*)obj : (float)life : (bool) hold : (bool) once
{
    if (!obj->Once)
    {
        obj->StartTime = Game_Data->Time_Sys.Time_Total;
        obj->TimeLife = life;
        obj->TimeRaise = 0.5f;
        obj->TimeFade = 0.5f;
        obj->Hold = hold;
        obj->Opacity = 1.0f;
        obj->Enable = true;
        obj->Once = true;
    }
}

-(void)Help_Stop : (struct HelpPlate*)obj
{
    if (obj->Hold)
    {
        obj->StartTime = Game_Data->Time_Sys.Time_Total;
        obj->TimeRaise = 0;
        obj->TimeLife = obj->TimeFade;
        obj->Hold = false;
    }
}

-(void)Help_Update : (struct HelpPlate*)obj
{
    if (obj->Enable)
    {
        if (!obj->Hold)
        {
            tmpf = Game_Data->Time_Sys.Time_Total - obj->StartTime;
            if (tmpf > (obj->TimeLife - obj->TimeFade))
            {
                obj->Opacity = (obj->TimeLife - tmpf) / obj->TimeFade;
                if (obj->Opacity < 0.01f)
                {
                    obj->Opacity = 0;
                    obj->Enable = false;
                }
            }
            else if (tmpf < obj->TimeRaise)
            {
                obj->Opacity = tmpf / obj->TimeRaise;
                if (obj->Opacity > 1)
                    obj->Opacity = 1;
            }
            else
            {
                obj->Opacity = 1;
            }
        }
        else
            obj->Opacity = 1;
    }
}

-(void)dealloc
{
    glDeleteTextures(1, &Texture_Error);
    glDeleteTextures(1, &Background);
    
    glDeleteTextures(1, &Graph_on);
    glDeleteTextures(1, &Graph_off);
    
    glDeleteTextures(1, &Ball.Texture);
    glDeleteTextures(1, &Zone.Texture);
    glDeleteTextures(1, &Vent.Texture);
    glDeleteTextures(1, &Post_G.Texture);
    glDeleteTextures(1, &Post_Y.Texture);
    glDeleteTextures(1, &Post_R.Texture);
    glDeleteTextures(1, &Arrow.Texture);
    glDeleteTextures(1, &Arrow_BG.Texture);
    glDeleteTextures(1, &Star.Texture);
    glDeleteTextures(1, &Button_Pause.But.Texture);
    
    glDeleteTextures(1, &Record.Texture);
    glDeleteTextures(1, &Score.Texture);
    glDeleteTextures(1, &Score_Digit.Texture[0]);
    glDeleteTextures(1, &Score_Digit.Texture[1]);
    glDeleteTextures(1, &Score_Digit.Texture[2]);
    glDeleteTextures(1, &Score_Digit.Texture[3]);
    glDeleteTextures(1, &Score_Digit.Texture[4]);
    glDeleteTextures(1, &Score_Digit.Texture[5]);
    glDeleteTextures(1, &Score_Digit.Texture[6]);
    glDeleteTextures(1, &Score_Digit.Texture[7]);
    glDeleteTextures(1, &Score_Digit.Texture[8]);
    glDeleteTextures(1, &Score_Digit.Texture[9]);

    glDeleteTextures(1, &Timer_Obj.Texture);
    glDeleteTextures(1, &Timer_Digit.Texture[0]);
    glDeleteTextures(1, &Timer_Digit.Texture[1]);
    glDeleteTextures(1, &Timer_Digit.Texture[2]);
    glDeleteTextures(1, &Timer_Digit.Texture[3]);
    glDeleteTextures(1, &Timer_Digit.Texture[4]);
    glDeleteTextures(1, &Timer_Digit.Texture[5]);
    glDeleteTextures(1, &Timer_Digit.Texture[6]);
    glDeleteTextures(1, &Timer_Digit.Texture[7]);
    glDeleteTextures(1, &Timer_Digit.Texture[8]);
    glDeleteTextures(1, &Timer_Digit.Texture[9]);
    
    glDeleteTextures(1, &Texture_Return_1.Texture);
    glDeleteTextures(1, &Texture_Return_2.Texture);
    glDeleteTextures(1, &Texture_Return_3.Texture);
    
    glDeleteTextures(1, &Help_Plate_1.Obj.Texture);
    glDeleteTextures(1, &Help_Plate_2.Obj.Texture);
    glDeleteTextures(1, &Help_Plate_3.Obj.Texture);
    
    [Game_Level dealloc];
    [Menu_Game dealloc];
    
	[super dealloc];
}
@end
