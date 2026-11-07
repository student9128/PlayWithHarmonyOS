import { ApiPage } from '../view/home/ApiPage'
import { MePage } from '../view/home/MePage'
import { StudyList } from '../view/home/StudyList'
import { window } from '@kit.ArkUI'
import { key_window_class } from '../common/Key'
import { AppRadius, Constants } from '../common/AppConstants'

@Entry
@ComponentV2
struct Index {
  /** 全栈唯一的导航栈，由 @Provider 提供给所有 NavDestination 内的组件 */
  @Provider(Constants.pageNavStack) pageNavStack: NavPathStack = Constants.navStack
  @Local currentIndex: number = 0
  private tabController: TabsController = new TabsController()
  private windowClass: window.Window | undefined = undefined

  aboutToAppear(): void {
    this.windowClass = AppStorage.get<window.Window>(key_window_class)
  }

  onPageHide(): void {
    this.windowClass?.setImmersiveModeEnabledState(false)
  }

  @Builder
  TabBuilder(index: number, name: string) {
    Column() {
      Column() {
        Text(name)
          .fontColor(this.currentIndex == index ? $r('app.color.app_primary') :
            $r('app.color.app_on_surface_variant'))
          .fontSize(16)
      }
      .width(100)
      .height(40)
      .justifyContent(FlexAlign.Center)
      .borderRadius(AppRadius.item)
      .backgroundColor(this.currentIndex == index ? $r('app.color.app_primary_container') :
        $r('app.color.transparent'))
    }.height(56)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Navigation(this.pageNavStack) {
      Tabs({ barPosition: BarPosition.End, controller: this.tabController }) {
        TabContent() {
          Column() {
            StudyList()
          }.width('100%').height('100%')
        }.tabBar(this.TabBuilder(0, 'Study'))

        TabContent() {
          Column() {
            ApiPage()
          }.width('100%').height('100%')
        }.tabBar(this.TabBuilder(1, 'Api'))

        TabContent() {
          Column() {
            MePage()
          }.width('100%').height('100%')
        }.tabBar(this.TabBuilder(2, 'Me'))
      }
      .barMode(BarMode.Fixed)
      .onChange((index: number) => {
        this.currentIndex = index
      })
      .barOverlap(true)
      .barBackgroundBlurStyle(BlurStyle.Regular)
      .animationDuration(0)
      // .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
    }
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
  }
}
