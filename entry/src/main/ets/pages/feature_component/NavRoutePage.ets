import { AppTitleBar } from '../../widgets/AppTitleBar'
import { window } from '@kit.ArkUI'
import { key_window_class } from '../../common/Key'

@ComponentV2
export struct NavRoutePage {
  @Local isActiveWLAN: boolean = false
  @Local isActiveBluetooth: boolean = false
  @Local isPortrait:boolean=false

  build() {
    Column() {
      Button('切换横竖屏').onClick(()=>{
        let windowClass = AppStorage.get<window.Window>(key_window_class)
        if (this.isPortrait) {
          windowClass?.setPreferredOrientation(window.Orientation.LANDSCAPE)
        } else {
          windowClass?.setPreferredOrientation(window.Orientation.PORTRAIT)
        }
        this.isPortrait = !this.isPortrait
      })
      Navigation() {
        NavRouter() {
          Row() {
            Row()
              .width(30)
              .height(30)
              .borderRadius(30)
              .margin({ left: 3, right: 10 })
              .backgroundColor(Color.Pink)
            Text(`WLAN`)
              .fontSize(22)
              .fontWeight(500)
              .textAlign(TextAlign.Center)
          }
          .width('90%')
          .height(72)

          NavDestination() {
            Flex({ direction: FlexDirection.Row }) {
              Text('未找到可用WLAN').fontSize(30).padding({ left: 15 })
            }
          }.hideTitleBar(false).backgroundColor($r('app.color.start_window_background'))
        }.backgroundColor(this.isActiveWLAN ? '#ccc' : '#fff')
        .borderRadius(24)
        .onStateChange((isActivated: boolean) => {
          this.isActiveWLAN = isActivated
        })

        NavRouter() {
          Row() {
            Row()
              .width(30)
              .height(30)
              .borderRadius(30)
              .margin({ left: 3, right: 10 })
              .backgroundColor(Color.Pink)
            Text(`蓝牙`)
              .fontSize(22)
              .fontWeight(500)
              .textAlign(TextAlign.Center)
          }
          .width('90%')
          .height(72)

          NavDestination() {
            Flex({ direction: FlexDirection.Row }) {
              Text('未找到可用蓝牙').fontSize(30).padding({ left: 15 })
            }
          }.hideTitleBar(false).backgroundColor('#0c182431')
        }.backgroundColor(this.isActiveBluetooth ? '#ccc' : '#fff')
        .borderRadius(24)
        .onStateChange((isActivated: boolean) => {
          this.isActiveBluetooth = isActivated
        })
      }
      // 外层 NavDestination 已提供统一标题栏，这里隐藏内层标题避免双层
      .titleMode(NavigationTitleMode.Free)
      .mode(NavigationMode.Auto)
      .hideTitleBar(true)
      .hideToolBar(true)
    }.height('100%')
  }
}
@Builder
export function NavRoutePageBuilder() {
  NavDestination() {
    Column() {
      AppTitleBar({ title: 'NavRoutePage' })
      Column() {
        NavRoutePage()
      }.width('100%').layoutWeight(1)
    }.width('100%').height('100%')
  }.hideTitleBar(true)
}
