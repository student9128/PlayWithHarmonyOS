import { httpPost } from '../../http/HttpUtils'
import LogUtils from '../../utils/LogUtils'
import router from '@ohos.router'
import { display } from '@kit.ArkUI'
import { ArrayList } from '@kit.ArkTS'
import { HomePage } from '../../pages/demo/HomePage'
import { HarmonyOSDevPage } from '../../pages/demo/HarmonyOSDevPage'
import { ToolPage } from '../../pages/demo/ToolPage'

@Component
export struct ApiPage {
  private tabController: TabsController = new TabsController()

  aboutToAppear(): void {
    display.getAllDisplays((err, data) => {
      let screenWidth: number = data[0].width
      let screenHeight: number = data[0].height
      console.log('width = ' + screenWidth + 'height = ' + screenHeight)
    })
  }

  icons: string[] = ['sys.symbol.house', 'sys.symbol.heart', 'sys.symbol.square',]
  @State showSideBar: boolean = false
  @State currentIndex: number = 0;
  pageInfos: NavPathStack = new NavPathStack()
  isUseInterception: boolean = false;

  build() {
    SideBarContainer(SideBarContainerType.Embed) {
      Column() {
        ForEach(this.icons, (item: string, index: number) => {
          SymbolGlyph($r(item))
            .fontSize(48)
            .fontColor([this.currentIndex == index ? $r('app.color.tab_active_color'):$r('app.color.tab_normal_color')])
            .margin({ top: 10 })
            .onClick(() => {
              this.currentIndex = index
            })
        })
      }
      .height('100%')
      .backgroundColor($r('app.color.start_window_background'))
      .padding({top:48,bottom:48})

      Column() {
        if (this.currentIndex == 0) {
          HomePage()
        }
        if (this.currentIndex == 1) {
          HarmonyOSDevPage()
        }
        if (this.currentIndex == 2) {
          ToolPage()
        }
      }
    }
    .controlButton({ top: 0 })
    .showControlButton(true)
    .showSideBar(this.showSideBar)
    .sideBarWidth(150)
    .minSideBarWidth(50)
    .maxSideBarWidth(300)
    .minContentWidth(0)
    .onChange((value: boolean) => {
      console.info('status:' + value)
      this.showSideBar=value
    })
    .animation({ duration: 500 })
    .autoHide(false)
  }

  //   build() {
  //     Column() {
  //       Image($r('app.media.icon')).width(50).height(50).onClick(()=>{
  // router.pushUrl({url:'pages/DrawerLayoutPage'})
  //       })
  //       Tabs({ barPosition: BarPosition.Start, controller: this.tabController }){
  //         TabContent(){
  //           Text('tab1')
  //         }.tabBar('tab1')
  //         TabContent(){
  //           Text('tab2')
  //         }.tabBar('tab2')
  //
  //       }
  //       Button('测试',).onClick(() => {
  //         let url = 'https://www.wanandroid.com/user/login'
  //         // axios.post<string, AxiosResponse<string>>(url, { "username": "test", "password": "123456" })
  //         //   .then(value => {
  //         //     console.log(`value=${JSON.stringify(value)}`)
  //         //     LogUtils.printInfo(`${JSON.stringify(value)}`)
  //         // }).catch(error => {
  //         //   console.log(`error=${error}`)
  //         // })
  //         httpPost(url,{ "username": "test01", "password": "123456" }).then((value:ESObject)=>{
  //           LogUtils.printInfo(`response=${JSON.stringify(value)}`)
  //         }).catch((error:ESObject)=>{
  //           LogUtils.printInfo(`error=${JSON.stringify(error)}`)
  //         });
  //       })
  //     }.width('100%')
  //     .height('100%')
  //     // .backgroundColor(0x2196f3)
  //
  //   }
}

