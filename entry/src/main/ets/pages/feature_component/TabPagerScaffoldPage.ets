import { PagerTabItem, TabPagerScaffold } from '../../widgets/TabPagerScaffold'
import { KLTabString } from '../../widgets/KLTab'
import { CustomTitleBar } from '../../widgets/CustomTitleBar'
import { showToast } from '../../utils/ToastUtils'

@ComponentV2
export struct TabPagerScaffoldPage {
  @Local parentTabs: PagerTabItem[] = [
    new PagerTabItem('tab1', 'Tab1'),
    new PagerTabItem('tab2', 'Tab2'),
    new PagerTabItem('tab3', 'Tab3'),
  ]
  @Local subTabs: PagerTabItem[] = [
    new PagerTabItem('sub1', 'subTab1'),
    new PagerTabItem('sub2', 'subTab2'),
    new PagerTabItem('sub3', 'subTab3-----test'),
  ]
  @Local outerIndex: number = 0
  @Local outerControlledIndex: number = 0
  @Local subIndexes: number[] = [0, 0, 0]
  private outerTabTitles: string[] = []

  aboutToAppear(): void {
    this.outerTabTitles = this.parentTabs.map((item: PagerTabItem): string => item.title)
  }

  build() {
    RelativeContainer() {
      CustomTitleBar({ title: 'TabPagerScaffold' }) {
        Column() {
          TabPagerScaffold({
            tabs: this.parentTabs,
            initialTabIndex: 0,
            controlledIndex: this.outerControlledIndex,
            tabBar: () => {
              this.outerTabBarBuilder()
            },
            pageContent: (pageIndex: number, item: PagerTabItem) => {
              this.parentPageBuilder(pageIndex, item)
            },
            onTabChange: (index: number) => {
              this.outerIndex = index
              this.outerControlledIndex = index
              showToast(`外层切换到 ${this.parentTabs[index].title}`)
            }
          }).layoutWeight(1).width('100%')
        }.width('100%').height('100%')
      }
    }
    .width('100%').height('100%')
  }

  // 外层每一页：内部再嵌一层 TabPagerScaffold（二层 Tab）
  @Builder
  parentPageBuilder(pageIndex: number, item: PagerTabItem) {
    Column() {
      Text(`外层：${item.title}（index=${pageIndex}）`)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_color'))
        .margin({ top: 12, bottom: 8 })

      Column() {
        TabPagerScaffold({
          tabs: this.subTabs,
          controlledIndex: this.subIndexes[pageIndex],
          pageContent: (subIndex: number, subItem: PagerTabItem) => {
            this.subPageBuilder(pageIndex, item, subIndex, subItem)
          },
          onTabChange: (subIndex: number) => {
            this.subIndexes[pageIndex] = subIndex
            showToast(`${item.title} / ${this.subTabs[subIndex].title}`)
          }
        })
      }.layoutWeight(1).width('100%')
    }.width('100%').height('100%')
  }

  @Builder
  subPageBuilder(pageIndex: number, item: PagerTabItem, subIndex: number, subItem: PagerTabItem) {
    Column() {
      Text(`外层 ${item.title} → 内层 ${subItem.title}`)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_color'))
        .margin({ top: 24, bottom: 12 })
      Text(`parentIndex=${pageIndex}  subIndex=${subIndex}`)
        .fontSize(13)
        .fontColor($r('app.color.text_color'))
    }
    .width('100%').height('100%')
    .backgroundColor(subIndex % 2 === 0 ? '#FFF3E0' : '#E8F5E9')
  }

  // 外层 tabBar 右侧插槽
  @Builder
  rightFunctionBuilder() {
    Text(`${this.outerIndex + 1}/${this.parentTabs.length}`)
      .fontSize(12)
      .fontColor($r('app.color.text_color'))
      .padding({ left: 8, right: 8 })
      .onClick(() => {
        showToast(`当前外层第 ${this.outerIndex + 1} 页`)
      })
  }

  @Builder
  outerTabBarBuilder() {
    Row() {
      KLTabString({
        tabList: this.outerTabTitles,
        selectedTabIndex: this.outerIndex,
        showIndicator: false,
        onChange: (index: number) => {
          this.outerControlledIndex = index
        }
      }).layoutWeight(1)
      this.rightFunctionBuilder()
    }.width('100%').backgroundColor(Color.White)
  }
}
@Builder
export function TabPagerScaffoldPageBuilder() {
  NavDestination() {
    TabPagerScaffoldPage()
  }.hideTitleBar(true)
}
