import { CustomTitleBar } from '../../widgets/CustomTitleBar'
import { MNavigationBar, MNavigationBarItem } from '../../widgets/MNavigationBar'
import { PagerTabItem, TabPagerScaffold } from '../../widgets/TabPagerScaffold'

/**
 * MNavigationBar demo：
 * - 底部导航项固定 4 个，Flex 等分，点击切换
 * - 内容区用 TabPagerScaffold，侧滑真实跟手（onSwipeProgress 驱动药丸背景逐帧移动）
 */
@ComponentV2
export struct MNavigationBarPage {
  @Local currentIndex: number = 0
  @Local controlledIndex: number = 0
  @Local swipeProgress: number = -1

  // 数组保持同一个引用，避免每次 build 触发 MNavigationBar 的 @Monitor('items')
  private items: MNavigationBarItem[] = [
    new MNavigationBarItem('Explore', $r('app.media.ic_explore'), $r('app.media.ic_explore_fill')),
    new MNavigationBarItem('Go', $r('app.media.ic_home'), $r('app.media.ic_home_fill')),
    new MNavigationBarItem('Saved', $r('app.media.ic_person'), $r('app.media.ic_person_fill')),
    // 不传 activeIcon：选中时只靠药丸背景与图标颜色区分
    new MNavigationBarItem('Contribute', $r('app.media.ic_settings'))
  ]
  private tabs: PagerTabItem[] = [
    new PagerTabItem('explore', 'Explore'),
    new PagerTabItem('go', 'Go'),
    new PagerTabItem('saved', 'Saved'),
    new PagerTabItem('contribute', 'Contribute')
  ]
  private pageColors: string[] = ['#EADDFF', '#E8F5E9', '#E3F2FD', '#FCE4EC']
  // 与 MNavigationBar 的 barHeight 保持一致，给底部导航让出内容空间
  private readonly navBarHeight: number = 80

  build() {
    CustomTitleBar({ title: 'MNavigationBar' }) {
      Stack({ alignContent: Alignment.Bottom }) {
        // 内容区：Swiper 逐帧把浮点页索引回传，驱动底部药丸跟手滑动
        TabPagerScaffold({
          tabs: this.tabs,
          initialTabIndex: 0,
          controlledIndex: this.controlledIndex,
          // 导航栏放在页面底部，scaffold 自带的顶部 tabBar 不参与布局
          tabBar: () => {
            this.emptyTabBar()
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
        })
          .width('100%')
          .height('100%')
          .padding({ bottom: this.navBarHeight })

        MNavigationBar({
          items: this.items,
          index: this.currentIndex,
          useOuterIndex: true,
          swipeProgress: this.swipeProgress,
          onChange: (index: number) => {
            this.switchTo(index)
          }
        })
      }
      .width('100%')
      .height('100%')
    }
  }

  @Builder
  emptyTabBar() {
  }

  @Builder
  pageContent(index: number, item: PagerTabItem) {
    Column() {
      Text(item.title)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.app_on_surface'))
      Text(`第 ${index + 1} / ${this.tabs.length} 页`)
        .fontSize(14)
        .fontColor($r('app.color.app_on_surface_variant'))
        .margin({ top: 12 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.pageColors[index % this.pageColors.length])
  }

  /** 点击底部导航：切内容页（scaffold 走 controlledIndex 触发 Swiper 动画） */
  private switchTo(index: number): void {
    if (index === this.currentIndex) {
      return
    }
    this.currentIndex = index
    this.controlledIndex = index
  }

  /** 侧滑切页完成：同步外部索引 */
  private onTabChange(index: number): void {
    this.swipeProgress = -1
    this.currentIndex = index
    this.controlledIndex = index
  }
}

@Builder
export function MNavigationBarPageBuilder() {
  NavDestination() {
    MNavigationBarPage()
  }.hideTitleBar(true)
}
