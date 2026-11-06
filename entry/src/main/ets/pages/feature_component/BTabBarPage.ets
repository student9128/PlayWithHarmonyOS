import { BTabBar } from '../../widgets/BTabBar'
import { PagerTabItem, TabPagerScaffold } from '../../widgets/TabPagerScaffold'
import { CustomTitleBar } from '../../widgets/CustomTitleBar'

/**
 * BTabBar 反色效果 demo：
 * - 开关可在「整字变白（旧写法，有 bug）」与「按 indicator 边界像素级反色」之间切换对比
 * - 配合 TabPagerScaffold：点 tab 补间、侧滑逐帧跟手时，反色边界都跟着 indicator 走
 */
@Entry
@ComponentV2
struct BTabBarPage {
  @Local currentIndex: number = 1
  @Local controlledIndex: number = 1
  @Local swipeProgress: number = -1
  @Local reverseText: boolean = true

  private tabs: PagerTabItem[] = [
    new PagerTabItem('recommend', '推荐'),
    new PagerTabItem('hot', '热点'),
    new PagerTabItem('finance', '财经'),
    new PagerTabItem('tech', '科技'),
    new PagerTabItem('sports', '体育'),
    new PagerTabItem('entertainment', '娱乐'),
    new PagerTabItem('car', '汽车'),
    new PagerTabItem('house', '房产'),
  ]
  private tabTitles: string[] = []
  private pageColors: string[] = [
    '#FFF3E0', '#E8F5E9', '#E3F2FD', '#FCE4EC',
    '#F3E5F5', '#E0F7FA', '#FFFDE7', '#EFEBE9'
  ]

  aboutToAppear(): void {
    this.tabTitles = this.tabs.map((item: PagerTabItem): string => item.title)
  }

  build() {
    RelativeContainer() {
      CustomTitleBar({ title: 'BTabBar 反色' }) {
        Column() {
          Row() {
            Button(this.reverseText ? '反色：开（边界内白 / 外黑）' : '反色：关（整字变白，旧写法）')
              .fontSize(12)
              .onClick(() => {
                this.reverseText = !this.reverseText
              })
          }
          .width('100%')
          .padding({ left: 12, right: 12 })
          .margin({ top: 10 })

          Text(`currentIndex = ${this.currentIndex} · swipe = ${this.swipeProgress.toFixed(2)}`)
            .fontSize(12)
            .fontColor($r('app.color.text_color'))
            .margin({ top: 10, bottom: 4 })

          Text('慢慢左右拖内容页，观察文字被红色边界「切」成两色')
            .fontSize(12)
            .fontColor($r('app.color.text_color'))
            .margin({ bottom: 8 })

          TabPagerScaffold({
            tabs: this.tabs,
            initialTabIndex: 1,
            controlledIndex: this.controlledIndex,
            tabBar: () => {
              this.pagerTabBar()
            },
            pageContent: (index: number, item: PagerTabItem) => {
              this.pageContent(index, item)
            },
            onTabChange: (index: number) => {
              this.onTabChange(index)
            },
            onSwipeProgress: (floatIndex: number) => {
              this.swipeProgress = floatIndex
            }
          }).layoutWeight(1).width('100%')
        }
        .width('100%').height('100%')
      }
    }
    .width('100%').height('100%')
  }

  @Builder
  pagerTabBar() {
    BTabBar({
      tabList: this.tabTitles,
      index: this.currentIndex,
      useOuterIndex: true,
      swipeProgress: this.swipeProgress,
      reverseText: this.reverseText,
      onChange: (index: number) => {
        this.currentIndex = index
        this.controlledIndex = index
      }
    })
  }

  @Builder
  pageContent(index: number, item: PagerTabItem) {
    Column() {
      Text(item.title)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_color'))
      Text(`第 ${index + 1} / ${this.tabs.length} 页`)
        .fontSize(14)
        .fontColor($r('app.color.text_color'))
        .margin({ top: 12 })
      Text('左右滑动切换内容页，上方文字反色边界逐帧跟随')
        .fontSize(12)
        .fontColor($r('app.color.text_color'))
        .margin({ top: 24 })
    }
    .width('100%').height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.pageColors[index % this.pageColors.length])
  }

  private onTabChange(index: number): void {
    this.swipeProgress = -1
    this.currentIndex = index
    this.controlledIndex = index
  }
}
