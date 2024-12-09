import { key_window_class } from '../../common/Key'
import { window } from '@kit.ArkUI'
/**
 * 使用了setWindowSystemBarProperties的话需要将statusBarColor设置为透明式，否则expandSafeArea不生效
 */
@Entry
@Component
struct SafeAreaPage {
  aboutToAppear(): void {
    let windowClass = AppStorage.get<window.Window>(key_window_class)
    // let statusBarContentColor: string = this.context.config.colorMode == 0 ? '#BF9742' : '#8D493A';
    windowClass?.setWindowSystemBarProperties({
      statusBarColor: null, statusBarContentColor:null
    }, (err) => {
      console.log(`${JSON.stringify(err)}`);
    })
  }
  build() {
    Column() {
      Image('https://gips2.baidu.com/it/u=1651586290,17201034&fm=3028&app=3028&f=JPEG&fmt=auto&q=100&size=f600_800')
        .width('100%')
        .height('30%').expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP])
    }.width('100%').height('100%').clip(false)
  }
}