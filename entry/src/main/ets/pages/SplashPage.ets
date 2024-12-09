import { router } from '@kit.ArkUI'
import { url } from '@kit.ArkTS'

@Entry
@Component
struct SplashPage {
  @State timeCount: number = 5;

  aboutToAppear(): void {
    setInterval(() => {
      this.timeCount--;
      if (this.timeCount == 0) {
        router.replaceUrl({ url: 'pages/Index' })
      }
    }, 1000)
  }

  build() {
    RelativeContainer() {
      Image('https://gips2.baidu.com/it/u=1651586290,17201034&fm=3028&app=3028&f=JPEG&fmt=auto&q=100&size=f600_800')
        .width('100%')
        .height('100%').expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      Text(`${this.timeCount}秒`)
        .backgroundColor(Color.Gray)
        .borderRadius(10)
        .padding({ left: 15, right: 15 })
        .alignRules({
          top: { anchor: "__container__", align: VerticalAlign.Top },
          right: { anchor: "__container__", align: HorizontalAlign.End }
        })
        .margin({ right: 15 })
    }.width('100%').height('100%')
  }
}