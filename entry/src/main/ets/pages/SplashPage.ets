import { display, router, ThemeControl, window } from '@kit.ArkUI'
import { ScreenUtils } from '../utils/ScreenUtils';
import { GreenColors, PageCustomTheme } from '../common/Theme';
import { key_window_class } from '../common/Key';

@Entry
@ComponentV2
struct SplashPage {
  @Local timeCount: number = 5;
  @Local interval: number | undefined = undefined
  @Local pageOpacity:number = 1
  aboutToAppear(): void {
    ThemeControl.setDefaultTheme(new PageCustomTheme(new GreenColors()))
    ScreenUtils.init(375,812)
    display.getAllDisplays((err, data) => {
      let screenWidth: number = data[0].width
      let screenHeight: number = data[0].height
      console.log('init width = ' + screenWidth + 'height = ' + screenHeight)
    })
    let windowClass = AppStorage.get<window.Window>(key_window_class)
    // windowClass?.setImmersiveModeEnabledState(true)
    this.interval = setInterval(() => {
      this.timeCount--;
      if(this.timeCount==1){
        this.getUIContext()?.animateTo({duration:1200,curve:Curve.ExtremeDeceleration},()=>{
          this.pageOpacity=0.5
        })
      }
      if (this.timeCount == 0) {
        // windowClass?.setImmersiveModeEnabledState(false)
        // windowClass?.setWindowLayoutFullScreen(false)
        router.replaceUrl({ url: 'pages/Index' })

      }
    }, 1000)
  }
  onPageShow(): void {
    display.getAllDisplays((err, data) => {
      let screenWidth: number = data[0].width
      let screenHeight: number = data[0].height
      console.log('onpageshow width = ' + screenWidth + 'height = ' + screenHeight)
    })
  }
  onDidBuild(): void {
    console.log('did build')
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
      Text('跳过')
        .backgroundColor(Color.Gray)
        .borderRadius(10)
        .padding({ left: 15, right: 15 })
        .alignRules({
          top: { anchor: "__container__", align: VerticalAlign.Top },
          left: { anchor: "__container__", align: HorizontalAlign.Start }
        })
        .margin({ left: 15 })
        .onClick(() => {
          clearInterval(this.interval)
          router.replaceUrl({ url: 'pages/Index' })
        })
    }.width('100%').height('100%').opacity(this.pageOpacity)
  }
}