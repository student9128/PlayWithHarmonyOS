import { ApiPage } from '../view/home/ApiPage'
import { MePage } from '../view/home/MePage'
import { StudyList } from '../view/home/StudyList'

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#007DFF'
  @State currentIndex: number = 0
  @State _title: string = "Study";
  private tabController: TabsController = new TabsController()

  @Builder
  TabBuilder(index: number, name: string) {
    Column() {
      Column() {
        Text(name)
          .fontColor($r('app.color.tab_normal_color'))
          .fontSize(16)
      }
      .width(100)
      .height(40)
      .justifyContent(FlexAlign.Center)
      .borderRadius(20)
      .backgroundColor(this.currentIndex == index ? $r('app.color.color_primary_opacity_30') :
      $r('app.color.transparent'))
    }.height(56)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      Navigation() {
        Tabs({ barPosition: BarPosition.End, controller: this.tabController }) {
          TabContent() {
            Column() {
              StudyList()

            }.width('100%').height('100%')
          }.tabBar(this.TabBuilder(0, 'Study')).backgroundColor($r('app.color.background_color'))

          TabContent() {
            Column() {
              ApiPage()
            }.width('100%').height('100%')
          }.tabBar(this.TabBuilder(1, 'Api')).backgroundColor($r('app.color.background_color'))
          TabContent() {
            Column() {
              MePage()
            }.width('100%').height('100%')
          }.tabBar(this.TabBuilder(2, 'Me')).backgroundColor($r('app.color.background_color'))
        }
        .barMode(BarMode.Fixed)
        .onChange((index) => {
          this.currentIndex = index
          this._title = index == 0 ? 'Study' : index == 1 ? 'Api' : 'Me'
        }).barOverlap(true).barBackgroundBlurStyle(BlurStyle.Regular)
      }.title(this.NavigationTitle())
      .titleMode(NavigationTitleMode.Mini)
      .hideBackButton(true)
      .align(Alignment.Center)

      // .margin({left:-25})
    }
  }

  @Builder
  NavigationTitle() {
    Row() {
      Text(this._title)
        .fontWeight(FontWeight.Bold)
        .fontSize(20)
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)

    // .backgroundColor($r('app.color.tab_active_color'))
  }
}