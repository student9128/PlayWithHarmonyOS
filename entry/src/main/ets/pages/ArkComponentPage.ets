import router from '@ohos.router';
import { CustomType, RouteConstants } from '../common/RouteConstants';
import LogUtils from '../utils/LogUtils';
import { hilog } from '@kit.PerformanceAnalysisKit';

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
interface ParamsModel{
  data:CustomType[],
  title:string
}

@Entry
@Component
struct ArkComponentPage {
  private data: MyDataSource = new MyDataSource();
  private _title:string=''

  aboutToAppear() {
    let params = router.getParams() as ParamsModel
    // let params = router.getParams()['data'] as Array<CustomType>
    this._title = params.title
    for (let i = 0; i <= params.data.length; i++) {
      console.info(`${JSON.stringify(params.data[i])}`)
      this.data.pushData(params.data[i])
    }
  }

  build() {
    Navigation() {
      Column() {
        List() {
          LazyForEach(this.data, (item: CustomType) => {
            ListItem() {
              if (item) {
                Text(item.title).listItemStyle().textAlign(TextAlign.Center)
                  .onClick(() => {
                    // LogUtils.printInfo(item)
                    hilog.info(0x0000, 'testTag', '%{public}s', item)
                    if (item.page != '') {
                      router.pushUrl({ url: item.page })
                    } else {
                      router.pushUrl({ url: RouteConstants.NOT_FOUND_PAGE })
                    }
                  })
              }
            }.margin({ top: 10 })
          })
        }.cachedCount(5)
      }.height("100%").width("100%").padding({ left: 10, right: 10 })
    }.titleMode(NavigationTitleMode.Mini)
    .title(this._title)
  }
}

@Styles
function listItemStyle() {
  .backgroundColor($r('app.color.color_background_list_item')).width('100%').padding({ left: 16, right: 16, top: 30, bottom: 30 }).borderRadius(16)
}
