import { showToast, showToastLong } from '../../utils/ToastUtils'
import { promptAction, window } from '@kit.ArkUI'
import { CustomTitleBar } from '../../widgets/CustomTitleBar'
import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct TextInputPage {
  private controller: webview.WebviewController = new webview.WebviewController();
  private pageWidth = 320;
  private pageHeight = 500;
  @State screenHeight: number | string = '100%';
  @State webViewVisibility: Visibility = Visibility.Visible;
  @State flexAlign: FlexAlign = FlexAlign.Center;
  aboutToAppear() {
    window.getLastWindow(getContext(this)).then(currentWindow => {
      // 监视软键盘的弹出和收起
      currentWindow.on('avoidAreaChange', async data => {
        let property = currentWindow.getWindowProperties();
        let avoidArea = currentWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_KEYBOARD);
        this.screenHeight = px2vp(property.windowRect.height - avoidArea.bottomRect.height);
      });
    })
  }

  build() {
    Column() {
      TextInput()
      Flex()
      Button('点击').onClick(() => {
        showToast('Hello', { alignment: Alignment.Center })
      })
      Button('变色 toast').onClick(() => {
        showToast('Hello', { backgroundColor: Color.Green })
      })
      Button('点击').onClick(() => {
        showToastLong('Hello', { alignment: Alignment.Center })
      })
      Column()
        .width('80%').height(200).backgroundColor(Color.Gray)
        .position({ x: 40, y: 120 })
        .hoverEffect(HoverEffect.Scale)
        .onHover((isHover?: boolean) => {
          console.info('Scale isHover: ' + isHover as string)
        })
      Web({
        src: 'https://www.baidu.com/',
        controller: this.controller
      }).javaScriptAccess(true)
        .width(this.pageWidth)
        .height(this.pageHeight)
    }.width('100%').height('100%').expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP])
    // .height(this.screenHeight)
    // Column() {
    //   CustomTitleBar() {
    //     Column() {
    //       TextInput()
    //       Button('点击').onClick(() => {
    //         showToast('Hello', { alignment: Alignment.Center })
    //       })
    //       Button('变色 toast').onClick(() => {
    //         showToast('Hello', { backgroundColor: Color.Green })
    //       })
    //       Button('点击').onClick(() => {
    //         showToastLong('Hello', { alignment: Alignment.Center })
    //       })
    //       Web({
    //         src: 'https://www.baidu.com/',
    //         controller: this.controller
    //       }).javaScriptAccess(true)
    //         .width(this.pageWidth)
    //         .height(this.pageHeight)
    //     }.width('100%')
    //     .height(this.screenHeight)
    //   }
    //
    // }
  }

  // build() {
  //   Stack() {
  //     Column() {
  //       Web({ src:'https://www.baidu.com/', controller: this.controller })
  //         .javaScriptAccess(true)
  //         .fileAccess(false)
  //         .zoomAccess(false)
  //         .domStorageAccess(true)
  //         .onlineImageAccess(true)
  //         .horizontalScrollBarAccess(false)
  //         .verticalScrollBarAccess(false)
  //         .cacheMode(CacheMode.Online)
  //         .width(this.pageWidth)
  //         .height(this.pageHeight)
  //         .border({ radius: 6 })
  //         .visibility(this.webViewVisibility)
  //         .backgroundColor(Color.Pink)
  //     }
  //     .justifyContent(this.flexAlign)
  //     .alignItems(HorizontalAlign.Center)
  //     .width('100%')
  //     .height('100%')
  //   }
  //   .width('100%')
  //   .height(this.screenHeight)
  //   .backgroundColor('#999955')
  //   .alignContent(Alignment.Center)
  // }
}