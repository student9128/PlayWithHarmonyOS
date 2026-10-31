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

  @Local currentSelectedIndex: number = 0
  private swiperController: SwiperController = new SwiperController()

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
        .onChange((index: number) => {
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
    this.currentSelectedIndex = this.controlledIndex
    this.swiperController.changeIndex(this.controlledIndex)
  }
}
