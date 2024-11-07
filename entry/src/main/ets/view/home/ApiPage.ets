import { httpPost } from '../../http/HttpUtils'
import LogUtils from '../../utils/LogUtils'
import router from '@ohos.router'
import { display } from '@kit.ArkUI'

@Component
export struct ApiPage {
  private tabController: TabsController = new TabsController()
  aboutToAppear(): void {
    display.getAllDisplays((err, data) => {
      let screenWidth : number = data[0].width
      let screenHeight : number = data[0].height
      console.log('width = ' + screenWidth + 'height = ' + screenHeight)
    })
  }
  build() {
    Column() {
      Image($r('app.media.icon')).width(50).height(50).onClick(()=>{
router.pushUrl({url:'pages/DrawerLayoutPage'})
      })
      Tabs({ barPosition: BarPosition.Start, controller: this.tabController }){
        TabContent(){
          Text('tab1')
        }.tabBar('tab1')
        TabContent(){
          Text('tab2')
        }.tabBar('tab2')

      }
      Button('测试',).onClick(() => {
        let url = 'https://www.wanandroid.com/user/login'
        // axios.post<string, AxiosResponse<string>>(url, { "username": "test", "password": "123456" })
        //   .then(value => {
        //     console.log(`value=${JSON.stringify(value)}`)
        //     LogUtils.printInfo(`${JSON.stringify(value)}`)
        // }).catch(error => {
        //   console.log(`error=${error}`)
        // })
        httpPost(url,{ "username": "test01", "password": "123456" }).then((value:ESObject)=>{
          LogUtils.printInfo(`response=${JSON.stringify(value)}`)
        }).catch((error:ESObject)=>{
          LogUtils.printInfo(`error=${JSON.stringify(error)}`)
        });
      })
    }.width('100%')
    .height('100%')
    // .backgroundColor(0x2196f3)

  }
}

