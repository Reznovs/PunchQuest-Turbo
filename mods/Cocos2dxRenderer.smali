.class public Lorg/cocos2dx/lib/Cocos2dxRenderer;
.super Ljava/lang/Object;
.source "Cocos2dxRenderer.java"

# interfaces
.implements Landroid/opengl/GLSurfaceView$Renderer;


# static fields
.field private static final NANOSECONDSPERMINISECOND:J = 0xf4240L

.field private static final NANOSECONDSPERSECOND:J = 0x3b9aca00L

.field private static animationInterval:J

.field private static nativeInitialized:Z


# instance fields
.field private last:J

.field private screenHeight:I

.field private screenWidth:I


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .prologue
    .line 48
    const-wide/32 v0, 0xfe502a

    sput-wide v0, Lorg/cocos2dx/lib/Cocos2dxRenderer;->animationInterval:J

    .line 49
    const/4 v0, 0x0

    sput-boolean v0, Lorg/cocos2dx/lib/Cocos2dxRenderer;->nativeInitialized:Z

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 45
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static native nativeDeleteBackward()V
.end method

.method private static native nativeGetContentText()Ljava/lang/String;
.end method

.method private static native nativeInit(II)V
.end method

.method private static native nativeInsertText(Ljava/lang/String;)V
.end method

.method private static native nativeKeyDown(I)Z
.end method

.method private static native nativeRender()V
.end method

.method private static native nativeSurfaceChanged(II)V
.end method

.method private static native nativeTouchesBegin(IFFJ)V
.end method

.method private static native nativeTouchesCancel([I[F[FJ)V
.end method

.method private static native nativeTouchesEnd(IFFJ)V
.end method

.method private static native nativeTouchesMove([I[F[FJ)V
.end method

.method public static setAnimationInterval(D)V
    .locals 2
    .param p0, "interval"    # D

    .prologue
    .line 144
    const-wide v0, 0x41cdcd6500000000L    # 1.0E9

    mul-double/2addr v0, p0

    double-to-long v0, v0

    sput-wide v0, Lorg/cocos2dx/lib/Cocos2dxRenderer;->animationInterval:J

    .line 145
    return-void
.end method


# virtual methods
.method public getContentText()Ljava/lang/String;
    .locals 1

    .prologue
    .line 169
    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxRenderer;->nativeGetContentText()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public handleActionCancel([I[F[FJ)V
    .locals 0
    .param p1, "id"    # [I
    .param p2, "x"    # [F
    .param p3, "y"    # [F
    .param p4, "timestamp"    # J

    .prologue
    .line 130
    invoke-static {p1, p2, p3, p4, p5}, Lorg/cocos2dx/lib/Cocos2dxRenderer;->nativeTouchesCancel([I[F[FJ)V

    .line 131
    return-void
.end method

.method public handleActionDown(IFFJ)V
    .locals 0
    .param p1, "id"    # I
    .param p2, "x"    # F
    .param p3, "y"    # F
    .param p4, "timestamp"    # J

    .prologue
    .line 120
    invoke-static {p1, p2, p3, p4, p5}, Lorg/cocos2dx/lib/Cocos2dxRenderer;->nativeTouchesBegin(IFFJ)V

    .line 121
    return-void
.end method

.method public handleActionMove([I[F[FJ)V
    .locals 0
    .param p1, "id"    # [I
    .param p2, "x"    # [F
    .param p3, "y"    # [F
    .param p4, "timestamp"    # J

    .prologue
    .line 135
    invoke-static {p1, p2, p3, p4, p5}, Lorg/cocos2dx/lib/Cocos2dxRenderer;->nativeTouchesMove([I[F[FJ)V

    .line 136
    return-void
.end method

.method public handleActionUp(IFFJ)V
    .locals 0
    .param p1, "id"    # I
    .param p2, "x"    # F
    .param p3, "y"    # F
    .param p4, "timestamp"    # J

    .prologue
    .line 125
    invoke-static {p1, p2, p3, p4, p5}, Lorg/cocos2dx/lib/Cocos2dxRenderer;->nativeTouchesEnd(IFFJ)V

    .line 126
    return-void
.end method

.method public handleDeleteBackward()V
    .locals 0

    .prologue
    .line 165
    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxRenderer;->nativeDeleteBackward()V

    .line 166
    return-void
.end method

.method public handleInsertText(Ljava/lang/String;)V
    .locals 0
    .param p1, "text"    # Ljava/lang/String;

    .prologue
    .line 161
    invoke-static {p1}, Lorg/cocos2dx/lib/Cocos2dxRenderer;->nativeInsertText(Ljava/lang/String;)V

    .line 162
    return-void
.end method

.method public handleKeyDown(I)V
    .locals 0
    .param p1, "keyCode"    # I

    .prologue
    .line 140
    invoke-static {p1}, Lorg/cocos2dx/lib/Cocos2dxRenderer;->nativeKeyDown(I)Z

    .line 141
    return-void
.end method

.method public onDrawFrame(Ljavax/microedition/khronos/opengles/GL10;)V
    .locals 4
    .param p1, "gl"    # Ljavax/microedition/khronos/opengles/GL10;

    .prologue
    .line 95
    invoke-static {}, Lcom/noodlecake/lib/uikit/UIApplication;->processActivationLifecycleEvents()V

    .line 98
    invoke-static {}, Lcom/noodlecake/lib/uikit/UIAccelerometer;->processAccelerometerData()V

    # 优化：移除 Thread.sleep() 帧率节流
    # 原代码用 sleep 限制帧率，在新 Android 上 sleep 精度极差
    # 导致不充电时 CPU 降频 + sleep 超时 = 严重卡顿
    # GLSurfaceView 的 RENDERMODE_CONTINUOUSLY 自带 VSync 对齐（~60fps）
    # 不需要手动 sleep 限帧，系统已经每 ~16.67ms 回调一次 onDrawFrame

    .line 105
    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxRenderer;->nativeRender()V

    .line 116
    return-void
.end method

.method public onSurfaceChanged(Ljavax/microedition/khronos/opengles/GL10;II)V
    .locals 3
    .param p1, "gl"    # Ljavax/microedition/khronos/opengles/GL10;
    .param p2, "w"    # I
    .param p3, "h"    # I

    .prologue
    .line 79
    const-string v0, "noodle"

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "onSurfaceChanged: "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, ":"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 82
    sget-boolean v0, Lorg/cocos2dx/lib/Cocos2dxRenderer;->nativeInitialized:Z

    if-nez v0, :cond_0

    .line 83
    const/4 v0, 0x1

    sput-boolean v0, Lorg/cocos2dx/lib/Cocos2dxRenderer;->nativeInitialized:Z

    .line 84
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxRenderer;->screenWidth:I

    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxRenderer;->screenHeight:I

    invoke-static {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxRenderer;->nativeInit(II)V

    .line 85
    invoke-static {}, Ljava/lang/System;->nanoTime()J

    move-result-wide v0

    iput-wide v0, p0, Lorg/cocos2dx/lib/Cocos2dxRenderer;->last:J

    .line 88
    :cond_0
    invoke-static {p2, p3}, Lorg/cocos2dx/lib/Cocos2dxRenderer;->nativeSurfaceChanged(II)V

    .line 89
    return-void
.end method

.method public onSurfaceCreated(Ljavax/microedition/khronos/opengles/GL10;Ljavax/microedition/khronos/egl/EGLConfig;)V
    .locals 2
    .param p1, "gl"    # Ljavax/microedition/khronos/opengles/GL10;
    .param p2, "config"    # Ljavax/microedition/khronos/egl/EGLConfig;

    .prologue
    .line 65
    const-string v0, "noodle"

    const-string v1, "onSurfaceCreated"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 68
    const/4 v0, 0x1

    sput-boolean v0, Lorg/cocos2dx/lib/Cocos2dxRenderer;->nativeInitialized:Z

    .line 69
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxRenderer;->screenWidth:I

    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxRenderer;->screenHeight:I

    invoke-static {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxRenderer;->nativeInit(II)V

    .line 70
    invoke-static {}, Ljava/lang/System;->nanoTime()J

    move-result-wide v0

    iput-wide v0, p0, Lorg/cocos2dx/lib/Cocos2dxRenderer;->last:J

    .line 71
    return-void
.end method

.method public screenHeight()I
    .locals 1

    .prologue
    .line 61
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxRenderer;->screenHeight:I

    return v0
.end method

.method public screenWidth()I
    .locals 1

    .prologue
    .line 56
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxRenderer;->screenWidth:I

    return v0
.end method

.method public setScreenWidthAndHeight(II)V
    .locals 0
    .param p1, "w"    # I
    .param p2, "h"    # I

    .prologue
    .line 74
    iput p1, p0, Lorg/cocos2dx/lib/Cocos2dxRenderer;->screenWidth:I

    .line 75
    iput p2, p0, Lorg/cocos2dx/lib/Cocos2dxRenderer;->screenHeight:I

    .line 76
    return-void
.end method
