import { KTabBar } from "./KTabBar"

@ObservedV2
export class PagerTabItem {
  @Trace key: string = ''
  @Trace title: string = ''

  constructor(key: string = '', title: string = '') {
    this.key = key
    this.title = title
  }
}

@ComponentV2
export struct TabPagerScaffold {
  @Param tabs: PagerTabItem[] = []
  @Param initialTabIndex: number = 0
  @BuilderParam rightFunction: () => void = this.defaultBuilder
  @BuilderParam pageContent: (pageIndex: number, item: PagerTabItem) => void = this.defaultBuilder
  @BuilderParam tabBar: () => void = this.defaultTabBar
  @Param controlledIndex: number = -1
  @BuilderParam emptyContent: () => void = this.defaultEmptyContent
  @BuilderParam loadingContent: () => void = this.defaultLoadingContent

  @Param isLoadingFirst: boolean = false
  @Param isEmpty: boolean = false
  @Param isLoadingError: boolean = false
  @Param errorText: string = ''

  @Event onTabChange: (index: number) => void
  @Event onRetry: () => void
  // 侧滑逐帧进度：浮点页索引（0→1 表示从第 0 页滑向第 1 页）；-1 表示本次滑动结束
  @Event onSwipeProgress?: (floatIndex: number) => void

  @Local currentSelectedIndex: number = 0
  private swiperController: SwiperController = new SwiperController()
  // 代码触发的切页（点 tab / controlledIndex）不走跟手，交给 ATabBar 自己的补间动画
  private isProgrammaticChange: boolean = false

  aboutToAppear(): void {
    this.currentSelectedIndex = this.controlledIndex >= 0 ? this.controlledIndex : this.initialTabIndex
  }

  @Builder
  defaultBuilder() {
  }

  @Builder
  defaultEmptyContent() {
    Text('暂无数据')
  }

  @Builder
  defaultLoadingContent() {
    Text('加载中...')
  }

  @Builder
  defaultTabBar() {
    KTabBar({
      tabList: this.tabs.map((item: PagerTabItem): string => item.title),
      useOuterIndex: true,
      index: this.currentSelectedIndex,
      onChange: (index: number) => {
        this.changeTab(index)
      },
      rightBuilder: () => {
        this.rightFunction()
      }
    })
  }

  build() {
    Column() {
      if (this.isLoadingFirst) {
        this.loadingContent()
      } else if (this.isEmpty && !this.isLoadingError) {
        this.emptyContent()
      } else if (this.isLoadingError) {
        Text('加载失败')
      } else {
        this.tabBar()

        Swiper(this.swiperController) {
          Repeat<PagerTabItem>(this.tabs)
            .each((ri: RepeatItem<PagerTabItem>) => {
              Column() {
                this.pageContent(ri.index, ri.item)
              }
              .width('100%').height('100%')
            })
            // key 绑定业务 key：顺序变化/增删时节点重建并重新取数，避免「tab 与内容」错位
            .key((item: PagerTabItem, index: number) =>
            item.key ? `pager_${item.key}` : `pager_page_${index}`)
        }
        .index(this.currentSelectedIndex)
        .loop(false).indicator(false).duration(300).curve(Curve.Ease)
        .onContentDidScroll((selectedIndex: number, index: number, position: number,
          _mainAxisLength: number) => {
          // 每帧对视窗内所有页都会回调，只取当前页那次。
          // position 是当前页相对滑动起点的位移比例（左滑为负），selectedIndex - position 即浮点页索引，方向自适应。
          if (this.isProgrammaticChange || index !== selectedIndex) {
            return
          }
          const maxIndex: number = this.tabs.length - 1
          const floatIndex: number = Math.max(0, Math.min(selectedIndex - position, maxIndex))
          this.onSwipeProgress?.(floatIndex)
        })
        .onAnimationEnd(() => {
          this.isProgrammaticChange = false
          this.onSwipeProgress?.(-1)
        })
        .onChange((index: number) => {
          // 切页完成即退出程序化切页态：onAnimationEnd 万一没回调也不会让后续手势被误屏蔽
          this.isProgrammaticChange = false
          if (this.currentSelectedIndex !== index) {
            this.currentSelectedIndex = index
            this.onTabChange(index)
          }
        })
        .nestedScroll(SwiperNestedScrollMode.SELF_FIRST)
        .layoutWeight(1).width('100%').cachedCount(1)
      }
    }
    .width('100%').height('100%')
  }

  changeTab = (index: number) => {
    if (this.currentSelectedIndex !== index) {
      this.isProgrammaticChange = true
      this.currentSelectedIndex = index
      this.swiperController.changeIndex(index)
      this.onTabChange(index)
    }
  }

  // 受控模式：父层 controlledIndex 变化时，同步内部状态并驱动 Swiper。
  @Monitor('controlledIndex')
  onControlledIndexChanged(): void {
    if (this.controlledIndex < 0 || this.controlledIndex === this.currentSelectedIndex) {
      return
    }
    this.isProgrammaticChange = true
    this.currentSelectedIndex = this.controlledIndex
    this.swiperController.changeIndex(this.controlledIndex)
  }
}
