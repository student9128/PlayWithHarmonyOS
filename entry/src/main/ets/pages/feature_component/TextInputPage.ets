import { showToast, showToastLong } from '../../utils/ToastUtils'
import { promptAction, window } from '@kit.ArkUI'
import { CustomTitleBar } from '../../widgets/CustomTitleBar'
import { webview } from '@kit.ArkWeb';
import { printInfo } from '../../utils/LogUtils';
import { densityPixels, hSize, scaleDensity, wSize } from '../../utils/ScreenUtils';

@Entry
@Component
struct TextInputPage {
  private controller: webview.WebviewController = new webview.WebviewController();
  private pageWidth = 320;
  private pageHeight = 500;
  @State screenHeight: number | string = '100%';
  @State webViewVisibility: Visibility = Visibility.Visible;
  @State flexAlign: FlexAlign = FlexAlign.Center;
  @State currentText: string = '';
  @State currentText1: string = '';
  @State currentText1Temp: string = '';
  textInputController: TextInputController = new TextInputController()
  textInputController1: TextInputController = new TextInputController()
  focusKey: string = 'focus'
  @State isFocus: boolean = false
  @State isUserNameFocus:boolean=false
  @State isPwdFocus:boolean=false

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
      CustomTitleBar({ title: 'TextInputPage' }) {
        Column(){
        Row().height(10).backgroundColor(Color.Brown).width('100%')
        }.width('100%').padding({left:16,right:16})
        Column(){
          Row().height(10).backgroundColor(Color.Orange).width('100%')
        }.width('100%').padding({left:'16vp',right:'16vp'})
        Column(){
        Row().height(hSize(10)).backgroundColor(Color.Green).width('100%')
        }.width('100%').padding({left:wSize(16),right:wSize(16)})
        Row().height(hSize(10)).backgroundColor(Color.Yellow).width(wSize(375))
        TextInput({ text: this.currentText1 }).onChange(v => {
          this.currentText1 = "●".repeat(v.length)
          this.currentText1Temp = v
        }).fontColor(Color.Yellow).fontSize(16).caretColor(Color.Green)
        TextInput().type(InputType.Password).margin({ top: 10 })
        TextInput({ text: $$this.currentText, placeholder: '请输入内容', controller: this.textInputController, })
          .type(InputType.Password)
          .onChange((v) => {
            printInfo(`v=======${v}`)
            this.currentText = v
            this.currentText.replace("·", "*")
          })
          .fontSize(16)
          .fontColor(Color.Red)
          .margin({ top: 10 })
        TextInput({ controller: this.textInputController1 })
          .backgroundBlurStyle(BlurStyle.NONE)
          .showUnderline(true)
          .underlineColor({
            normal: Color.Blue,
            type: Color.Green,
            disable: Color.Gray,
            error: Color.Red
          })
          .onWillInsert((info: InsertValue) => {
            console.log(`onWillInsert====${info.insertValue}`)
            return true
          })
          .onDidInsert((info: InsertValue) => {
            console.log(`onDidInsert====${info.insertValue}`)
            return true
          })
          .onWillDelete((info: DeleteValue) => {
            console.log(`onWillDelete====${info.deleteValue}`)
            return true
          })
          .onDidDelete((info: DeleteValue) => {
            console.log(`onDidDelete====${info.deleteValue}`)
            return true
          })
          .defaultFocus(true)
          .onFocus(() => {
            this.isFocus = true
          })
        Text(`vp2px=${vp2px(16)},lpx2px=${lpx2px(16)},wSize=${wSize(16)}=>,,hSize=${hSize(16)},px=${scaleDensity()*16},scaleDensity=${scaleDensity()},densityPixels=${densityPixels()},`)
        Button('焦点').onClick(() => {
          if (this.isFocus) {
            this.isFocus = false
            // this.textInputController1.stopEditing()
            this.getUIContext().getFocusController().clearFocus();
          } else {
            this.getUIContext().getFocusController().requestFocus(this.focusKey);
            // focusControl.requestFocus(this.foucusKey)
          }
        })
          .margin({ top: 10 }).key(this.focusKey)
        Text(this.currentText)
        Column() {
          TextInput({ placeholder: '用户名' })
            .height(hSize(48))
            .backgroundColor(Color.Transparent)
            .padding({ left: wSize(5), right: wSize(5) })
            .onFocus(() => {
              this.isUserNameFocus = true
            })
            .onBlur(() => {
              this.isUserNameFocus = false
            })
          Divider().vertical(false).color(this.isUserNameFocus ? Color.Red : Color.Gray).height(hSize(2))
        }.width('100%').padding({ left: wSize(16), right: wSize(16) }).height(hSize(50)).margin({ top: hSize(10) })
        Button('哈哈，清除焦点').onClick(()=>{
          this.getUIContext().getFocusController().clearFocus();
        })

        Button('点击').onClick(() => {
          showToast('Hello', { alignment: Alignment.Center })
        })
        Button('变色 toast').onClick(() => {
          showToast('Hello', { backgroundColor: Color.Green })
        })
        Button('点击').onClick(() => {
          showToastLong('Hello', { alignment: Alignment.Center })
        })
      }

      // Column()
      //   .width('80%')
      //   .height(200)
      //   .backgroundColor(Color.Gray)
      //   .position({ x: 40, y: 120 })
      //   .hoverEffect(HoverEffect.Scale)
      //   .onHover((isHover?: boolean) => {
      //     console.info('Scale isHover: ' + isHover as string)
      //   })
      //   Web({
      //     src: 'https://www.baidu.com/',
      //     controller: this.controller
      //   }).javaScriptAccess(true)
      //     .width(this.pageWidth)
      //     .height(this.pageHeight)
      // }.width('100%').height('100%').expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])

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
  }
}