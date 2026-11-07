import { CustomType, RouteConstants } from '../common/RouteConstants';
import LogUtils from '../utils/LogUtils';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { AppRadius, AppSize, Constants } from '../common/AppConstants';
import { AppRouteParams, toRouteName } from '../common/AppRouteParams';
import { AppTitleBar } from '../widgets/AppTitleBar';

class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: Array<CustomType> = [];

  totalCount(): number {
    return 0;
  }

  getData(index: number) {
    return this.originDataArray[index];
  }

  registerDataChangeListener(listener: DataChangeListener) {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener)
    }
    LogUtils.printInfo(`listener=${this.listeners.length}`)
  }

  unregisterDataChangeListener(listener: DataChangeListener) {
    const pos = this.listeners.indexOf(listener)
    if (pos >= 0) {
      this.listeners.slice(pos, 1)
    }
  }

  // 通知LazyForEach组件需要重载所有子组件
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  // 通知LazyForEach组件需要在index对应索引处添加子组件
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  // 通知LazyForEach组件需要在index对应索引处删除该子组件
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }

  // 通知LazyForEach组件将from索引和to索引处的子组件进行交换
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    })
  }
}

class MyDataSource extends BasicDataSource {
  private dataArray: Array<CustomType> = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): CustomType {
    return this.dataArray[index];
  }

  public addData(index: number, data: CustomType): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: CustomType): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}
@ComponentV2
export struct ArkComponentPage {
  private data: MyDataSource = new MyDataSource();

  aboutToAppear() {
    for (let i = 0; i < AppRouteParams.groupData.length; i++) {
      this.data.pushData(AppRouteParams.groupData[i])
    }
  }

  build() {
    List() {
      LazyForEach(this.data, (item: CustomType) => {
        ListItem() {
          if (item) {
            Text(item.title).listItemStyle().fontColor($r('app.color.text_color')).textAlign(TextAlign.Center)
              .onClick(() => {
                hilog.info(0x0000, 'testTag', '%{public}s', item)
                const name: string = item.page != '' ? toRouteName(item.page) :
                  toRouteName(RouteConstants.NOT_FOUND_PAGE)
                Constants.navStack.pushPathByName(name, undefined)
              })
          }
        }.margin({ top: 10 })
      }, (item: CustomType) => item.page)
    }
    .cachedCount(5)
    // 沉浸式：List 占满父容器，expandSafeArea 加在 List 自身。
    // 不能用 layoutWeight(1)：那会把 List 约束在安全区内，底部导航条无法沉浸。
    .width('100%')
    .height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .padding({ left: 10, right: 10 })
    // 官方 FAQ「List展示不全」方案五：上方 AppTitleBar 固定占 56vp，
    // List 用 100% 高会被整体下压这段距离，内容末尾留等量偏移即可滚出最后一项
    .contentEndOffset(AppSize.titleBarHeight)
  }

}

@Styles
function listItemStyle() {
  .backgroundColor($r('app.color.app_primary_container')).width('100%')
  .padding({ left: 16, right: 16, top: 18, bottom: 18 }).borderRadius(AppRadius.item)
}
@Builder
export function ArkComponentPageBuilder() {
  NavDestination() {
    Column() {
      AppTitleBar({ title: AppRouteParams.groupTitle })
      ArkComponentPage()
    }
    .width('100%')
    .height('100%')
  }
  .hideTitleBar(true)
}
