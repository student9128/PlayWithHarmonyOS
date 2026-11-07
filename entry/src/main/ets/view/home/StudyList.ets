import { AppRadius, Constants } from '../../common/AppConstants'
import { AppRouteParams, toRouteName } from '../../common/AppRouteParams'
import { CustomType, CustomType2, RouteConstants } from '../../common/RouteConstants'
import LogUtils from '../../utils/LogUtils'
import common from '@ohos.app.ability.common'
import util from '@ohos.util'
import { showToast } from '../../utils/ToastUtils'
import { window } from '@kit.ArkUI'
import { key_window_class } from '../../common/Key'

@ComponentV2
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
                showToast(`${item.title}`)
                AppRouteParams.groupTitle = item.title
                AppRouteParams.groupData = item.data
                Constants.navStack.pushPathByName(toRouteName('pages/ArkComponentPage'), undefined)
              })
          }.margin({ top: 10 })
        })
      }.listDirection(Axis.Vertical)
      .edgeEffect(EdgeEffect.Spring)
    }.height('100%').width('100%').padding({ left: 10, right: 10 })
    // .backgroundColor($r('app.color.app_background'))
  }
}

@Styles
function listItemStyle() {
  .backgroundColor($r('app.color.app_primary_container'))
  .width('100%')
  .padding({ left: 16, right: 16, top: 18, bottom: 18 })
  .borderRadius(AppRadius.item)
}