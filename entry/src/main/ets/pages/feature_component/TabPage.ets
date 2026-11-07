import { CustomTitleBar } from '../../widgets/CustomTitleBar'
import { AppRadius, Constants } from '../../common/AppConstants'
import { toRouteName } from '../../common/AppRouteParams'

interface TabDemoItem {
  title: string
  desc: string
  page: string
}

@ComponentV2
export struct TabPage {
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
    {
      title: 'ATabBar + TabPagerScaffold',
      desc: 'ATabBar 作为 tabBar 插槽：点 tab 切页、手势滑内容页时 indicator 双向跟随',
      page: 'pages/feature_component/ATabBarPagerPage'
    },
    {
      title: 'BTabBar 背景内文字反色',
      desc: '双层文字 + 裁剪窗口：红色背景内白字、背景外黑字，边界随侧滑逐帧移动',
      page: 'pages/feature_component/BTabBarPage'
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
              .borderRadius(AppRadius.item)
              .backgroundColor($r('app.color.app_primary_container'))
              .onClick(() => {
                Constants.navStack.pushPathByName(toRouteName(item.page), undefined)
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
@Builder
export function TabPageBuilder() {
  NavDestination() {
    TabPage()
  }.hideTitleBar(true)
}
