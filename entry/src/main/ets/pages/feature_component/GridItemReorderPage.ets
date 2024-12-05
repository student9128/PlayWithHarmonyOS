import { CustomTitleBar } from '../../widgets/CustomTitleBar'

@Entry
@Component
struct GridItemReorderPage {
  @State imageList: string[] =
    [
      'http://gips0.baidu.com/it/u=1690853528,2506870245&fm=3028&app=3028&f=JPEG&fmt=auto?w=1024&h=1024',
      'http://gips1.baidu.com/it/u=3874647369,3220417986&fm=3028&app=3028&f=JPEG&fmt=auto?w=720&h=1280',
      'http://gips0.baidu.com/it/u=3560029307,576412274&fm=3028&app=3028&f=JPEG&fmt=auto?w=960&h=1280',
      'http://gips2.baidu.com/it/u=3944689179,983354166&fm=3028&app=3028&f=JPEG&fmt=auto?w=1024&h=1024',
      'https://gips3.baidu.com/it/u=3732338995,3528391142&fm=3028&app=3028&f=JPEG&fmt=auto&q=100&size=f600_800',
      'https://gips0.baidu.com/it/u=2946692232,559515331&fm=3028&app=3028&f=JPEG&fmt=auto&q=100&size=f960_1280',
      'https://gips1.baidu.com/it/u=926030969,4240391978&fm=3028&app=3028&f=JPEG&fmt=auto&q=100&size=f576_1024',
      'http://gips0.baidu.com/it/u=3557606594,2640240494&fm=3028&app=3028&f=JPEG&fmt=auto?w=2048&h=2048',
      'https://gips2.baidu.com/it/u=406595553,3023311630&fm=3028&app=3028&f=JPEG&fmt=auto&q=100&size=f900_1200'
    ]
  @State dragImageUrl:string=''
  @Builder
  itemWhileDrag(){
    Image(this.dragImageUrl).width(120).height(100)
  }

  @State dataList: string[] = ['Java', 'Kotlin', 'JavaScript', 'TypeScript', 'Dart', 'Swift', 'ArkTS']
  @State dragItem: string = '';
  @Builder
  itemTextWhileDrag() {
    Row() {
      Text(this.dragItem)
    }
    .padding({ left: 16, right: 16 })
    .width('100%')
    .height(40)
    .backgroundColor($r('app.color.color_background_list_item'))
    .borderRadius(16)
    .justifyContent(FlexAlign.Start)
  }


  build() {
    Column() {
      CustomTitleBar({ title: 'GridItemReorderPage' }) {
        Column(){
          Grid() {
            ForEach(this.imageList, (item: string) => {
              GridItem() {
                Image(item).width(120).height(100).draggable(false).animation({ curve: Curve.Sharp, duration: 300 })
              }
            }, (item: string) => item)
          }.width('100%')
          .height(100*3+15)
          .columnsGap(5).rowsGap(5)
          .columnsTemplate('1fr 1fr 1fr')
          .editMode(true)
          .scrollBar(BarState.Off)
          .supportAnimation(true)
          .enableScrollInteraction(true)
          // .rowsTemplate('1fr 1fr 1fr')//不可写这一行，影响交互动画
          .onItemDragStart((_,itemIndex:number)=>{
            this.dragImageUrl = this.imageList[itemIndex]
            return this.itemWhileDrag()
          })
          .onItemDrop((_,itemIndex:number,insertIndex:number,isSuccess:boolean)=>{
            if (!isSuccess || insertIndex >= this.imageList.length) {
              return;
            }
            console.log(`itemIndex=${itemIndex},insertIndex=${insertIndex}`)
            this.changeIndex(itemIndex,insertIndex)

          })
          Grid() {
            ForEach(this.dataList, (item: string) => {
              GridItem() {
                Row() {
                  Text(item)
                }
                .margin({ top: 10, })
                .padding({left:16,right:16})
                .width('100%')
                .height(40)
                .backgroundColor($r('app.color.color_background_list_item'))
                .borderRadius(16)
                .justifyContent(FlexAlign.Start)
                .draggable(false).animation({ curve: Curve.Sharp, duration: 300 })
                // Image(item).width(120).height(100).draggable(false).animation({ curve: Curve.Sharp, duration: 300 })
              }
            }, (item: string) => item)
          }.width('100%')
          .height(100*3+15)
          .columnsGap(5).rowsGap(5)
          .columnsTemplate('1fr')
          .editMode(true)
          .scrollBar(BarState.Off)
          .supportAnimation(true)
          .enableScrollInteraction(true)
          .onItemDragStart((event,itemIndex:number)=>{
            console.log(`itemDrag====onItemDragStart==${JSON.stringify(event)}`)
            this.dragItem = this.dataList[itemIndex]
            return this.itemTextWhileDrag()
          })
          .onItemDragMove((event,itemIndex,insertIndex)=>{
            console.log(`itemDrag====onItemDragMove==${JSON.stringify(event)}`)
          })
          .onItemDragLeave((event,itemIndex)=>{
            console.log(`itemDrag====onItemDragLeave==${JSON.stringify(event)}`)
          })
          .onItemDragEnter((event)=>{
            console.log(`itemDrag====onItemDragEnter==${JSON.stringify(event)}`)
          })
          .onItemDrop((event,itemIndex:number,insertIndex:number,isSuccess:boolean)=>{
            console.log(`itemDrag====onItemDrop==${JSON.stringify(event)}`)
            if (!isSuccess || insertIndex >= this.imageList.length) {
              return;
            }
            console.log(`itemIndex=${itemIndex},insertIndex=${insertIndex}`)
            // this.changeIndex(itemIndex,insertIndex)
            let tmp = this.dataList.splice(itemIndex, 1);
            console.log(`changeIndex===${tmp}`)
            this.dataList.splice(insertIndex, 0, tmp[0]);

          })
        }


      }
    }
  }
  changeIndex(index1: number, index2: number) {
    let tmp = this.imageList.splice(index1, 1);
    console.log(`changeIndex===${tmp}`)
    this.imageList.splice(index2, 0, tmp[0]);
  }
}