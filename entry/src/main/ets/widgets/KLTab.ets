import { AdaptiveUtils } from "../breakpoint/AdaptiveUtils"

export interface KLTabTextOptions {
  key: string
  title: string
}

export interface KLTabIconOptions {
  key: string
  icon: Resource
  iconWidth?: number
  iconHeight?: number
  selectedIconWidth?: number
  selectedIconHeight?: number
  title?: string
}

export class KLTabData {
  key: string = ''
  title: string = ''
  icon?: Resource = undefined
  iconWidth: number = 20
  selectedIconWidth: number = 20
  iconHeight: number = 20
  selectedIconHeight: number = 20

  static text(options: KLTabTextOptions): KLTabData {
    const data = new KLTabData()
    data.key = options.key
    data.title = options.title
    return data
  }

  static icon(options: KLTabIconOptions): KLTabData {
    const data = new KLTabData()
    data.key = options.key
    data.icon = options.icon
    data.iconWidth = options.iconWidth ?? 20
    data.iconHeight = options.iconHeight ?? 20
    data.selectedIconWidth = options.selectedIconWidth ?? 20
    data.selectedIconHeight = options.selectedIconHeight ?? 20
    data.title = options.title ?? ''
    return data
  }
}

@ComponentV2
export struct KLTab {
  @Require @Param tabList: KLTabData[]
  @Param selectedTabIndex: number = 0
  @Event onChange: (index: number) => void
  @Param scrollable: boolean = true
  @Param alignment: FlexAlign = FlexAlign.Center
  @Param showIndicator: boolean = false
  @Param indicatorHeight: number = 3
  @Param indicatorSpace: number = 4
  @Param selectedFontSize: number | string | Resource = 18
  @Param unselectedFontSize: number | string | Resource = 16
  @Param selectedColor: ResourceColor = $r('app.color.tab_active_color')
  @Param unselectedColor: ResourceColor = $r('app.color.tab_normal_color')
  @Param fontWeight: FontWeight = FontWeight.Bold
  @Param totalHeight: number = 48
  @Param tabBackgroundColor: ResourceColor = $r('app.color.tab_background')
  @Param tabTextPaddingHorizontal: number = 8
  @Param firstPadding: number = 16
  @Param showRightFunction: boolean = false
  @BuilderParam customRightFunction?: () => void
  @Param enableFunction: boolean = false
  @Param enableSearch: boolean = false
  @Event onFunctionClick?: () => void
  @Event onSearchClick?: () => void

  private scroller: Scroller = new Scroller()
  private localTitleWidthArray: Array<number> = []
  private tabTextPaddingHorizontalInner: number = 8
  private defaultTitleHeight = 26
  @Local titleHeight: number = 26

  aboutToAppear(): void {
    this.tabTextPaddingHorizontalInner = this.tabTextPaddingHorizontal
    this.reMeasureWidths()
  }

  /**
   * tabList 变化：外部传入新数组：数量增减 / 顺序交换 / 内容变化 时重新测量宽度
   * 注意：@Monitor 观察的是数组引用，若外部原地修改元素，如不重建数组直接 swap，
   * 框架观察不到，需外部以 <b>新建数组</b> 的方式传入才会触发。
   */
  @Monitor('tabList')
  onTabListChanged(): void {
    this.reMeasureWidths()
  }

  @Monitor('selectedTabIndex')
  onSelectedIndexChange(): void {
    this.scrollToCenter(this.selectedTabIndex)
  }

  private reMeasureWidths(): void {
    this.localTitleWidthArray = []
    if (this.tabList.length > 0) {
      this.tabList.forEach((item: KLTabData, index: number) => {
        if (item.icon !== undefined) {
          this.localTitleWidthArray.push(item.selectedIconWidth)
        } else {
          const textWidth = this.getUIContext().getMeasureUtils().measureText({
            textContent: item.title.length > 0 ? item.title : `${index}`,
            fontSize: this.selectedFontSize,
            fontWeight: this.fontWeight
          })
          this.localTitleWidthArray.push(this.getUIContext().px2vp(textWidth))
        }
      })
      const textWH = this.getUIContext().getMeasureUtils().measureTextSize({
        textContent: '',
        fontSize: this.selectedFontSize,
        fontWeight: this.fontWeight
      })
      this.titleHeight = textWH.height ?
        this.getUIContext().px2vp(Number(textWH.height)) + this.indicatorSpace + this.indicatorHeight : this.defaultTitleHeight
    }
  }

  build() {
    Column() {
      Row() {
        if (this.scrollable) {
          List({ scroller: this.scroller }) {
            ForEach(this.tabList, (item: KLTabData, index: number) => {
              ListItem() {
                this.tabItem(item, index)
              }
              .padding({
                left: index == 0 ? this.firstPadding : this.tabTextPaddingHorizontalInner,
                right: index == this.tabList.length - 1 ? this.firstPadding : this.tabTextPaddingHorizontalInner
              })
              .onClick(() => {
                this.changeTabAndContent(index)
              })
            })
          }
          .layoutWeight(1)
          .height(this.totalHeight)
          .listDirection(Axis.Horizontal)
          .alignListItem(ListItemAlign.Center)
          .edgeEffect(EdgeEffect.None)
          .scrollBar(BarState.Off)
        } else {
          Row() {
            ForEach(this.tabList, (item: KLTabData, index: number) => {
              Row() {
                this.tabItem(item, index)
              }
              .padding({
                left: index == 0 ? this.firstPadding : this.tabTextPaddingHorizontalInner,
                right: index == this.tabList.length - 1 ? this.firstPadding : this.tabTextPaddingHorizontalInner
              })
              .justifyContent(FlexAlign.Center)
              .onClick(() => {
                this.changeTabAndContent(index)
              })
            })
          }
          .width('100%')
          .justifyContent(this.alignment)
        }

      }
      .width('100%')
      .height(this.totalHeight)
      .backgroundColor(this.tabBackgroundColor)
    }
  }

  @Builder
  tabItem(item: KLTabData, index: number) {
    Column() {
      Row() {
        if (item.icon !== undefined) {
          Image(item.icon)
            .width(this.selectedTabIndex == index ? item.selectedIconWidth : item.iconWidth)
            .height(this.selectedTabIndex == index ? item.selectedIconHeight : item.iconHeight)
            .objectFit(ImageFit.Contain)
            .fillColor(this.selectedTabIndex == index ? this.selectedColor : this.unselectedColor)
        } else {
          Text(item.title)
            .fontWeight(this.fontWeight)
            .fontColor(this.selectedTabIndex == index ? this.selectedColor : this.unselectedColor)
            .fontSize(this.selectedTabIndex == index ? this.selectedFontSize : this.unselectedFontSize)
        }
      }
      .height(this.titleHeight)
      .justifyContent(FlexAlign.Center)
      .borderWidth({
        left: 0,
        top: 0,
        right: 0,
        bottom: this.showIndicator && this.selectedTabIndex == index ? this.indicatorHeight : 0
      })
      .borderColor(this.selectedColor)
    }
  }

  changeTabAndContent = (index: number) => {
    if (this.selectedTabIndex != index) {
      this.scrollToCenter(index)
      this.onChange(index)
    }
  }

  private scrollToCenter(index: number) {
    if (this.localTitleWidthArray.length == 0) {
      return
    }
    let titleWidth = 0
    for (let i = 0; i < index; i++) {
      titleWidth += this.localTitleWidthArray[i]
    }
    let leftSpace =
      index * (this.tabTextPaddingHorizontalInner * 2) + this.firstPadding + this.localTitleWidthArray[index] / 2 + titleWidth
    let halfScreenWidth = AdaptiveUtils.windowWidth() / 2
    this.scroller.scrollTo({
      xOffset: leftSpace - halfScreenWidth,
      yOffset: 0,
      animation: true
    })
  }
}

/**
 * 仅需传 string[] 即可，等价于全部文字 tab 的 KLTab。
 */
@ComponentV2
export struct KLTabString {
  @Require @Param tabList: string[]
  @Param selectedTabIndex: number = 0
  @Event onChange: (index: number) => void
  @Param scrollable: boolean = true
  @Param alignment: FlexAlign = FlexAlign.Center
  @Param showIndicator: boolean = false
  @Param indicatorHeight: number = 3
  @Param indicatorSpace: number = 4
  @Param selectedFontSize: number | string | Resource = 18
  @Param unselectedFontSize: number | string | Resource = 17
  @Param selectedColor: ResourceColor = $r('app.color.tab_active_color')
  @Param unselectedColor: ResourceColor = $r('app.color.tab_normal_color')
  @Param fontWeight: FontWeight = FontWeight.Medium
  @Param totalHeight: number = 48
  @Param tabBackgroundColor: ResourceColor = $r('app.color.tab_background')
  @Param tabTextPaddingHorizontal: number = 8
  @Param firstPadding: number = 16
  @Param showRightFunction: boolean = false
  @BuilderParam customRightFunction?: () => void
  @Param enableFunction: boolean = false
  @Param enableSearch: boolean = false
  @Event onFunctionClick?: () => void
  @Event onSearchClick?: () => void

  @Local tabData: KLTabData[] = []

  aboutToAppear(): void {
    this.rebuildTabData()
  }

  @Monitor('tabList')
  onTabListChanged(): void {
    this.rebuildTabData()
  }

  private rebuildTabData(): void {
    const newData: KLTabData[] = []
    this.tabList.forEach((title: string, index: number) => {
      newData.push(KLTabData.text({ key: `${index}`, title: title }))
    })
    this.tabData = newData
  }

  build() {
    KLTab({
      tabList: this.tabData,
      selectedTabIndex: this.selectedTabIndex,
      onChange: (index: number) => {
        this.onChange(index)
      },
      scrollable: this.scrollable,
      alignment: this.alignment,
      showIndicator: this.showIndicator,
      indicatorHeight: this.indicatorHeight,
      indicatorSpace: this.indicatorSpace,
      selectedFontSize: this.selectedFontSize,
      unselectedFontSize: this.unselectedFontSize,
      selectedColor: this.selectedColor,
      unselectedColor: this.unselectedColor,
      fontWeight: this.fontWeight,
      totalHeight: this.totalHeight,
      tabBackgroundColor: this.tabBackgroundColor,
      tabTextPaddingHorizontal: this.tabTextPaddingHorizontal,
      firstPadding: this.firstPadding,
      showRightFunction: this.showRightFunction,
      customRightFunction: () => {
        this.customRightFunction?.()
      },
      enableFunction: this.enableFunction,
      enableSearch: this.enableSearch,
      onFunctionClick: () => {
        this.onFunctionClick?.()
      },
      onSearchClick: () => {
        this.onSearchClick?.()
      }
    })
  }
}
