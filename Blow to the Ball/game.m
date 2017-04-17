//
//  BlowToTheBall
//
//  Created by Negulus on 2/23/13.
//  Copyright (c) 2013 Negulus. All rights reserved.
//

#import <GLKit/GLKit.h>

#import "game.h"

@implementation Game

NSString *Texture_Path_tmp;
GLKTextureInfo *Texture_Info_tmp;

-(id)init : (struct GameData*)data
{
    self = [super init];
    if (self)
    {
        Game_Data = data;
        i = 0;
        tmpb = false;
        
        Vertex_BG[0] = 0.0f;
        Vertex_BG[1] = 0.0f;
        Vertex_BG[2] = 1024.0f;
        Vertex_BG[3] = 0.0f;
        Vertex_BG[4] = 0.0f;
        Vertex_BG[5] = 1024.0f;
        Vertex_BG[6] = 1024.0f;
        Vertex_BG[7] = 1024.0f;
        
        Vertex_Tex_Full[0] = 0.0f;
        Vertex_Tex_Full[1] = 1.0f;
        Vertex_Tex_Full[2] = 1.0f;
        Vertex_Tex_Full[3] = 1.0f;
        Vertex_Tex_Full[4] = 0.0f;
        Vertex_Tex_Full[5] = 0.0f;
        Vertex_Tex_Full[6] = 1.0f;
        Vertex_Tex_Full[7] = 0.0f;
        
        [self NewColor : Vertex_Col_Full : 1.0f : 1.0f : 1.0f : 1.0f];
        [self NewColor : Vertex_Col_tmp : 1.0f : 1.0f : 1.0f : 1.0f];
    }
    return self;
}

- (void)NewColor : (float*) color : (float) red : (float) green : (float) blue : (float) alpha
{
    color[0] = red;
    color[1] = green;
    color[2] = blue;
    color[3] = alpha;
    color[4] = red;
    color[5] = green;
    color[6] = blue;
    color[7] = alpha;
    color[8] = red;
    color[9] = green;
    color[10] = blue;
    color[11] = alpha;
    color[12] = red;
    color[13] = green;
    color[14] = blue;
    color[15] = alpha;
}

- (void)Check_Data
{
    for (i = 0; i < Game_Data->Level_Count; i++)
    {
        tmpb = true;
        if (i >= 0)
        {
            Game_Data->Level_Data[i].Enable = true;
            tmpb = false;
        }
        else if (i < 6)
        {
            if (Game_Data->Level_Data[i - 1].Enable && (Game_Data->Level_Data[i - 1].Stars > 0))
            {
                Game_Data->Level_Data[i].Enable = true;
                tmpb = false;
            }
        }
        else
        {
            if (Game_Data->Level_Data[i - 2].Enable && Game_Data->Level_Data[i - 1].Enable)
            {
                if (Game_Data->Level_Data[i - 2].Stars > 0)
                {
                    Game_Data->Level_Data[i].Enable = true;
                    tmpb = false;
                }
                else if (Game_Data->Level_Data[i].Stars > 0)
                {
                    Game_Data->Level_Data[i].Enable = true;
                    tmpb = false;
                }
            }
        }
        if (tmpb)
            Game_Data->Level_Data[i].Enable = false;
    }
}

-(void)Reset_Data
{
    for (i = 0; i < Game_Data->Level_Count; i++)
    {
        Game_Data->Level_Data[i].Used = false;
        Game_Data->Level_Data[i].Score = 0;
        Game_Data->Level_Data[i].Stars = 0;
    }
    [self Save_Data];
}

-(NSString *) saveFilePath
{
	NSArray *path =	NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [[path objectAtIndex:0] stringByAppendingPathComponent:@"savefile.plist"];
}

-(void)Save_Data
{
    NSString *tmps[(12 + (Game_Data->Level_Count * 3))];
    
    //Запись ID сохранения
    tmps[0] = [NSString stringWithFormat:@"%d", Game_Data->firm_id];
            
    //Запись активности звука
    tmps[1] = [NSString stringWithFormat:@"%d", (int)Game_Data->Sound];

    //Запись резервных переменных   
    for (i = 2; i < 12; i++)
        tmps[i] = @"0";
        
    for (i = 0; i < Game_Data->Level_Count; i++)
    {
        tmps[12 + (i * 3)] = [NSString stringWithFormat:@"%d", (int)Game_Data->Level_Data[i].Used];
        tmps[12 + (i * 3) + 1] = [NSString stringWithFormat:@"%d", Game_Data->Level_Data[i].Score];
        tmps[12 + (i * 3) + 2] = [NSString stringWithFormat:@"%d", Game_Data->Level_Data[i].Stars];
    }
    
    NSArray *values = [NSArray arrayWithObjects:tmps count:(12 + (Game_Data->Level_Count * 3))];
    
    [values writeToFile:[self saveFilePath] atomically:YES];
}

-(bool)Load_Data
{
    NSString *myPath = [self saveFilePath];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:myPath];
    
    if (fileExists)
    {
        NSArray *values = [[NSArray alloc] initWithContentsOfFile:myPath];
        
        //Проверка ID сохранения
        if ([[values objectAtIndex:0] integerValue] != Game_Data->firm_id)
        {
            [values release];
            return false;
        }
        
        //Чтение активности звука
        if ([[values objectAtIndex:1] integerValue] > 0)
            Game_Data->Sound = true;
        else
            Game_Data->Sound = false;

        for (i = 0; i < Game_Data->Level_Count; i++)
        {       
            if ([[values objectAtIndex:(12 + (i * 3))] integerValue] > 0)
                Game_Data->Level_Data[i].Used = true;
            else
                Game_Data->Level_Data[i].Used = false;

            Game_Data->Level_Data[i].Score = [[values objectAtIndex:(12 + (i * 3) + 1)] integerValue];
            
            Game_Data->Level_Data[i].Stars = [[values objectAtIndex:(12 + (i * 3) + 2)] integerValue];
        }
        
        [values release];
        return true;
    }
    return false;
}

- (void)CreateObject : (struct Object*)obj : (float)x : (float)y : (float)wdth : (float)hght : (GLuint)text
{
    obj->Texture = text;
    obj->Vertex[0] = 0.0f;
    obj->Vertex[1] = 0.0f;
    obj->Vertex[2] = wdth;
    obj->Vertex[3] = 0.0f;
    obj->Vertex[4] = 0.0f;
    obj->Vertex[5] = hght;
    obj->Vertex[6] = wdth;
    obj->Vertex[7] = hght;
    obj->Position[0] = x;
    obj->Position[1] = y;
}

-(void)CreateObjectDigit : (struct Object_digit*)obj : (float)x : (float)y : (float)wdth : (float)hght : (float) r_x : (float) r_y
{
    obj->Vertex[0] = 0.0f;
    obj->Vertex[1] = 0.0f;
    obj->Vertex[2] = wdth;
    obj->Vertex[3] = 0.0f;
    obj->Vertex[4] = 0.0f;
    obj->Vertex[5] = hght;
    obj->Vertex[6] = wdth;
    obj->Vertex[7] = hght;
    obj->Position[0] = x;
    obj->Position[1] = y;
    obj->Relative[0] = r_x;
    obj->Relative[1] = r_y;
}

-(void)CreateButton : (struct Button*)obj : (float)x : (float)y : (float)wdth : (float)hght : (GLuint)text : (float)x_b : (float)y_b : (float)wdth_b : (float)hgth_b
{
    [self CreateObject: &obj->But : x : y : wdth : hght : text];
    obj->Position[0] = x_b;
    obj->Position[1] = y_b;
    obj->Width = wdth_b;
    obj->Height = hgth_b;
    obj->Touch = false;
}

-(void)ResetLevelTouch
{
    for (i = 0; i < Game_Data->Level_Count; i++)
    {
        Game_Data->Level_Data[i].Touch = false;
    }
}

- (void)TimerSet : (struct Timer*)sel : (float)set : (enum Actions)act
{
    sel->Time_Start = Game_Data->Time_Sys.Time_Total;
    sel->Time_Set = Game_Data->Time_Sys.Time_Total + set;
    sel->Action = act;
    return;
}

- (bool)TimerGet : (struct Timer*)sel
{
    if (sel->Time_Set <= Game_Data->Time_Sys.Time_Total)
        return true;
    else
        return false;
}

-(bool)Button_Touched : (struct Button*)sel : (float)x : (float)y
{
    if ((x > (sel->But.Position[0] + sel->Position[0])) && (x < (sel->But.Position[0] + sel->Position[0] + sel->Width)))
    {
        if ((y > (sel->But.Position[1] + sel->Position[1])) && (y < (sel->But.Position[1] + sel->Position[1] + sel->Height)))
        {
            if (Game_Data->Sound)
            {
                if (Game_Data->Sound_Click) [Game_Data->Sound_Click play];
            }
            sel->Touch = true;
            return true;
        }
    }
    sel->Touch = false;
    return false;
}

-(bool)Location_Touched : (float)x : (float)y : (float)p_x : (float)p_y : (int)wdth : (int)hght
{
    if ((x > p_x) && (x < (p_x + wdth)))
    {
        if ((y > p_y) && (y < (p_y + hght)))
        {
            return true;
        }
    }
    return false;
}

//Загрузка текстуры
-(GLuint)loadTexture : (NSString*)name
{
    NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:YES], GLKTextureLoaderOriginBottomLeft, nil];
    Texture_Path_tmp = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
    Texture_Info_tmp = [GLKTextureLoader textureWithContentsOfFile:Texture_Path_tmp options:options error:nil];
    return Texture_Info_tmp.name;
}

-(void)BindBuffer : (float*)buf_pos : (float*)buf_tex : (float*)buf_col
{
    glBindVertexArrayOES(Game_Data->vertexArray);
    glBindBuffer(GL_ARRAY_BUFFER, Game_Data->vertexBufferPos);
    glBufferData(GL_ARRAY_BUFFER, 8 * sizeof(float), buf_pos, GL_STATIC_DRAW);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 8, 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, Game_Data->vertexBufferTex);
    glBufferData(GL_ARRAY_BUFFER, 8 * sizeof(float), buf_tex, GL_STATIC_DRAW);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 8, 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, Game_Data->vertexBufferCol);
    glBufferData(GL_ARRAY_BUFFER, 16 * sizeof(float), buf_col, GL_STATIC_DRAW);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 16, 0);
}

-(void)DrawBG : (GLuint*)texture
{
    if (Game_Data->Game_Height > 1000)
    {
        Vertex_BG[5] = 1536;
        Vertex_BG[7] = 1536;
    }
    
    [self BindBuffer : Vertex_BG : Vertex_Tex_Full : Vertex_Col_Full];
    
    Game_Data->effect.texture2d0.name = *texture;
    Game_Data->effect.transform.modelviewMatrix = GLKMatrix4Translate(Game_Data->CameraMatrix, 0, 0, 0);
    [Game_Data->effect prepareToDraw];

    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

-(void)DrawObject : (struct Object*)obj
{
    [self BindBuffer : obj->Vertex : Vertex_Tex_Full : Vertex_Col_Full];
    
    Game_Data->effect.texture2d0.name = obj->Texture;
    Game_Data->effect.transform.modelviewMatrix = GLKMatrix4Translate(Game_Data->CameraMatrix, obj->Position[0], obj->Position[1], 0);
    [Game_Data->effect prepareToDraw];

    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

-(void)DrawObjectDigit : (struct Object_digit*)obj : (int) count : (int)num
{
    [self BindBuffer : obj->Vertex : Vertex_Tex_Full : Vertex_Col_Full];

    Game_Data->effect.transform.modelviewMatrix = GLKMatrix4Translate(Game_Data->CameraMatrix, obj->Position[0], obj->Position[1], 0);
    
    i = num % 100;
    j = i % 10;
    
    if (count >= 3)
    {
        Game_Data->effect.texture2d0.name = obj->Texture[((num - i) / 100)];
        [Game_Data->effect prepareToDraw];
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        Game_Data->effect.transform.modelviewMatrix = GLKMatrix4Translate(Game_Data->effect.transform.modelviewMatrix, obj->Relative[0], obj->Relative[1], 0);
    }
    
    if (count >= 2)
    {
        Game_Data->effect.texture2d0.name = obj->Texture[((i-j) / 10)];
        [Game_Data->effect prepareToDraw];
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        Game_Data->effect.transform.modelviewMatrix = GLKMatrix4Translate(Game_Data->effect.transform.modelviewMatrix, obj->Relative[0], obj->Relative[1], 0);
    }
    
    if (count >= 1)
    {
        Game_Data->effect.texture2d0.name = obj->Texture[j];
        [Game_Data->effect prepareToDraw];
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    }
}

-(void)DrawButton : (struct Button*)obj
{
    if (obj->Touch)
    {
        [self NewColor : Vertex_Col_tmp : 0.9f : 0.9f : 1.0f : 1.0f];
        [self BindBuffer : obj->But.Vertex : Vertex_Tex_Full : Vertex_Col_tmp];
        
        Game_Data->effect.texture2d0.name = obj->But.Texture;
        Game_Data->effect.transform.modelviewMatrix = GLKMatrix4Translate(Game_Data->CameraMatrix, obj->But.Position[0], obj->But.Position[1], 0);
        [Game_Data->effect prepareToDraw];
        
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    }
    else
    {
        [self DrawObject: &obj->But];
    }
}


-(AVAudioPlayer*)CreateSound : (NSString*)name : (int)loops
{
    AVAudioPlayer *audio;
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], name]];
    
    audio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    audio.numberOfLoops = loops;
    
    if (audio == nil)
        NSLog(@"Sound %@ error", name);
    
    return audio;
}
@end