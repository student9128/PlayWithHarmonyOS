import { AdaptiveUtils } from "../breakpoint/AdaptiveUtils"

@ComponentV2
export struct KTabBar{
  @Require @Param tabList: string[]
  @Param index: number = 0
  @Param useOuterIndex: boolean = false
  @Param uniformPadding: number = 16
  @Param tabHeight: number = 32
  @Param tabBackgroundColor: ResourceColor = Color.White
  @Param showTabIndicator: boolean = true
  @Param indicatorHeight: number = 3
  @Param indicatorColor: ResourceColor = Color.Green
  @Param unselectedFontSize: number = 14
  @Param selectedFontSize: number = 14
  @Param unselectedFontWeight: number = 400
  @Param selectedFontWeight: number = 600
  @BuilderParam leftBuilder?: () => void
  @BuilderParam rightBuilder?: () => void
  @Event onChange: (index: number) => void
  @Local currentSelectedIndex: number = 0
  @Local localTitleWidthArray: Array<number> = []
  private tabMarginHorizontal = 8
  private scroller: Scroller = new Scroller()
  private hasInitialScrolled: boolean = false
  private lastListWidth: number = 0
  private lastTabListJoined: string = ''

  aboutToAppear(): void {
    this.rebuildTitleWidths()
    this.lastTabListJoined = this.tabList.join('|')
    this.currentSelectedIndex = this.index
  }

  @Monitor('tabList')
  onTabListChanged(): void {
    const joined: string = this.tabList.join('|')
    if (joined === this.lastTabListJoined) {
      return
    }
    this.lastTabListJoined = joined
    this.rebuildTitleWidths()
    if (this.localTitleWidthArray.length > 0) {
      this.scrollToCenter(this.currentIndex)
    }
  }
  @Monitor('index', 'currentSelectedIndex')
  onSelectedIndexChanged(): void {
    this.scrollToCenter(this.currentIndex)
  }
  @Computed
  private get currentIndex(): number {
    return this.useOuterIndex ? this.index : this.currentSelectedIndex
  }

  private rebuildTitleWidths(): void {
    this.localTitleWidthArray = []
    this.tabList.forEach((value: string) => {
      let textWidth = this.getUIContext().getMeasureUtils().measureText({
        textContent: value,
        fontSize: this.selectedFontSize,
        fontWeight: this.selectedFontWeight
      })
      this.localTitleWidthArray.push(this.getUIContext().px2vp(textWidth))
    })
  }

  build() {
    Row() {
      if (this.leftBuilder) {
        this.leftBuilder()
      }
      List({ scroller: this.scroller }) {
        ForEach(this.tabList, (item: string, index: number) => {
          ListItem() {
            Column() {
              Text(item)
                .fontWeight(this.currentIndex === index ? this.selectedFontWeight : this.unselectedFontWeight)
                .fontColor(this.currentIndex === index ? this.indicatorColor:'#000000')
                .fontSize(this.currentIndex === index ? this.selectedFontSize : this.unselectedFontSize)
            }
            .height(26)
            .justifyContent(FlexAlign.Start)
            .borderWidth({
              left: 0,
              top: 0,
              right: 0,
              bottom: this.showTabIndicator && this.currentIndex === index ? this.indicatorHeight : 0
            })
            .borderColor(this.indicatorColor)
          }
          .padding({
            left: index === 0 ? this.uniformPadding : this.tabMarginHorizontal,
            right: index === this.tabList.length - 1 ? this.uniformPadding : this.tabMarginHorizontal
          })
          .onClick(() => {
            if (this.currentIndex === index) {
              return
            }
            // 滚动统一交给 onSelectedIndexChanged 驱动（点击 / 外部 / 初始三种来源走同一条路径）
            if (!this.useOuterIndex) {
              this.currentSelectedIndex = index
            }
            this.onChange(index)
          })
        }, (item: string, index: number) => `${index}_${item}`)
      }
      .layoutWeight(1)
      .height(this.tabHeight)
      .listDirection(Axis.Horizontal)
      .alignListItem(ListItemAlign.Center)
      .edgeEffect(EdgeEffect.None)
      .scrollBar(BarState.Off)
      .onAreaChange((_oldValue: Area, newValue: Area) => {
        // List 布局完成后，把初始选中项滚到中间  初始 index > 0 时不会触发 @Monitor
        // 避免内容被反复执行
        //   1) 宽度必须 > 0
        //   2) 宽度必须与上次不同
        //   3) 宽度数组必须就绪
        const width: number = Number(newValue.width)
        if (width <= 0 || width === this.lastListWidth) {
          return
        }
        this.lastListWidth = width
        if (this.hasInitialScrolled || this.localTitleWidthArray.length === 0) {
          return
        }
        this.hasInitialScrolled = true
        this.scrollToCenter(this.currentIndex)
      })

      if (this.rightBuilder) {
        this.rightBuilder()
      }
    }
    .width('100%')
    .backgroundColor(this.tabBackgroundColor)
    .height(this.tabHeight)
  }


  private scrollToCenter(index: number) {
    if (this.localTitleWidthArray.length === 0 ||
      index < 0 || index >= this.localTitleWidthArray.length) {
      return
    }
    let offset = 0
    for (let i = 0; i < index; i++) {
      offset += this.itemLeftPadding(i) + this.localTitleWidthArray[i] + this.itemRightPadding(i)
    }
    const itemCenter = offset +
      (this.itemLeftPadding(index) + this.localTitleWidthArray[index] + this.itemRightPadding(index)) / 2
    const halfListWidth = AdaptiveUtils.windowWidth() / 2
    this.scroller.scrollTo({
      xOffset: Math.max(itemCenter - halfListWidth, 0),
      yOffset: 0,
      animation: true
    })
  }

  // wSize 在开启适配时返回 'xx px' 字符串，关闭时返回 number；这里只用于算术计算，统一取数值。
  private itemLeftPadding(index: number): number {
    return this.getUIContext().px2vp(this.toPx(index === 0 ? this.uniformPadding : this.tabMarginHorizontal))
  }

  private itemRightPadding(index: number): number {
    return this.getUIContext().px2vp(this.toPx(index === this.tabList.length - 1 ? this.uniformPadding :
      this.tabMarginHorizontal))
  }

  private toPx(size: string | number): number {
    if (typeof size === 'number') {
      return this.getUIContext().vp2px(size)
    }
    return parseFloat(size)
  }}