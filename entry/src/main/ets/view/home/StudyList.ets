import router from '@ohos.router'
import resourceManager from '@ohos.resourceManager'
import { CustomType, CustomType2, RouteConstants } from '../../common/RouteConstants'
import LogUtils from '../../utils/LogUtils'
import common from '@ohos.app.ability.common'
import util from '@ohos.util'

@Component
export struct StudyList {
  aboutToAppear() {
    let context = getContext(this) as common.UIAbilityContext
    context.resourceManager.getRawFileContent('routes.json')
      .then(value => {
        let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true })
        let retStr = textDecoder.decodeWithStream(value, { stream: false })
      }).catch((reason:ESObject) => {
      console.error(`reason=${reason}`)
    })
  }

  build() {
    Column() {
      List() {
        ForEach(RouteConstants.STUDY_LIST, (item: CustomType2) => {
          ListItem() {
            Text(item.title).listItemStyle().textAlign(TextAlign.Center)
              .onClick(() => {
                // LogUtils.printInfo(item)
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
    }.height("100%").width("100%").padding({ left: 10, right: 10 })
  }
}

@Styles
function listItemStyle() {
  .backgroundColor($r('app.color.color_background_list_item')).width('100%').padding({ left: 16, right: 16, top: 30, bottom: 30 }).borderRadius(16)
}