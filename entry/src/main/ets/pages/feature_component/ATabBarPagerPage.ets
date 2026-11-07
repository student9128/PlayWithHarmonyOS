import { ATabBar, ATabBarCenterMode, ATabBarIndicatorShape } from '../../widgets/ATabBar'
import { PagerTabItem, TabPagerScaffold } from '../../widgets/TabPagerScaffold'
import { CustomTitleBar } from '../../widgets/CustomTitleBar'

/**
 * ATabBar 作为 TabPagerScaffold 的 tabBar 插槽。
 * 联动方式：外部维护 currentIndex / controlledIndex 两个状态
 * - 点 tab：ATabBar.onChange 同时更新 currentIndex（indicator 立即滑动）与 controlledIndex（驱动 Swiper）
 * - 手势滑内容页：TabPagerScaffold.onTabChange 回写 currentIndex，indicator 跟着 Swiper 切换
 */
@ComponentV2
export struct ATabBarPagerPage {
  @Local currentIndex: number = 0
  @Local controlledIndex: number = 0
  @Local indicatorShape: ATabBarIndicatorShape = ATabBarIndicatorShape.BottomLine
  @Local enableIndicatorAnimation: boolean = true
  @Local centerMode: ATabBarCenterMode = ATabBarCenterMode.Screen
  // -1 表示未在侧滑；>=0 为 Swiper 逐帧回传的浮点页索引
  @Local swipeProgress: number = -1

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
  // tabList 必须保持同一个数组引用，否则每次 build 都会触发 ATabBar 的 @Monitor('tabList') 重新测量
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
      CustomTitleBar({ title: 'ATabBar + Pager' }) {
        Column() {
          this.controlBar()

          Text(`currentIndex = ${this.currentIndex} · swipe = ${this.swipeProgress.toFixed(2)}（点 tab 补间 / 侧滑逐帧跟手）`)
            .fontSize(12)
            .fontColor($r('app.color.text_color'))
            .margin({ top: 10, bottom: 6 })

          TabPagerScaffold({
            tabs: this.tabs,
            initialTabIndex: 0,
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
  controlBar() {
    Column() {
      Row() {
        Button(`indicator：${this.shapeLabel()}`)
          .fontSize(12)
          .onClick(() => {
            this.indicatorShape = this.nextShape()
          })
        Button(this.enableIndicatorAnimation ? '滑动：开' : '滑动：关')
          .fontSize(12)
          .margin({ left: 8 })
          .onClick(() => {
            this.enableIndicatorAnimation = !this.enableIndicatorAnimation
          })
      }.width('100%').margin({ top: 10 })

      Row() {
        Button(this.centerMode === ATabBarCenterMode.Screen ? '居中：屏幕' : '居中：可见区')
          .fontSize(12)
          .onClick(() => {
            this.centerMode = this.centerMode === ATabBarCenterMode.Screen ?
              ATabBarCenterMode.VisibleArea : ATabBarCenterMode.Screen
          })
      }.width('100%').margin({ top: 8 })
    }
    .padding({ left: 12, right: 12 })
  }

  @Builder
  pagerTabBar() {
    ATabBar({
      tabList: this.tabTitles,
      index: this.currentIndex,
      useOuterIndex: true,
      indicatorShape: this.indicatorShape,
      enableIndicatorAnimation: this.enableIndicatorAnimation,
      swipeProgress: this.swipeProgress,
      centerMode: this.centerMode,
      indicatorColor: '#FA7070',
      // 圆角背景需要更高的 indicator 与白色选中文字
      indicatorHeight: this.indicatorShape === ATabBarIndicatorShape.RoundedRect ? 30 : 3,
      indicatorRadius: this.indicatorShape === ATabBarIndicatorShape.RoundedRect ? 15 : 2,
      indicatorHorizontalPadding: 14,
      tabHeight: 46,
      selectedFontColor: this.indicatorShape === ATabBarIndicatorShape.RoundedRect ?
        Color.White : '#FA7070',
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
      Text('左右滑动切换内容页，上方 indicator 会跟着滑动')
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

  private shapeLabel(): string {
    if (this.indicatorShape === ATabBarIndicatorShape.BottomLine) {
      return '下划线'
    }
    if (this.indicatorShape === ATabBarIndicatorShape.TopLine) {
      return '上划线'
    }
    return '圆角背景'
  }

  private nextShape(): ATabBarIndicatorShape {
    if (this.indicatorShape === ATabBarIndicatorShape.BottomLine) {
      return ATabBarIndicatorShape.TopLine
    }
    if (this.indicatorShape === ATabBarIndicatorShape.TopLine) {
      return ATabBarIndicatorShape.RoundedRect
    }
    return ATabBarIndicatorShape.BottomLine
  }
}
@Builder
export function ATabBarPagerPageBuilder() {
  NavDestination() {
    ATabBarPagerPage()
  }.hideTitleBar(true)
}
