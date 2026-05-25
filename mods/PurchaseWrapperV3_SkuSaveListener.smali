.class Lcom/noodlecake/iapv3/PurchaseWrapperV3$SkuSaveOnIabPurchaseFinishedListener;
.super Ljava/lang/Object;
.source "PurchaseWrapperV3.java"

# interfaces
.implements Lcom/noodlecake/iapv3/IabHelper$OnIabPurchaseFinishedListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/noodlecake/iapv3/PurchaseWrapperV3;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = "SkuSaveOnIabPurchaseFinishedListener"
.end annotation


# instance fields
.field private sku:Ljava/lang/String;


# direct methods
.method public constructor <init>(Ljava/lang/String;)V
    .locals 1
    .param p1, "sku"    # Ljava/lang/String;

    .prologue
    .line 122
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 120
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/noodlecake/iapv3/PurchaseWrapperV3$SkuSaveOnIabPurchaseFinishedListener;->sku:Ljava/lang/String;

    .line 123
    iput-object p1, p0, Lcom/noodlecake/iapv3/PurchaseWrapperV3$SkuSaveOnIabPurchaseFinishedListener;->sku:Ljava/lang/String;

    .line 124
    return-void
.end method


# virtual methods
.method public onIabPurchaseFinished(Lcom/noodlecake/iapv3/IabResult;Lcom/noodlecake/iapv3/Purchase;)V
    .locals 3
    .param p1, "result"    # Lcom/noodlecake/iapv3/IabResult;
    .param p2, "purchase"    # Lcom/noodlecake/iapv3/Purchase;

    .prologue
    # ====== 破解：购买回调直接走成功路径 ======
    # 无论实际购买是否成功，都走 SUCCESS 分支
    # 保存购买标记
    invoke-static {}, Lcom/noodlecake/iapv3/PurchaseWrapperV3;->access$9()V

    # 通知 native 层购买成功：handleMessage(sku, SUCCESS.ordinal=0)
    iget-object v0, p0, Lcom/noodlecake/iapv3/PurchaseWrapperV3$SkuSaveOnIabPurchaseFinishedListener;->sku:Ljava/lang/String;

    const/4 v1, 0x0

    invoke-static {v0, v1}, Lcom/noodlecake/iapv3/PurchaseWrapperV3;->access$8(Ljava/lang/String;I)V

    return-void
    # ====== 破解结束 ======
.end method
