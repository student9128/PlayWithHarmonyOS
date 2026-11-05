import router from '@ohos.router';
import { CustomTitleBar } from '../../widgets/CustomTitleBar'

interface TabDemoItem {
  title: string
  desc: string
  page: string
}

@Entry
@Component
struct TabPage {
  private demoList: TabDemoItem[] = [
    {
      title: '系统 Tabs 实现',
      desc: 'ArkUI 自带 Tabs + TabContent，父子嵌套与手势切换父 Tab',
      page: 'pages/feature_component/SystemTabsPage'
    },
    {
      title: 'TabPagerScaffold 实现',
      desc: 'widgets/TabPagerScaffold：KTabBar + Swiper 二层嵌套，支持受控切换',
      page: 'pages/feature_component/TabPagerScaffoldPage'
    },
    {
      title: 'ATabBar 自定义 indicator',
      desc: 'widgets/ATabBar：上划线 / 下划线 / 圆角背景 / Canvas 自定义 indicator，可整体显隐',
      page: 'pages/feature_component/ATabBarPage'
    },
  ]

  // 根节点必须是容器组件，自定义组件 CustomTitleBar 不能直接作为 @Entry 的根
  build() {
    RelativeContainer() {
      CustomTitleBar({ title: 'TabPage' }) {
        List() {
          ForEach(this.demoList, (item: TabDemoItem) => {
            ListItem() {
              Column() {
                Text(item.title)
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.text_color'))
                Text(item.desc)
                  .fontSize(13)
                  .fontColor($r('app.color.text_color'))
                  .margin({ top: 6 })
              }
              .alignItems(HorizontalAlign.Start)
              .width('100%')
              .padding({ left: 16, right: 16, top: 18, bottom: 18 })
              .borderRadius(16)
              .backgroundColor($r('app.color.color_background_list_item'))
              .onClick(() => {
                router.pushUrl({ url: item.page }, (err) => {
                  if (err) {
                    console.error(`pushUrl failed, code is ${err.code}, message is ${err.message}`);
                    return
                  }
                  console.info('pushUrl success');
                })
              })
            }.margin({ top: 10 })
          }, (item: TabDemoItem) => item.page)
        }
        .width('100%').height('100%')
        .padding({ left: 10, right: 10 })
      }
    }
    .width('100%').height('100%')
  }
}
