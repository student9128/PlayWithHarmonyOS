import { ApiPage } from '../view/home/ApiPage'
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
      Text(name)
        .fontColor(this.currentIndex == index ? $r('app.color.tab_active_color') : $r('app.color.tab_normal_color'))
        .fontSize(16)
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
        }
        .barMode(BarMode.Fixed)
        .onChange((index) => {
          this.currentIndex = index
          this._title = index == 0 ? 'Study' : 'Api'
        }).backgroundColor($r('app.color.white'))
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
    .justifyContent(FlexAlign.Center)

    // .backgroundColor($r('app.color.tab_active_color'))
  }
}