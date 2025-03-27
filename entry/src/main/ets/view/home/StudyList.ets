import router from '@ohos.router'
import resourceManager from '@ohos.resourceManager'
import { CustomType, CustomType2, RouteConstants } from '../../common/RouteConstants'
import LogUtils from '../../utils/LogUtils'
import common from '@ohos.app.ability.common'
import util from '@ohos.util'
import { showToast } from '../../utils/ToastUtils'
import { window } from '@kit.ArkUI'
import { key_window_class } from '../../common/Key'

@Component
export struct StudyList {
  aboutToAppear() {
    let context = getContext(this) as common.UIAbilityContext
    context.resourceManager.getRawFileContent('routes.json')
      .then(value => {
        let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true })
        // let retStr = textDecoder.decodeWithStream(value, { stream: false })
        let resultStr = textDecoder.decodeToString(value, { stream: false })
      }).catch((reason: ESObject) => {
      console.error(`reason=${reason}`)
    })

  }

  build() {
    Column() {
      List() {
        ForEach(RouteConstants.STUDY_LIST, (item: CustomType2) => {
          ListItem() {
            Text(item.title).listItemStyle().fontColor($r('app.color.text_color')).textAlign(TextAlign.Center)
              .onClick(() => {
                // LogUtils.printInfo(item)
                showToast(`${item.title}`)
                console.log(`${item.data}`)
                router.pushUrl({
                  url: 'pages/ArkComponentPage',
                  params: { "data": item.data, "title": `${item.title}` }
                }, (err) => {
                  if (err) {
                    console.error(`pushUrl failed, code is ${err.code}, message is ${err.message}`);
                    return
                  }
                  console.info('pushUrl success');
                })
              })
          }.margin({ top: 10 })
        })
      }.listDirection(Axis.Vertical)
      .edgeEffect(EdgeEffect.Spring)
    }.height("100%").width("100%").padding({ left: 10, right: 10 }).backgroundColor(Color.Red)
  }
  // page A
  pageTransition() {
    // 定义页面进入时的效果，从左侧滑入，时长为1200ms，无论页面栈发生push还是pop操作均可生效
    PageTransitionEnter({ type: RouteType.None, duration: 1200 })
      .slide(SlideEffect.Left)
    // 定义页面退出时的效果，向左侧滑出，时长为1000ms，无论页面栈发生push还是pop操作均可生效
    PageTransitionExit({ type: RouteType.None, duration: 1000 })
      .slide(SlideEffect.Left)
  }
}

@Styles
function listItemStyle() {
  .backgroundColor($r('app.color.color_background_list_item'))
  .width('100%')
  .padding({
    left: 16,
    right: 16,
    top: 30,
    bottom: 30
  })
  .borderRadius(16)
}