import router from '@ohos.router'
import { CustomType, RouteConstants } from '../../common/RouteConstants'
import LogUtils from '../../utils/LogUtils'

@Component
export struct StudyList {
  build() {
    Column() {
      List() {
        ForEach(RouteConstants.STUDY_LIST, (item: CustomType) => {
          ListItem() {
            Text(item["title"]).listItemStyle().textAlign(TextAlign.Center)
              .onClick(() => {
                LogUtils.printInfo(item)
                router.pushUrl({ url: item["page"] })
              })
          }.margin({ top: 10 })
        })
      }.listDirection(Axis.Vertical)
      .edgeEffect(EdgeEffect.Spring)
    }.height("100%").width("100%").padding({ left: 10, right: 10 })
  }
}

@Styles function listItemStyle() {
  .backgroundColor('white').width('100%').padding({ left: 16, right: 16, top: 30, bottom: 30 }).borderRadius(16)
}